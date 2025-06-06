namespace backend.DTOs
{
    public class RegisterRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string Name { get; set; }
    }
}
// This DTO is used to encapsulate the data required for user registration.