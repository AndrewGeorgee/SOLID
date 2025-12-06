import '../../models/user.dart';

/// GOOD EXAMPLE: Follows Single Responsibility Principle
///
/// Each class has a single, well-defined responsibility:
/// - UserRepository: Only handles data storage/retrieval
/// - EmailValidator: Only validates email format
/// - EmailService: Only sends emails
/// - ReportGenerator: Only generates reports

/// Responsibility: User data management only
class UserRepository {
  final List<User> _users = [];

  void addUser(User user) {
    _users.add(user);
  }

  List<User> getAllUsers() {
    return List.unmodifiable(_users);
  }

  User? getUserById(String id) {
    return _users.firstWhere(
      (user) => user.id == id,
      orElse: () => throw Exception('User not found'),
    );
  }
}

/// Responsibility: Email validation only
class EmailValidator {
  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.') && email.length > 5;
  }
}

/// Responsibility: Email sending only
class EmailService {
  void sendEmail(String email, String subject, String body) {
    print('Sending email to $email');
    print('Subject: $subject');
    print('Body: $body');
    // Email sending logic...
  }
}

/// Responsibility: Report generation only
class ReportGenerator {
  String generateUserReport(List<User> users) {
    final totalUsers = users.length;
    final totalBalance = users.fold<double>(
      0.0,
      (sum, user) => sum + user.balance,
    );

    return '''
User Report:
============
Total Users: $totalUsers
Total Balance: \$${totalBalance.toStringAsFixed(2)}
Average Balance: \$${(totalBalance / totalUsers).toStringAsFixed(2)}
''';
  }
}

/// REAL-WORLD EXAMPLE: E-commerce Order Processing
///
/// Separated into distinct responsibilities:

/// Responsibility: Order data management
class OrderRepository {
  final List<Map<String, dynamic>> _orders = [];

  void saveOrder(Map<String, dynamic> order) {
    _orders.add(order);
  }

  List<Map<String, dynamic>> getOrdersByUserId(String userId) {
    return _orders.where((order) => order['userId'] == userId).toList();
  }
}

/// Responsibility: Payment processing only
class PaymentProcessor {
  bool processPayment(double amount, String paymentMethod) {
    print('Processing payment of \$$amount via $paymentMethod');
    // Payment processing logic...
    return true;
  }
}

/// Responsibility: Inventory management only
class InventoryManager {
  final Map<String, int> _stock = {};

  bool checkAvailability(String productId, int quantity) {
    final available = _stock[productId] ?? 0;
    return available >= quantity;
  }

  void updateStock(String productId, int quantity) {
    _stock[productId] = (_stock[productId] ?? 0) - quantity;
  }
}

/// Responsibility: Notification sending only
class NotificationService {
  void sendOrderConfirmation(String userId, String orderId) {
    print('Sending order confirmation to user $userId for order $orderId');
  }
}
