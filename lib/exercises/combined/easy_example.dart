/// EXERCISE: Easy - Multiple SOLID Principles
///
/// TASK: Refactor this code to follow SOLID principles.
/// This code violates:
/// 1. Single Responsibility Principle (SRP) - handles user management AND email
/// 2. Dependency Inversion Principle (DIP) - directly depends on concrete EmailService
///
/// HINT:
/// - Split UserManager into separate classes (SRP)
/// - Create an abstract interface for email service and inject it (DIP)

class EmailService {
  void sendEmail(String to, String subject, String body) {
    print('Sending email to $to: $subject');
    // Email sending logic...
  }
}

/// Violates SRP (user management + email) and DIP (concrete dependency)
class UserManager {
  final List<Map<String, dynamic>> _users = [];
  final EmailService _emailService = EmailService(); // Direct dependency

  // User management responsibility
  void registerUser(String username, String email, String password) {
    _users.add({'username': username, 'email': email, 'password': password});
    print('User registered: $username');
  }

  Map<String, dynamic>? getUser(String username) {
    return _users.firstWhere(
      (user) => user['username'] == username,
      orElse: () => {},
    );
  }

  // Email responsibility - should be separated
  void sendWelcomeEmail(String email) {
    _emailService.sendEmail(email, 'Welcome!', 'Thank you for registering!');
  }

  void sendPasswordResetEmail(String email) {
    _emailService.sendEmail(
      email,
      'Password Reset',
      'Click here to reset your password.',
    );
  }
}
