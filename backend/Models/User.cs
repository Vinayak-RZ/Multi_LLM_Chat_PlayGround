using backend.Models;
namespace backend.Models;

public class User
{
    public int Id { get; set; }
    public required string Email { get; set; }
    public required string Name { get; set; }
    public required string PasswordHash { get; set; }

    // Navigation property - one user can have many conversations
    public List<Conversation> Conversations { get; set; } = new();
}
