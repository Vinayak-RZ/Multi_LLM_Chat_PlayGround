using backend.Data;
using backend.Services;
using backend.DTOs;
using Microsoft.EntityFrameworkCore;


var builder = WebApplication.CreateBuilder(args);
builder.Services.AddDbContext<AppDbContext>(opt =>
    opt.UseSqlite("Data Source=users.db"));
builder.Services.AddScoped<AuthService>();

var app = builder.Build();

app.MapPost("/signup", async (RegisterRequest req, AuthService auth) =>
{
    var success = await auth.RegisterAsync(req.Email, req.Password, req.Name);
    if (success)
    {
        return Results.Ok(new { success = true, message = "User registered" });
    }
    else
    {
        return Results.BadRequest(new { success = false, message = "Email already in use" });
    }

});


app.MapPost("/login", async (string email, string password, AuthService auth) =>
{
    var success = await auth.LoginAsync(email, password);
    return success ? Results.Ok("Login successful") : Results.Unauthorized();
});

app.Run();
