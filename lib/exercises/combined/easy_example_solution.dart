/// SOLUTION: Easy - Multiple SOLID Principles (SRP + DIP)
///
/// This solution demonstrates how to apply both Single Responsibility Principle
/// and Dependency Inversion Principle together.

/// ============================================================================
/// PART 1: User Management (SRP - Single Responsibility: Managing users)
/// ============================================================================

class UserManager {
  final List<Map<String, dynamic>> _users = [];

  void registerUser(String username, String email, String password) {
    _users.add({'username': username, 'email': email, 'password': password});
    print('User registered: $username');
  }

  Map<String, dynamic>? getUser(String username) {
    try {
      return _users.firstWhere((user) => user['username'] == username);
    } catch (e) {
      return null;
    }
  }
}

/// ============================================================================
/// PART 2: Email Operations (SRP - Single Responsibility: Email operations)
/// ============================================================================

class EmailOperations {
  final EmailService _emailService;

  EmailOperations({required EmailService emailService})
    : _emailService = emailService;

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

/// ============================================================================
/// PART 3: Email Service Abstraction (DIP - Dependency Inversion)
/// ============================================================================

abstract class EmailService {
  void sendEmail(String to, String subject, String body);
}

/// ============================================================================
/// PART 4: Email Service Implementation (DIP - Low-level module)
/// ============================================================================

class SMTPEmailService implements EmailService {
  @override
  void sendEmail(String to, String subject, String body) {
    print('Sending email to $to: $subject');
    // SMTP-specific logic...
  }
}

/// Alternative implementation example
class SendGridEmailService implements EmailService {
  @override
  void sendEmail(String to, String subject, String body) {
    print('Sending email via SendGrid to $to: $subject');
    // SendGrid-specific logic...
  }
}

/// ============================================================================
/// PART 5: User Service (Orchestrates UserManager + EmailOperations with DIP)
/// ============================================================================

class UserService {
  final UserManager _userManager;
  final EmailOperations _emailOperations;

  /// Constructor injection - depends on abstraction (DIP)
  UserService({
    required UserManager userManager,
    required EmailService emailService,
  }) : _userManager = userManager,
       _emailOperations = EmailOperations(emailService: emailService);

  /// Registers user and sends welcome email
  void registerUser(String username, String email, String password) {
    // User management responsibility (delegated to UserManager)
    _userManager.registerUser(username, email, password);

    // Email responsibility (delegated to EmailOperations)
    _emailOperations.sendWelcomeEmail(email);
  }

  /// Gets user by username
  Map<String, dynamic>? getUser(String username) {
    return _userManager.getUser(username);
  }

  /// Sends password reset email
  void sendPasswordReset(String email) {
    _emailOperations.sendPasswordResetEmail(email);
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void exampleUsage() {
  // Example 1: Use SMTP email service
  final userService1 = UserService(
    userManager: UserManager(),
    emailService: SMTPEmailService(),
  );
  userService1.registerUser('john', 'john@example.com', 'password123');

  // Example 2: Use SendGrid email service (easy to swap - DIP benefit)
  final userService2 = UserService(
    userManager: UserManager(),
    emailService: SendGridEmailService(),
  );
  userService2.registerUser('jane', 'jane@example.com', 'password456');
}
