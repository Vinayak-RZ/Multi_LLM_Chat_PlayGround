using backend.Models;
using backend.Data;
using Microsoft.EntityFrameworkCore;
using backend.DTOs;
using System.Net.Http;
using System.Text;
using System.Text.Json;

namespace backend.Services;

public class LLMService
{

    public static string EscapeJson(string str)
{
    return JsonSerializer.Serialize(str); // returns a fully escaped and quoted JSON string
}

    public async Task<string> CallDeepseekAsync(string prompt, string model = "deepseek-ai/DeepSeek-R1-0528")
    {
        Console.WriteLine("Calling DeepSeek Chat API with prompt: " + prompt);
        string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN")
                         ?? throw new InvalidOperationException("API key not found in environment variables.");

        string url = "https://router.huggingface.co/nebius/v1/chat/completions";
        Console.WriteLine("Prompt: " + EscapeJson(prompt));
        string jsonBody = $@"{{
        ""model"": ""{model}"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": {EscapeJson(prompt)}
            }}
        ]
    }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();


        using JsonDocument doc = JsonDocument.Parse(responseBody);
        var reply = doc.RootElement
                       .GetProperty("choices")[0]
                       .GetProperty("message")
                       .GetProperty("content")
                       .GetString();

        Console.WriteLine("Response: " + reply);
        return reply;
        // Optional: Parse the response (if needed)

    }


    public async Task<string> CallGeminiAsync(string prompt, string model = "gemini")
    {   
        Console.WriteLine("Calling Gemini API with prompt: " + prompt);
        string apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY") ?? throw new InvalidOperationException("API key not found in environment variables.");
        if (string.IsNullOrEmpty(apiKey))
        {
            throw new InvalidOperationException("API key is not set.");
        }
        string url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={apiKey}";

        string jsonBody = $@"
{{
    ""model"": ""deepseek-ai/DeepSeek-R1-0528-Qwen3-8B"",
    ""contents"": [
        {{
            ""role"": ""user"",
            ""parts"": [
                {{
                    ""text"": {EscapeJson(prompt)}
                }}
            ]
        }}
    ]
}}";


        using var client = new HttpClient();
        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();
        using JsonDocument doc = JsonDocument.Parse(responseBody);
        string reply = doc
            .RootElement
            .GetProperty("candidates")[0]
            .GetProperty("content")
            .GetProperty("parts")[0]
            .GetProperty("text")
            .GetString();

        Console.WriteLine("Response: " + reply);
        return reply;
    }
    private static readonly string apiUrl = "https://router.huggingface.co/together/v1/chat/completions";

    public async Task<string> CallMistralAsync(string prompt, string model = "mistralai/Mixtral-8x7B-Instruct-v0.1")
    {   
        Console.WriteLine("Calling Mistral API with prompt: " + prompt);
        string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN")
                         ?? throw new InvalidOperationException("API key not found in environment variables.");

        string jsonBody = $@"
        {{
            ""model"": ""{model}"",
            ""messages"": [
                {{
                    ""role"": ""user"",
                    ""content"": {EscapeJson(prompt)}
                }}
            ]
        }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");
        HttpResponseMessage response = await client.PostAsync(apiUrl, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        using JsonDocument doc = JsonDocument.Parse(responseBody);
        string reply = doc.RootElement
            .GetProperty("choices")[0]
            .GetProperty("message")
            .GetProperty("content")
            .GetString();
        Console.WriteLine("Response: " + reply);
        return reply;
    }
    public async Task<string> CallLlamaAsync(string prompt, string model = "Meta-Llama-3.1-8B-Instruct")
    {
        Console.WriteLine("Calling Llama API with prompt: " + prompt);
        string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN")
                         ?? throw new InvalidOperationException("API key not found in environment variables.");

        string url = "https://router.huggingface.co/sambanova/v1/chat/completions";

        string jsonBody = $@"
    {{
        ""model"": ""{model}"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": {EscapeJson(prompt)}
            }}
        ]
    }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        using JsonDocument doc = JsonDocument.Parse(responseBody);
        string reply = doc
            .RootElement
            .GetProperty("choices")[0]
            .GetProperty("message")
            .GetProperty("content")
            .GetString();

        Console.WriteLine(reply);
        return reply;
    }
}
