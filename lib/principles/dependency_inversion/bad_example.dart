import '../../models/user.dart';

/// BAD EXAMPLE: Violates Dependency Inversion Principle
/// 
/// High-level modules depend directly on low-level concrete implementations.
/// This creates tight coupling and makes testing and changes difficult.

/// Low-level module: MySQL database
class MySQLDatabase {
  void saveUser(User user) {
    print('Saving user ${user.id} to MySQL database');
  }

  User? getUserById(String id) {
    print('Getting user $id from MySQL database');
    return null;
  }
}

/// Low-level module: Email service
class EmailService {
  void sendEmail(String email, String message) {
    print('Sending email to $email via SMTP: $message');
  }
}

/// High-level module: UserService
/// PROBLEM: Directly depends on concrete MySQLDatabase and EmailService
class UserService {
  final MySQLDatabase _database = MySQLDatabase(); // Direct dependency!
  final EmailService _emailService = EmailService(); // Direct dependency!

  void registerUser(User user) {
    _database.saveUser(user); // Tightly coupled to MySQL
    _emailService.sendEmail(user.email, 'Welcome!'); // Tightly coupled to EmailService
  }

  User? getUser(String id) {
    return _database.getUserById(id); // Can't easily switch to PostgreSQL
  }
}

/// Problems:
/// 1. Cannot easily switch from MySQL to PostgreSQL
/// 2. Cannot easily switch email providers
/// 3. Difficult to test (hard to mock dependencies)
/// 4. Tight coupling makes changes risky

/// Another bad example: Notification service
class SMSNotification {
  void sendSMS(String phone, String message) {
    print('Sending SMS to $phone: $message');
  }
}

class PushNotification {
  void sendPush(String userId, String message) {
    print('Sending push to $userId: $message');
  }
}

/// Order service directly depends on concrete notification classes
class OrderService {
  final SMSNotification _sms = SMSNotification();
  final PushNotification _push = PushNotification();

  void notifyOrderStatus(String userId, String status) {
    _sms.sendSMS('123-456-7890', 'Order status: $status');
    _push.sendPush(userId, 'Order status: $status');
  }
  // Cannot easily add email notifications or change providers
}

