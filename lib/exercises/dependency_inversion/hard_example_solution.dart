/// SOLUTION: Hard - Dependency Inversion Principle
///
/// This solution demonstrates how to apply the Dependency Inversion Principle
/// by creating abstractions for all dependencies and injecting them.

/// ============================================================================
/// PART 1: ABSTRACT INTERFACES (Abstractions)
/// ============================================================================

abstract class IRepository {
  void save(String table, Map<String, dynamic> data);
  Map<String, dynamic>? findById(String table, String id);
  List<Map<String, dynamic>> query(String sql);
}

abstract class ICache {
  void set(String key, String value, {int? ttl});
  String? get(String key);
  void delete(String key);
}

abstract class ILogger {
  void info(String message);
  void error(String message);
  void debug(String message);
}

abstract class INotificationService {
  void send(String to, String subject, String body);
}

abstract class IPaymentGateway {
  bool charge(double amount, String cardToken);
  void refund(String transactionId);
}

abstract class IShippingService {
  String createShipment(String address, double weight);
  void trackShipment(String trackingNumber);
}

/// ============================================================================
/// PART 2: CONCRETE IMPLEMENTATIONS (Low-level modules)
/// ============================================================================

class MySQLRepository implements IRepository {
  @override
  void save(String table, Map<String, dynamic> data) {
    print('Saving to MySQL: $table');
    // MySQL-specific logic...
  }

  @override
  Map<String, dynamic>? findById(String table, String id) {
    print('Finding in MySQL: $table, id: $id');
    return {'id': id};
  }

  @override
  List<Map<String, dynamic>> query(String sql) {
    print('Querying MySQL: $sql');
    return [];
  }
}

class RedisCache implements ICache {
  @override
  void set(String key, String value, {int? ttl}) {
    print('Caching in Redis: $key');
    // Redis-specific logic...
  }

  @override
  String? get(String key) {
    print('Getting from Redis: $key');
    return null;
  }

  @override
  void delete(String key) {
    print('Deleting from Redis: $key');
  }
}

class ConsoleLogger implements ILogger {
  @override
  void info(String message) {
    print('INFO: $message');
  }

  @override
  void error(String message) {
    print('ERROR: $message');
  }

  @override
  void debug(String message) {
    print('DEBUG: $message');
  }
}

class SMTPEmailService implements INotificationService {
  @override
  void send(String to, String subject, String body) {
    print('Sending email via SMTP to $to: $subject');
    // SMTP-specific logic...
  }
}

class StripePaymentGateway implements IPaymentGateway {
  @override
  bool charge(double amount, String cardToken) {
    print('Charging via Stripe: \$$amount');
    return true;
  }

  @override
  void refund(String transactionId) {
    print('Refunding via Stripe: $transactionId');
  }
}

class FedExShippingService implements IShippingService {
  @override
  String createShipment(String address, double weight) {
    print('Creating FedEx shipment to $address');
    return 'fedex_12345';
  }

  @override
  void trackShipment(String trackingNumber) {
    print('Tracking FedEx shipment: $trackingNumber');
  }
}

/// ============================================================================
/// PART 3: HIGH-LEVEL MODULE (Depends on abstractions)
/// ============================================================================

class ECommerceService {
  final IRepository _repository;
  final ICache _cache;
  final ILogger _logger;
  final INotificationService _notificationService;
  final IPaymentGateway _paymentGateway;
  final IShippingService _shippingService;

  ECommerceService({
    required IRepository repository,
    required ICache cache,
    required ILogger logger,
    required INotificationService notificationService,
    required IPaymentGateway paymentGateway,
    required IShippingService shippingService,
  }) : _repository = repository,
       _cache = cache,
       _logger = logger,
       _notificationService = notificationService,
       _paymentGateway = paymentGateway,
       _shippingService = shippingService;

  void processOrder(String orderId, Map<String, dynamic> orderData) {
    _logger.info('Processing order: $orderId');

    // Check cache first
    final cachedOrder = _cache.get('order_$orderId');
    if (cachedOrder != null) {
      _logger.debug('Order found in cache');
      return;
    }

    // Save to database
    _repository.save('orders', {'id': orderId, ...orderData});

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
    _repository.save('orders', {
      'id': orderId,
      'trackingNumber': trackingNumber,
      'status': 'shipped',
    });

    // Cache the order
    _cache.set('order_$orderId', 'processed', ttl: 3600);

    // Send confirmation email
    _notificationService.send(
      orderData['customerEmail'] ?? '',
      'Order Confirmation',
      'Your order $orderId has been shipped. Tracking: $trackingNumber',
    );

    _logger.info('Order processed successfully: $orderId');
  }

  void cancelOrder(String orderId) {
    _logger.info('Cancelling order: $orderId');

    final order = _repository.findById('orders', orderId);
    if (order == null) {
      _logger.error('Order not found: $orderId');
      return;
    }

    // Refund payment
    _paymentGateway.refund(order['transactionId'] ?? '');

    // Update database
    _repository.save('orders', {'id': orderId, 'status': 'cancelled'});

    // Remove from cache
    _cache.delete('order_$orderId');

    // Send cancellation email
    _notificationService.send(
      order['customerEmail'] ?? '',
      'Order Cancelled',
      'Your order $orderId has been cancelled and refunded.',
    );

    _logger.info('Order cancelled: $orderId');
  }
}
