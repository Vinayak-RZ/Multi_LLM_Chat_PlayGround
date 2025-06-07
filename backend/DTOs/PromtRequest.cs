namespace backend.DTOs
{
    public class PromptRequest
{
    public string Prompt { get; set; } = null!;
    public List<string> LLMs { get; set; } = new();  // ["openai", "gemini"]
}
}