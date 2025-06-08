using backend.Models;
namespace backend.Models;


public class Conversation
{
    public int Id { get; set; }
    public required string Prompt { get; set; }
    public required string ResponsesJson { get; set; } // Store all LLM responses as a JSON strin
    public required String UserEmail { get; set; } // Email of the user who created the conversation
}
