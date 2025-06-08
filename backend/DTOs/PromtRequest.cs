namespace backend.DTOs
{
    public class PromptRequest
{
    public string prompt { get; set; } = null!;
    public List<string> llms { get; set; } = new();  // ["openai", "gemini"]
}
}