import '../../models/user.dart';
import '../../models/order.dart';
import '../../models/transaction.dart';

/// COMPLEX REAL-WORLD EXAMPLE: E-Commerce System
/// 
/// Demonstrates Single Responsibility Principle in a complex enterprise system
/// with multiple interconnected components, each with a single responsibility.

// ============================================================================
// DATA LAYER - Single Responsibility: Data Persistence
// ============================================================================

abstract class IUserRepository {
  Future<User?> findById(String id);
  Future<User?> findByEmail(String email);
  Future<List<User>> findAll();
  Future<void> save(User user);
  Future<void> update(User user);
  Future<void> delete(String id);
  Future<bool> exists(String id);
}

class UserRepository implements IUserRepository {
  final Map<String, User> _users = {};
  final Map<String, String> _emailIndex = {}; // Email -> UserId mapping

  @override
  Future<User?> findById(String id) async {
    await _simulateDelay();
    return _users[id];
  }

  @override
  Future<User?> findByEmail(String email) async {
    await _simulateDelay();
    final userId = _emailIndex[email.toLowerCase()];
    return userId != null ? _users[userId] : null;
  }

  @override
  Future<List<User>> findAll() async {
    await _simulateDelay();
    return List.unmodifiable(_users.values);
  }

  @override
  Future<void> save(User user) async {
    await _simulateDelay();
    _users[user.id] = user;
    _emailIndex[user.email.toLowerCase()] = user.id;
  }

  @override
  Future<void> update(User user) async {
    await _simulateDelay();
    if (_users.containsKey(user.id)) {
      _users[user.id] = user;
      _emailIndex[user.email.toLowerCase()] = user.id;
    }
  }

  @override
  Future<void> delete(String id) async {
    await _simulateDelay();
    final user = _users.remove(id);
    if (user != null) {
      _emailIndex.remove(user.email.toLowerCase());
    }
  }

