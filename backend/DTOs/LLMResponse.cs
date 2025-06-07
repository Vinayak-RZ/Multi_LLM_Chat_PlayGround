namespace backend.DTOs
{
    public class LLMResponse
    {
        public string LLMModel { get; set; } = null!;
        public string Response { get; set; } = null!;
    }
}