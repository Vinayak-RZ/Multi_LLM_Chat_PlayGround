using backend.Data;
using backend.Services;
using backend.DTOs;
using backend.Settings;
using backend.Helpers;
using backend.Extensions;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseSqlite("Data Source=users.db"));

builder.Services.AddScoped<AuthService>();

var jwtSettings = builder.Configuration.GetSection("JwtSettings").Get<JWTSettings>();
builder.Services.AddSingleton(jwtSettings);

builder.Services.AddJwtAuthentication(jwtSettings); // Extension method

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

app.Run();