  @override
  Future<bool> exists(String id) async {
    await _simulateDelay();
    return _users.containsKey(id);
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

abstract class IOrderRepository {
  Future<Order?> findById(String id);
  Future<List<Order>> findByUserId(String userId);
  Future<List<Order>> findByStatus(OrderStatus status);
  Future<void> save(Order order);
  Future<void> updateStatus(String orderId, OrderStatus status);
}

class OrderRepository implements IOrderRepository {
  final Map<String, Order> _orders = {};
  final Map<String, List<String>> _userOrders = {}; // UserId -> OrderIds
  final Map<OrderStatus, List<String>> _statusOrders = {}; // Status -> OrderIds

  @override
  Future<Order?> findById(String id) async {
    await _simulateDelay();
    return _orders[id];
  }

  @override
  Future<List<Order>> findByUserId(String userId) async {
    await _simulateDelay();
    final orderIds = _userOrders[userId] ?? [];
    return orderIds.map((id) => _orders[id]!).whereType<Order>().toList();
  }

  @override
  Future<List<Order>> findByStatus(OrderStatus status) async {
    await _simulateDelay();
    final orderIds = _statusOrders[status] ?? [];
    return orderIds.map((id) => _orders[id]!).whereType<Order>().toList();
  }

  @override
  Future<void> save(Order order) async {
    await _simulateDelay();
    _orders[order.id] = order;
    _userOrders.putIfAbsent(order.userId, () => []).add(order.id);
    _statusOrders.putIfAbsent(order.status, () => []).add(order.id);
  }

  @override
  Future<void> updateStatus(String orderId, OrderStatus newStatus) async {
    await _simulateDelay();
    final order = _orders[orderId];
    if (order != null) {
      // Remove from old status index
      _statusOrders[order.status]?.remove(orderId);
      // Add to new status index
      final updatedOrder = Order(
        id: order.id,
        userId: order.userId,
        items: order.items,
        subtotal: order.subtotal,
        tax: order.tax,
        shipping: order.shipping,
        total: order.total,
        status: newStatus,
        createdAt: order.createdAt,
        paymentInfo: order.paymentInfo,
        shippingAddress: order.shippingAddress,
      );
      _orders[orderId] = updatedOrder;
      _statusOrders.putIfAbsent(newStatus, () => []).add(orderId);
    }
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

// ============================================================================
// VALIDATION LAYER - Single Responsibility: Input Validation
// ============================================================================

abstract class IValidator<T> {
  ValidationResult validate(T value);
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, this.errors = const []});
}

class EmailValidator implements IValidator<String> {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  ValidationResult validate(String email) {
    final errors = <String>[];

    if (email.isEmpty) {
      errors.add('Email cannot be empty');
    } else if (!_emailRegex.hasMatch(email)) {
      errors.add('Invalid email format');
    } else if (email.length > 255) {
      errors.add('Email is too long (max 255 characters)');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

class PasswordValidator implements IValidator<String> {
  @override
  ValidationResult validate(String password) {
    final errors = <String>[];

    if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      errors.add('Password must contain at least one uppercase letter');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('Password must contain at least one lowercase letter');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('Password must contain at least one number');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add('Password must contain at least one special character');
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

class OrderValidator implements IValidator<Order> {
  @override
  ValidationResult validate(Order order) {
    final errors = <String>[];

    if (order.items.isEmpty) {
      errors.add('Order must have at least one item');
    }

    if (order.total <= 0) {
      errors.add('Order total must be greater than zero');
    }

    if (order.userId.isEmpty) {
      errors.add('Order must have a valid user ID');
    }

    for (final item in order.items) {
      if (item.quantity <= 0) {
        errors.add('Item ${item.productName} has invalid quantity');
      }
      if (item.unitPrice <= 0) {
        errors.add('Item ${item.productName} has invalid price');
      }
      final expectedTotal = item.unitPrice * item.quantity;
      if ((item.totalPrice - expectedTotal).abs() > 0.01) {
        errors.add('Item ${item.productName} has incorrect total price');
      }
    }

    return ValidationResult(isValid: errors.isEmpty, errors: errors);
  }
}

// ============================================================================
// NOTIFICATION LAYER - Single Responsibility: Notifications
// ============================================================================

abstract class INotificationService {
  Future<void> send(String recipient, String subject, String body);
  Future<void> sendBulk(List<String> recipients, String subject, String body);
}

class EmailNotificationService implements INotificationService {
  @override
  Future<void> send(String recipient, String subject, String body) async {
    await _simulateDelay();
    print('[EMAIL] To: $recipient | Subject: $subject');
    print('[EMAIL] Body: $body');
  }

  @override
  Future<void> sendBulk(
    List<String> recipients,
    String subject,
    String body,
  ) async {
    for (final recipient in recipients) {
      await send(recipient, subject, body);
    }
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 50));
  }
}

class SMSNotificationService implements INotificationService {
  @override
  Future<void> send(String recipient, String subject, String body) async {
    await _simulateDelay();
    print('[SMS] To: $recipient | Message: $body');
  }

  @override
  Future<void> sendBulk(
    List<String> recipients,
    String subject,
    String body,
  ) async {
    for (final recipient in recipients) {
      await send(recipient, subject, body);
    }
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 30));
  }
}

// ============================================================================
// LOGGING LAYER - Single Responsibility: Logging
// ============================================================================

enum LogLevel { debug, info, warning, error, critical }

abstract class ILogger {
  void log(LogLevel level, String message, [Map<String, dynamic>? context]);
  void debug(String message, [Map<String, dynamic>? context]);
  void info(String message, [Map<String, dynamic>? context]);
  void warning(String message, [Map<String, dynamic>? context]);
  void error(String message, [Map<String, dynamic>? context]);
  void critical(String message, [Map<String, dynamic>? context]);
}

class ConsoleLogger implements ILogger {
  @override
  void log(LogLevel level, String message, [Map<String, dynamic>? context]) {
    final timestamp = DateTime.now().toIso8601String();
    final contextStr = context != null ? ' | Context: $context' : '';
    print('[$timestamp] [$level] $message$contextStr');
  }

  @override
  void debug(String message, [Map<String, dynamic>? context]) {
    log(LogLevel.debug, message, context);
  }

  @override
  void info(String message, [Map<String, dynamic>? context]) {
    log(LogLevel.info, message, context);
  }

  @override
  void warning(String message, [Map<String, dynamic>? context]) {
    log(LogLevel.warning, message, context);
  }

  @override
  void error(String message, [Map<String, dynamic>? context]) {
    log(LogLevel.error, message, context);
  }

  @override
  void critical(String message, [Map<String, dynamic>? context]) {
    log(LogLevel.critical, message, context);
  }
}

// ============================================================================
// CALCULATION LAYER - Single Responsibility: Business Calculations
// ============================================================================

abstract class IPriceCalculator {
  double calculateSubtotal(List<OrderItem> items);
  double calculateTax(double subtotal, String region);
  double calculateShipping(double subtotal, ShippingAddress address);
  double calculateTotal(double subtotal, double tax, double shipping);
}

class PriceCalculator implements IPriceCalculator {
  static const double defaultTaxRate = 0.08; // 8%
  final Map<String, double> _regionTaxRates = {
    'CA': 0.10,
    'NY': 0.08,
    'TX': 0.06,
  };

  @override
  double calculateSubtotal(List<OrderItem> items) {
    return items.fold<double>(
      0.0,
      (sum, item) => sum + item.totalPrice,
    );
  }

  @override
  double calculateTax(double subtotal, String region) {
    final taxRate = _regionTaxRates[region] ?? defaultTaxRate;
    return subtotal * taxRate;
  }

  @override
  double calculateShipping(double subtotal, ShippingAddress address) {
    // Complex shipping calculation based on address and order value
    double baseShipping = 5.0;
    if (subtotal > 100) {
      baseShipping = 0; // Free shipping over $100
    } else if (subtotal > 50) {
      baseShipping = 2.0; // Reduced shipping
    }

    // International shipping surcharge
    if (address.country != 'US') {
      baseShipping += 15.0;
    }

    return baseShipping;
  }

  @override
  double calculateTotal(double subtotal, double tax, double shipping) {
    return subtotal + tax + shipping;
  }
}

// ============================================================================
// REPORTING LAYER - Single Responsibility: Report Generation
// ============================================================================

abstract class IReportGenerator {
  String generateUserReport(List<User> users);
  String generateOrderReport(List<Order> orders);
  String generateFinancialReport(List<Transaction> transactions);
}

class ReportGenerator implements IReportGenerator {
  @override
  String generateUserReport(List<User> users) {
    final totalUsers = users.length;
    final totalBalance = users.fold<double>(
      0.0,
      (sum, user) => sum + user.balance,
    );
    final avgBalance = totalUsers > 0 ? totalBalance / totalUsers : 0.0;
    final activeUsers = users.where((u) => u.balance > 0).length;

    return '''
USER REPORT
==========
Generated: ${DateTime.now().toIso8601String()}
Total Users: $totalUsers
Active Users: $activeUsers
Total Balance: \$${totalBalance.toStringAsFixed(2)}
Average Balance: \$${avgBalance.toStringAsFixed(2)}
''';
  }

  @override
  String generateOrderReport(List<Order> orders) {
    final totalOrders = orders.length;
    final totalRevenue = orders.fold<double>(
      0.0,
      (sum, order) => sum + order.total,
    );
    final statusCounts = <OrderStatus, int>{};
    for (final order in orders) {
      statusCounts[order.status] = (statusCounts[order.status] ?? 0) + 1;
    }

    final statusReport = statusCounts.entries
        .map((e) => '  ${e.key}: ${e.value}')
        .join('\n');

    return '''
ORDER REPORT
===========
Generated: ${DateTime.now().toIso8601String()}
Total Orders: $totalOrders
Total Revenue: \$${totalRevenue.toStringAsFixed(2)}
Average Order Value: \$${(totalRevenue / totalOrders).toStringAsFixed(2)}
Order Status Breakdown:
$statusReport
''';
  }

  @override
  String generateFinancialReport(List<Transaction> transactions) {
    final totalTransactions = transactions.length;
    final totalAmount = transactions.fold<double>(
      0.0,
      (sum, txn) => sum + txn.amount,
    );
    final typeCounts = <TransactionType, int>{};
    final statusCounts = <TransactionStatus, int>{};

    for (final txn in transactions) {
      typeCounts[txn.type] = (typeCounts[txn.type] ?? 0) + 1;
      statusCounts[txn.status] = (statusCounts[txn.status] ?? 0) + 1;
    }

    return '''
FINANCIAL REPORT
===============
Generated: ${DateTime.now().toIso8601String()}
Total Transactions: $totalTransactions
Total Amount: \$${totalAmount.toStringAsFixed(2)}
Transaction Types: ${typeCounts.length}
Transaction Statuses: ${statusCounts.length}
''';
  }
}

// ============================================================================
// CACHING LAYER - Single Responsibility: Caching
// ============================================================================

abstract class ICacheService {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value, {Duration? ttl});
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> exists(String key);
}

class MemoryCacheService implements ICacheService {
  final Map<String, _CacheEntry> _cache = {};

  @override
  Future<T?> get<T>(String key) async {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.expiresAt != null && DateTime.now().isAfter(entry.expiresAt!)) {
      _cache.remove(key);
      return null;
    }

    return entry.value as T;
  }

  @override
  Future<void> set<T>(String key, T value, {Duration? ttl}) async {
    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    _cache[key] = _CacheEntry(value: value, expiresAt: expiresAt);
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    _cache.clear();
  }

  @override
  Future<bool> exists(String key) async {
    final entry = _cache[key];
    if (entry == null) return false;
    if (entry.expiresAt != null && DateTime.now().isAfter(entry.expiresAt!)) {
      _cache.remove(key);
      return false;
    }
    return true;
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime? expiresAt;

  _CacheEntry({required this.value, this.expiresAt});
}

