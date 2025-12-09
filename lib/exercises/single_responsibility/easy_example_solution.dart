/// SOLUTION: Easy - Single Responsibility Principle
///
/// This solution demonstrates how to apply the Single Responsibility Principle
/// by separating user management and email operations into different classes.

/// ============================================================================
/// PART 1: User Management (Single Responsibility: Managing user data)
/// ============================================================================

class UserManager {
  final List<Map<String, dynamic>> _users = [];

  void addUser(String name, String email) {
    _users.add({'name': name, 'email': email});
  }

  List<Map<String, dynamic>> getAllUsers() {
    return List.unmodifiable(_users);
  }
}

/// ============================================================================
/// PART 2: Email Operations (Single Responsibility: Sending emails)
/// ============================================================================

class EmailOperations {
  void sendWelcomeEmail(String email) {
    print('Sending welcome email to $email');
    // Email sending logic...
  }

  void sendPasswordResetEmail(String email) {
    print('Sending password reset email to $email');
    // Email sending logic...
  }
}

/// ============================================================================
/// PART 3: User Service (Orchestrates user management and email operations)
/// ============================================================================

class UserService {
  final UserManager _userManager = UserManager();
  final EmailOperations _emailOperations = EmailOperations();

  /// Adds a user and sends welcome email
  void addUser(String name, String email) {
    // User management responsibility
    _userManager.addUser(name, email);

    // Email responsibility (delegated to EmailOperations)
    _emailOperations.sendWelcomeEmail(email);
  }

  /// Gets all users
  List<Map<String, dynamic>> getAllUsers() {
    return _userManager.getAllUsers();
  }

  /// Sends password reset email
  void sendPasswordReset(String email) {
    _emailOperations.sendPasswordResetEmail(email);
  }
}
