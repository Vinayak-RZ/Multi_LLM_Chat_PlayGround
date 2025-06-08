# Multi-LLM Chat Playground

A full-stack playground that lets users chat with multiple Large Language Models (LLMs) — including **Gemini**, **DeepSeek**, **LLaMA**, and **Mistral** — all from a unified interface.

Built with:
- **Flutter + BLoC** for the frontend
- **C# Minimal APIs + Entity Framework** for the backend
- **JWT-based Authentication**
- **LLM Calls** via Hugging Face and Google AI Studio
---

## Features

- **User Authentication** (Sign Up / Login)
- **Send prompts to multiple LLMs at once**
- **Parallel response fetching** using backend orchestration
- **Responses shown as cards** (tap to view or select)
- **Send one LLM's output as input to another**
- **Saving State For Funtional Back Button** via bloc
- **Conversations saved in backend**
---
## Backend Setup And Run
- dotnet restore
- dotnet ef database update
- dotnet run
---
## Frontend Setup And Run
- flutter pub get
- flutter run
----
