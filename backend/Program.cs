using backend.Data;
using backend.Services;
using backend.DTOs;
using backend.Settings;
using backend.Helpers;
using backend.Extensions;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Authorization;
using DotNetEnv;



var builder = WebApplication.CreateBuilder(args);

DotNetEnv.Env.Load();

builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseSqlite("Data Source=users.db"));


builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<LLMService>();

var jwtSettings = new JWTSettings();
builder.Configuration.GetSection("JwtSettings").Bind(jwtSettings);//just fallback values in appsettings.jsonas now using .env vars for these
builder.Services.AddSingleton(jwtSettings!);// ! is to suppress nullability warning, ensure JwtSettings is configured in appsettings.json

builder.Services.AddJwtAuthentication(jwtSettings!); // Extension method
builder.Services.AddAuthorization();
var app = builder.Build();

app.UseAuthentication();
app.UseAuthorization();

app.MapPost("/signup", async (RegisterRequest req, AuthService auth) =>
{
    var success = await auth.RegisterAsync(req.Email, req.Password, req.Name);
    return success
        ? Results.Ok(new { success = true, message = "User registered" })
        : Results.BadRequest(new { success = false, message = "Email already in use" });
});

app.MapPost("/login", async (LoginRequest req, AuthService auth, JWTSettings jwtSettings) =>
{
    var user = await auth.ValidateUserAsync(req.Email, req.Password);
    if (user == null) return Results.Unauthorized();

    var token = JwtTokenHelper.GenerateJwtToken(user, jwtSettings);
    return Results.Ok(new { token });
});
app.MapPost("/prompt", [Authorize] async (PromptRequest request,LLMService llmService, HttpContext context) =>
{
    var tasks = request.LLMs.Select(async llm =>
    {
        string response = llm.ToLower() switch
        {
            "deepseek" => await llmService.CallDeepseekAsync(request.Prompt),
            "gemini" => await llmService.CallGeminiAsync(request.Prompt),
            "mistral" => await llmService.CallMistralAsync(request.Prompt),
            "llama" => await llmService.CallLlamaAsync(request.Prompt),
            _ => "Unsupported LLM"
        };

        return new LLMResponse { LLMModel = llm, Response = response };
    });

    var responses = await Task.WhenAll(tasks);
    return Results.Ok(responses);
});

app.Run();
