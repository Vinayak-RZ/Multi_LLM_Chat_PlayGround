using backend.Models;
using backend.Data;
using Microsoft.EntityFrameworkCore;
using backend.DTOs;
using System.Net.Http;
using System.Text;

namespace backend.Services;

public class LLMService
{

    private static string EscapeJson(string input)
    {
        return input.Replace("\\", "\\\\").Replace("\"", "\\\"");
    }
    public async Task<string> CallDeepseekAsync(string prompt, string model = "deepseek")
    {
        string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN")
                         ?? throw new InvalidOperationException("API key not found in environment variables.");

        string url = "https://api.endpoints.huggingface.cloud/v1/chat/completions";

        string jsonBody = $@"
    {{
        ""model"": ""deepseek-ai/DeepSeek-R1-0528-Qwen3-8B"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": ""{EscapeJson(prompt)}""
            }}
        ]
    }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine(responseBody);
        return responseBody;
    }

    public async Task<string> CallGeminiAsync(string prompt, string model = "gemini")
    {
        string apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY") ?? throw new InvalidOperationException("API key not found in environment variables.");
        if (string.IsNullOrEmpty(apiKey))
        {
            throw new InvalidOperationException("API key is not set.");
        }
        string url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={apiKey}";

        string jsonBody = $@"
    {{
        ""model"": ""deepseek-ai/DeepSeek-R1-0528-Qwen3-8B"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": ""{EscapeJson(prompt)}""
            }}
        ]
    }}";

        using var client = new HttpClient();
        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine(responseBody);
        return responseBody;
    }
    public async Task<string> CallMistralAsync(string prompt, string model = "mistral")
    {
        string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN") ?? throw new InvalidOperationException("API key not found in environment variables.");
        if (string.IsNullOrEmpty(hfToken))
        {
            throw new InvalidOperationException("API key is not set.");
        }
        string url = "https://api.endpoints.huggingface.cloud/v1/chat/completions"; // Unified endpoint

        string jsonBody = $@"
    {{
        ""model"": ""deepseek-ai/DeepSeek-R1-0528-Qwen3-8B"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": ""{EscapeJson(prompt)}""
            }}
        ]
    }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine(responseBody);
        return responseBody;
    }
    public async Task<string> CallLlamaAsync(string prompt, string model = "llama")
    {
       string hfToken = Environment.GetEnvironmentVariable("HF_TOKEN") ?? throw new InvalidOperationException("API key not found in environment variables.");
        if (string.IsNullOrEmpty(hfToken))
        {
            throw new InvalidOperationException("API key is not set.");
        }
        string url = "https://api.endpoints.huggingface.cloud/v1/chat/completions"; // Unified endpoint

        string jsonBody = $@"
    {{
        ""model"": ""meta-llama/Llama-3.1-8B-Instruct"",
        ""messages"": [
            {{
                ""role"": ""user"",
                ""content"": ""{EscapeJson(prompt)}""
            }}
        ]
    }}";

        using var client = new HttpClient();
        client.DefaultRequestHeaders.Add("Authorization", $"Bearer {hfToken}");

        var content = new StringContent(jsonBody, Encoding.UTF8, "application/json");

        HttpResponseMessage response = await client.PostAsync(url, content);
        string responseBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine(responseBody);
        return responseBody;
    }
}