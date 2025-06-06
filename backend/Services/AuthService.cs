using backend.Models;
using backend.Data;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;

namespace backend.Services;

public class AuthService
{
    private readonly AppDbContext _db;

    public AuthService(AppDbContext db)
    {
        _db = db;
    }

    public async Task<bool> RegisterAsync(string email, string password,string name)
    {
        if (await _db.Users.AnyAsync(u => u.Email == email))
            return false;//to make unique email

        var hash = HashPassword(password);
        var user = new User { Email = email, PasswordHash = hash,  Name = name};
        _db.Users.Add(user);
        await _db.SaveChangesAsync();
        return true;
    }

    public async Task<bool> LoginAsync(string email, string password)
    {
        var user = await _db.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null) return false;

        return user.PasswordHash == HashPassword(password);
    }

    private string HashPassword(string password)
    {
        using var sha256 = SHA256.Create();
        var bytes = Encoding.UTF8.GetBytes(password);
        var hash = sha256.ComputeHash(bytes);
        return Convert.ToBase64String(hash);
    }
}
