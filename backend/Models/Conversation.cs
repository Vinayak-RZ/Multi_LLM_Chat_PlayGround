using backend.Models;
namespace backend.Models;


public class Conversation
{
    public int Id { get; set; }
    public required string Prompt { get; set; }
    public required string ResponsesJson { get; set; } // Store all LLM responses as a JSON string
    public string? SelectedResponse { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // Foreign key
    public int UserId { get; set; }
    public User User { get; set; }
}
