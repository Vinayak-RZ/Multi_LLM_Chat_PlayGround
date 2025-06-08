namespace backend.DTOs
{
    public class PromptRequest
{   
    public string email { get; set; } = null!;
    public string prompt { get; set; } = null!;
    public List<string> llms { get; set; } = new();  // ["openai", "gemini"]
}
}