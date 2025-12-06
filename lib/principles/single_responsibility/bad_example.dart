import '../../models/user.dart';

/// BAD EXAMPLE: Violates Single Responsibility Principle
///
/// This class has multiple responsibilities:
/// 1. User data management
/// 2. Email validation
/// 3. Email sending
/// 4. Database operations
/// 5. Report generation
///
/// If any of these change, this class needs to be modified.
class UserManager {
  final List<User> _users = [];

  // Responsibility 1: Data management
  void addUser(User user) {
    _users.add(user);
  }

  // Responsibility 2: Email validation
  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  // Responsibility 3: Email sending
  void sendEmail(String email, String subject, String body) {
    print('Sending email to $email: $subject');
    // Email sending logic...
  }

  // Responsibility 4: Database operations
  void saveToDatabase(User user) {
    print('Saving user ${user.id} to database...');
    // Database logic...
  }

  // Responsibility 5: Report generation
  String generateReport() {
    return 'Total users: ${_users.length}';
  }
}
