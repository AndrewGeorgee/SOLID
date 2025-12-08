/// EXERCISE: Easy - Single Responsibility Principle
///
/// TASK: Refactor this class to follow Single Responsibility Principle.
/// This class currently handles both user data management and email operations.
///
/// HINT: Split into separate classes - one for user management, one for email operations.

class UserService {
  final List<Map<String, dynamic>> _users = [];

  // User management responsibility
  void addUser(String name, String email) {
    _users.add({'name': name, 'email': email});
  }

  List<Map<String, dynamic>> getAllUsers() {
    return List.unmodifiable(_users);
  }

  // Email responsibility - should be separated
  void sendWelcomeEmail(String email) {
    print('Sending welcome email to $email');
    // Email sending logic...
  }

  void sendPasswordResetEmail(String email) {
    print('Sending password reset email to $email');
    // Email sending logic...
  }
}
