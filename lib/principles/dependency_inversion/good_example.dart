import '../../models/user.dart';

/// GOOD EXAMPLE: Follows Dependency Inversion Principle
/// 
/// High-level modules depend on abstractions (interfaces),
/// not concrete implementations. This enables flexibility and testability.

/// Abstraction: Database interface
abstract class UserRepository {
  void saveUser(User user);
  User? getUserById(String id);
}

/// Abstraction: Notification interface
abstract class NotificationService {
  void sendNotification(String recipient, String message);
}

/// Low-level module: MySQL implementation
class MySQLUserRepository implements UserRepository {
  @override
  void saveUser(User user) {
    print('Saving user ${user.id} to MySQL database');
  }

  @override
  User? getUserById(String id) {
    print('Getting user $id from MySQL database');
    return null;
  }
}

/// Low-level module: PostgreSQL implementation
class PostgreSQLUserRepository implements UserRepository {
  @override
  void saveUser(User user) {
    print('Saving user ${user.id} to PostgreSQL database');
  }

  @override
  User? getUserById(String id) {
    print('Getting user $id from PostgreSQL database');
    return null;
  }
}

/// Low-level module: Email notification
class EmailNotificationService implements NotificationService {
  @override
  void sendNotification(String recipient, String message) {
    print('Sending email to $recipient: $message');
  }
}

/// Low-level module: SMS notification
class SMSNotificationService implements NotificationService {
  @override
  void sendNotification(String recipient, String message) {
    print('Sending SMS to $recipient: $message');
  }
}

/// Low-level module: Push notification
class PushNotificationService implements NotificationService {
  @override
  void sendNotification(String recipient, String message) {
    print('Sending push notification to $recipient: $message');
  }
}

/// High-level module: UserService
/// GOOD: Depends on abstractions, not concrete classes
class UserService {
  final UserRepository _repository;
  final NotificationService _notificationService;

  /// Dependency injection - dependencies are injected, not created
  UserService({
    required UserRepository repository,
    required NotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  void registerUser(User user) {
    _repository.saveUser(user);
    _notificationService.sendNotification(
      user.email,
      'Welcome ${user.name}!',
    );
  }

  User? getUser(String id) {
    return _repository.getUserById(id);
  }
}

/// REAL-WORLD EXAMPLE: Payment Processing
/// 
/// High-level payment service depends on payment processor abstraction

abstract class PaymentProcessor {
  bool processPayment(double amount, Map<String, dynamic> details);
  String getProcessorName();
}

class StripeProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount, Map<String, dynamic> details) {
    print('Processing \$$amount via Stripe');
    return true;
  }

  @override
  String getProcessorName() => 'Stripe';
}

class PayPalProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount, Map<String, dynamic> details) {
    print('Processing \$$amount via PayPal');
    return true;
  }

  @override
  String getProcessorName() => 'PayPal';
}

class SquareProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount, Map<String, dynamic> details) {
    print('Processing \$$amount via Square');
    return true;
  }

  @override
  String getProcessorName() => 'Square';
}

/// High-level order service depends on PaymentProcessor abstraction
class OrderService {
  final PaymentProcessor _paymentProcessor;

  OrderService({required PaymentProcessor paymentProcessor})
      : _paymentProcessor = paymentProcessor;

  void processOrder(double amount, Map<String, dynamic> paymentDetails) {
    final success = _paymentProcessor.processPayment(amount, paymentDetails);
    if (success) {
      print('Order processed successfully via ${_paymentProcessor.getProcessorName()}');
    }
  }
}

/// REAL-WORLD EXAMPLE: Data Storage
/// 
/// High-level service depends on storage abstraction

abstract class DataStorage {
  void save(String key, String value);
  String? retrieve(String key);
  void delete(String key);
}

class FileStorage implements DataStorage {
  @override
  void save(String key, String value) {
    print('Saving $key to file system');
  }

  @override
  String? retrieve(String key) {
    print('Retrieving $key from file system');
    return null;
  }

  @override
  void delete(String key) {
    print('Deleting $key from file system');
  }
}

class CloudStorage implements DataStorage {
  @override
  void save(String key, String value) {
    print('Saving $key to cloud storage');
  }

  @override
  String? retrieve(String key) {
    print('Retrieving $key from cloud storage');
    return null;
  }

  @override
  void delete(String key) {
    print('Deleting $key from cloud storage');
  }
}

class CacheStorage implements DataStorage {
  final Map<String, String> _cache = {};

  @override
  void save(String key, String value) {
    _cache[key] = value;
    print('Saving $key to cache');
  }

  @override
  String? retrieve(String key) {
    print('Retrieving $key from cache');
    return _cache[key];
  }

  @override
  void delete(String key) {
    _cache.remove(key);
    print('Deleting $key from cache');
  }
}

/// High-level service depends on DataStorage abstraction
class SettingsService {
  final DataStorage _storage;

  SettingsService({required DataStorage storage}) : _storage = storage;

  void saveSetting(String key, String value) {
    _storage.save(key, value);
  }

  String? getSetting(String key) {
    return _storage.retrieve(key);
  }

  void removeSetting(String key) {
    _storage.delete(key);
  }
}

