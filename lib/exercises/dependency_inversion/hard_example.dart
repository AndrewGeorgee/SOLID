/// EXERCISE: Hard - Dependency Inversion Principle
///
/// TASK: Refactor this code to follow Dependency Inversion Principle.
/// Currently, ECommerceService directly depends on multiple concrete implementations:
/// - Database, Cache, Logger, EmailService, PaymentGateway, ShippingService
/// Adding new implementations or changing existing ones requires modifying ECommerceService.
///
/// HINT: Create abstractions (interfaces/abstract classes) for each dependency:
/// - IRepository (for database)
/// - ICache (for caching)
/// - ILogger (for logging)
/// - INotificationService (for notifications)
/// - IPaymentGateway (for payments)
/// - IShippingService (for shipping)
/// Inject all dependencies through constructor.

class MySQLDatabase {
  void save(String table, Map<String, dynamic> data) {
    print('Saving to MySQL: $table');
    // MySQL-specific logic...
  }

  Map<String, dynamic>? findById(String table, String id) {
    print('Finding in MySQL: $table, id: $id');
    return {'id': id};
  }

  List<Map<String, dynamic>> query(String sql) {
    print('Querying MySQL: $sql');
    return [];
  }
}

class RedisCache {
  void set(String key, String value, {int? ttl}) {
    print('Caching in Redis: $key');
    // Redis-specific logic...
  }

  String? get(String key) {
    print('Getting from Redis: $key');
    return null;
  }

  void delete(String key) {
    print('Deleting from Redis: $key');
  }
}

class ConsoleLogger {
  void info(String message) {
    print('INFO: $message');
  }

  void error(String message) {
    print('ERROR: $message');
  }

  void debug(String message) {
    print('DEBUG: $message');
  }
}

class SMTPEmailService {
  void send(String to, String subject, String body) {
    print('Sending email via SMTP to $to: $subject');
    // SMTP-specific logic...
  }
}

class StripePaymentGateway {
  bool charge(double amount, String cardToken) {
    print('Charging via Stripe: \$$amount');
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via Stripe: $transactionId');
  }
}

class FedExShippingService {
  String createShipment(String address, double weight) {
    print('Creating FedEx shipment to $address');
    return 'fedex_12345';
  }

  void trackShipment(String trackingNumber) {
    print('Tracking FedEx shipment: $trackingNumber');
  }
}

/// ECommerceService directly depends on all concrete implementations (violates DIP)
class ECommerceService {
  final MySQLDatabase _database = MySQLDatabase(); // Direct dependency
  final RedisCache _cache = RedisCache(); // Direct dependency
  final ConsoleLogger _logger = ConsoleLogger(); // Direct dependency
  final SMTPEmailService _emailService =
      SMTPEmailService(); // Direct dependency
  final StripePaymentGateway _paymentGateway =
      StripePaymentGateway(); // Direct dependency
  final FedExShippingService _shippingService =
      FedExShippingService(); // Direct dependency

  void processOrder(String orderId, Map<String, dynamic> orderData) {
    _logger.info('Processing order: $orderId');

    // Check cache first
    final cachedOrder = _cache.get('order_$orderId');
    if (cachedOrder != null) {
      _logger.debug('Order found in cache');
      return;
    }

    // Save to database
    _database.save('orders', {'id': orderId, ...orderData});

    // Process payment
    final paymentSuccess = _paymentGateway.charge(
      orderData['amount'] ?? 0.0,
      orderData['cardToken'] ?? '',
    );

    if (!paymentSuccess) {
      _logger.error('Payment failed for order: $orderId');
      return;
    }

    // Create shipment
    final trackingNumber = _shippingService.createShipment(
      orderData['address'] ?? '',
      orderData['weight'] ?? 0.0,
    );

    // Update order with tracking
    _database.save('orders', {
      'id': orderId,
      'trackingNumber': trackingNumber,
      'status': 'shipped',
    });

    // Cache the order
    _cache.set('order_$orderId', 'processed', ttl: 3600);

    // Send confirmation email
    _emailService.send(
      orderData['customerEmail'] ?? '',
      'Order Confirmation',
      'Your order $orderId has been shipped. Tracking: $trackingNumber',
    );

    _logger.info('Order processed successfully: $orderId');
  }

  void cancelOrder(String orderId) {
    _logger.info('Cancelling order: $orderId');

    final order = _database.findById('orders', orderId);
    if (order == null) {
      _logger.error('Order not found: $orderId');
      return;
    }

    // Refund payment
    _paymentGateway.refund(order['transactionId'] ?? '');

    // Update database
    _database.save('orders', {'id': orderId, 'status': 'cancelled'});

    // Remove from cache
    _cache.delete('order_$orderId');

    // Send cancellation email
    _emailService.send(
      order['customerEmail'] ?? '',
      'Order Cancelled',
      'Your order $orderId has been cancelled and refunded.',
    );

    _logger.info('Order cancelled: $orderId');
  }
}
