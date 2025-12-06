import '../../models/user.dart';
import '../../models/order.dart';

/// COMPLEX REAL-WORLD EXAMPLE: Enterprise E-Commerce Platform
/// 
/// Demonstrates Dependency Inversion Principle with complex business logic,
/// multiple data sources, external services, and advanced patterns.

// ============================================================================
// ABSTRACTIONS - High-level modules depend on these
// ============================================================================

/// Data persistence abstraction
abstract class IRepository<T> {
  Future<T?> findById(String id);
  Future<List<T>> findAll();
  Future<List<T>> findByCriteria(Map<String, dynamic> criteria);
  Future<void> save(T entity);
  Future<void> update(T entity);
  Future<void> delete(String id);
  Future<bool> exists(String id);
  Future<int> count();
}

/// Caching abstraction
abstract class ICacheService {
  Future<T?> get<T>(String key);
  Future<void> set<T>(String key, T value, {Duration? ttl});
  Future<void> delete(String key);
  Future<void> clear();
  Future<bool> exists(String key);
}

/// Logging abstraction
abstract class ILogger {
  void debug(String message, [Map<String, dynamic>? context]);
  void info(String message, [Map<String, dynamic>? context]);
  void warning(String message, [Map<String, dynamic>? context]);
  void error(String message, [Map<String, dynamic>? context]);
  void critical(String message, [Map<String, dynamic>? context]);
}

/// Payment processing abstraction
abstract class IPaymentGateway {
  Future<PaymentResult> processPayment(PaymentRequest request);
  Future<PaymentResult> refundPayment(String transactionId, double amount);
  Future<PaymentStatus> getPaymentStatus(String transactionId);
  List<String> getSupportedPaymentMethods();
}

/// Notification abstraction
abstract class INotificationService {
  Future<void> send(NotificationRequest request);
  Future<void> sendBulk(List<NotificationRequest> requests);
  List<String> getSupportedChannels();
}

/// Inventory management abstraction
abstract class IInventoryService {
  Future<bool> checkAvailability(String productId, int quantity);
  Future<void> reserve(String productId, int quantity, String reservationId);
  Future<void> release(String reservationId);
  Future<void> updateStock(String productId, int quantity);
  Future<int> getStockLevel(String productId);
}

/// Shipping calculation abstraction
abstract class IShippingCalculator {
  Future<ShippingQuote> calculateShipping(ShippingRequest request);
  List<String> getSupportedCarriers();
  Future<ShippingStatus> trackShipment(String trackingNumber);
}

/// Analytics abstraction
abstract class IAnalyticsService {
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties);
  Future<void> trackPurchase(Order order);
  Future<AnalyticsReport> generateReport(DateTime startDate, DateTime endDate);
}

// ============================================================================
// LOW-LEVEL IMPLEMENTATIONS - Concrete implementations of abstractions
// ============================================================================

/// MySQL repository implementation
class MySQLRepository<T> implements IRepository<T> {
  final String tableName;
  final Map<String, T> _data = {};
  final ILogger logger;

  MySQLRepository({required this.tableName, required this.logger});

  @override
  Future<T?> findById(String id) async {
    logger.debug('Finding $tableName by id: $id');
    await _simulateDelay();
    return _data[id];
  }

  @override
  Future<List<T>> findAll() async {
    logger.debug('Finding all $tableName');
    await _simulateDelay();
    return List.unmodifiable(_data.values);
  }

  @override
  Future<List<T>> findByCriteria(Map<String, dynamic> criteria) async {
    logger.debug('Finding $tableName by criteria: $criteria');
    await _simulateDelay();
    // Simplified criteria matching
    return List.unmodifiable(_data.values);
  }

  @override
  Future<void> save(T entity) async {
    logger.info('Saving $tableName entity');
    await _simulateDelay();
    // Extract ID from entity (simplified)
    final id = _extractId(entity);
    _data[id] = entity;
  }

  @override
  Future<void> update(T entity) async {
    logger.info('Updating $tableName entity');
    await _simulateDelay();
    final id = _extractId(entity);
    if (_data.containsKey(id)) {
      _data[id] = entity;
    }
  }

  @override
  Future<void> delete(String id) async {
    logger.info('Deleting $tableName entity: $id');
    await _simulateDelay();
    _data.remove(id);
  }

  @override
  Future<bool> exists(String id) async {
    await _simulateDelay();
    return _data.containsKey(id);
  }

  @override
  Future<int> count() async {
    await _simulateDelay();
    return _data.length;
  }

  String _extractId(T entity) {
    // Simplified ID extraction
    return entity.toString().hashCode.toString();
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

/// PostgreSQL repository implementation
class PostgreSQLRepository<T> implements IRepository<T> {
  final String tableName;
  final Map<String, T> _data = {};
  final ILogger logger;

  PostgreSQLRepository({required this.tableName, required this.logger});

  @override
  Future<T?> findById(String id) async {
    logger.debug('[PostgreSQL] Finding $tableName by id: $id');
    await _simulateDelay();
    return _data[id];
  }

  @override
  Future<List<T>> findAll() async {
    logger.debug('[PostgreSQL] Finding all $tableName');
    await _simulateDelay();
    return List.unmodifiable(_data.values);
  }

  @override
  Future<List<T>> findByCriteria(Map<String, dynamic> criteria) async {
    logger.debug('[PostgreSQL] Finding $tableName by criteria: $criteria');
    await _simulateDelay();
    return List.unmodifiable(_data.values);
  }

  @override
  Future<void> save(T entity) async {
    logger.info('[PostgreSQL] Saving $tableName entity');
    await _simulateDelay();
    final id = _extractId(entity);
    _data[id] = entity;
  }

  @override
  Future<void> update(T entity) async {
    logger.info('[PostgreSQL] Updating $tableName entity');
    await _simulateDelay();
    final id = _extractId(entity);
    if (_data.containsKey(id)) {
      _data[id] = entity;
    }
  }

  @override
  Future<void> delete(String id) async {
    logger.info('[PostgreSQL] Deleting $tableName entity: $id');
    await _simulateDelay();
    _data.remove(id);
  }

  @override
  Future<bool> exists(String id) async {
    await _simulateDelay();
    return _data.containsKey(id);
  }

  @override
  Future<int> count() async {
    await _simulateDelay();
    return _data.length;
  }

  String _extractId(T entity) {
    return entity.toString().hashCode.toString();
  }

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

/// Redis cache implementation
class RedisCacheService implements ICacheService {
  final Map<String, _CacheEntry> _cache = {};
  final ILogger logger;

  RedisCacheService({required this.logger});

  @override
  Future<T?> get<T>(String key) async {
    logger.debug('Getting from cache: $key');
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
    logger.debug('Setting cache: $key');
    final expiresAt = ttl != null ? DateTime.now().add(ttl) : null;
    _cache[key] = _CacheEntry(value: value, expiresAt: expiresAt);
  }

  @override
  Future<void> delete(String key) async {
    logger.debug('Deleting from cache: $key');
    _cache.remove(key);
  }

  @override
  Future<void> clear() async {
    logger.info('Clearing cache');
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

/// Stripe payment gateway implementation
class StripePaymentGateway implements IPaymentGateway {
  final ILogger logger;

  StripePaymentGateway({required this.logger});

  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    logger.info('Processing payment via Stripe: \$${request.amount}');
    await Future.delayed(const Duration(milliseconds: 100));

    return PaymentResult(
      success: true,
      transactionId: 'stripe_${DateTime.now().millisecondsSinceEpoch}',
      amount: request.amount,
      paymentMethod: request.paymentMethod,
    );
  }

  @override
  Future<PaymentResult> refundPayment(String transactionId, double amount) async {
    logger.info('Processing refund via Stripe: $transactionId');
    await Future.delayed(const Duration(milliseconds: 100));

    return PaymentResult(
      success: true,
      transactionId: 'refund_$transactionId',
      amount: amount,
      paymentMethod: 'refund',
    );
  }

  @override
  Future<PaymentStatus> getPaymentStatus(String transactionId) async {
    logger.debug('Getting payment status from Stripe: $transactionId');
    await Future.delayed(const Duration(milliseconds: 50));
    return PaymentStatus.completed;
  }

  @override
  List<String> getSupportedPaymentMethods() {
    return ['credit_card', 'debit_card', 'apple_pay', 'google_pay'];
  }
}

/// PayPal payment gateway implementation
class PayPalPaymentGateway implements IPaymentGateway {
  final ILogger logger;

  PayPalPaymentGateway({required this.logger});

  @override
  Future<PaymentResult> processPayment(PaymentRequest request) async {
    logger.info('Processing payment via PayPal: \$${request.amount}');
    await Future.delayed(const Duration(milliseconds: 150));

    return PaymentResult(
      success: true,
      transactionId: 'paypal_${DateTime.now().millisecondsSinceEpoch}',
      amount: request.amount,
      paymentMethod: request.paymentMethod,
    );
  }

  @override
  Future<PaymentResult> refundPayment(String transactionId, double amount) async {
    logger.info('Processing refund via PayPal: $transactionId');
    await Future.delayed(const Duration(milliseconds: 150));

    return PaymentResult(
      success: true,
      transactionId: 'refund_$transactionId',
      amount: amount,
      paymentMethod: 'refund',
    );
  }

  @override
  Future<PaymentStatus> getPaymentStatus(String transactionId) async {
    logger.debug('Getting payment status from PayPal: $transactionId');
    await Future.delayed(const Duration(milliseconds: 50));
    return PaymentStatus.completed;
  }

  @override
  List<String> getSupportedPaymentMethods() {
    return ['paypal', 'credit_card', 'bank_transfer'];
  }
}

// ============================================================================
// HIGH-LEVEL MODULES - Depend on abstractions, not concrete implementations
// ============================================================================

/// Order service - depends on abstractions
class OrderService {
  final IRepository<Order> orderRepository;
  final IRepository<User> userRepository;
  final IPaymentGateway paymentGateway;
  final IInventoryService inventoryService;
  final INotificationService notificationService;
  final IShippingCalculator shippingCalculator;
  final IAnalyticsService analyticsService;
  final ICacheService cacheService;
  final ILogger logger;

  OrderService({
    required this.orderRepository,
    required this.userRepository,
    required this.paymentGateway,
    required this.inventoryService,
    required this.notificationService,
    required this.shippingCalculator,
    required this.analyticsService,
    required this.cacheService,
    required this.logger,
  });

  Future<OrderResult> processOrder(OrderRequest request) async {
    logger.info('Processing order for user: ${request.userId}');

    try {
      // Check cache first
      final cacheKey = 'order_${request.userId}_${request.items.length}';
      final cachedResult = await cacheService.get<OrderResult>(cacheKey);
      if (cachedResult != null) {
        logger.debug('Returning cached order result');
        return cachedResult;
      }

      // Validate user
      final user = await userRepository.findById(request.userId);
      if (user == null) {
        return OrderResult(
          success: false,
          error: 'User not found',
        );
      }

      // Check inventory
      for (final item in request.items) {
        final available = await inventoryService.checkAvailability(
          item.productId,
          item.quantity,
        );
        if (!available) {
          return OrderResult(
            success: false,
            error: 'Product ${item.productId} is out of stock',
          );
        }
      }

      // Calculate shipping
      final shippingQuote = await shippingCalculator.calculateShipping(
        ShippingRequest(
          items: request.items,
          destination: request.shippingAddress,
        ),
      );

      // Calculate totals
      final subtotal = request.items.fold<double>(
        0.0,
        (sum, item) => sum + (item.unitPrice * item.quantity),
      );
      final total = subtotal + shippingQuote.cost;

      // Process payment
      final paymentResult = await paymentGateway.processPayment(
        PaymentRequest(
          amount: total,
          paymentMethod: request.paymentMethod,
          userId: request.userId,
        ),
      );

      if (!paymentResult.success) {
        return OrderResult(
          success: false,
          error: 'Payment failed: ${paymentResult.errorMessage}',
        );
      }

      // Create order
      final order = Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: request.userId,
        items: request.items,
        subtotal: subtotal,
        tax: 0.0, // Simplified
        shipping: shippingQuote.cost,
        total: total,
        status: OrderStatus.confirmed,
        createdAt: DateTime.now(),
        paymentInfo: PaymentInfo(
          paymentMethod: paymentResult.paymentMethod,
          transactionId: paymentResult.transactionId!,
          processedAt: DateTime.now(),
          amount: total,
        ),
        shippingAddress: request.shippingAddress,
      );

      // Save order
      await orderRepository.save(order);

      // Reserve inventory
      for (final item in request.items) {
        await inventoryService.reserve(
          item.productId,
          item.quantity,
          order.id,
        );
      }

      // Send notifications
      await notificationService.send(
        NotificationRequest(
          recipient: user.email,
          subject: 'Order Confirmation',
          body: 'Your order ${order.id} has been confirmed',
          channel: 'email',
        ),
      );

      // Track analytics
      await analyticsService.trackPurchase(order);

      final result = OrderResult(
        success: true,
        order: order,
      );

      // Cache result
      await cacheService.set(cacheKey, result, ttl: const Duration(minutes: 5));

      logger.info('Order processed successfully: ${order.id}');
      return result;
    } catch (e) {
      logger.error('Error processing order: $e');
      return OrderResult(
        success: false,
        error: 'Order processing failed: $e',
      );
    }
  }

  Future<void> cancelOrder(String orderId) async {
    logger.info('Cancelling order: $orderId');

    final order = await orderRepository.findById(orderId);
    if (order == null) {
      throw Exception('Order not found');
    }

    // Refund payment
    if (order.paymentInfo != null) {
      await paymentGateway.refundPayment(
        order.paymentInfo!.transactionId,
        order.total,
      );
    }

      // Release inventory
      await inventoryService.release(order.id);

    // Update order status
    final cancelledOrder = Order(
      id: order.id,
      userId: order.userId,
      items: order.items,
      subtotal: order.subtotal,
      tax: order.tax,
      shipping: order.shipping,
      total: order.total,
      status: OrderStatus.cancelled,
      createdAt: order.createdAt,
      paymentInfo: order.paymentInfo,
      shippingAddress: order.shippingAddress,
    );

    await orderRepository.update(cancelledOrder);
    logger.info('Order cancelled: $orderId');
  }
}

// ============================================================================
// SUPPORTING CLASSES
// ============================================================================

class PaymentRequest {
  final double amount;
  final String paymentMethod;
  final String userId;
  final Map<String, dynamic> metadata;

  PaymentRequest({
    required this.amount,
    required this.paymentMethod,
    required this.userId,
    this.metadata = const {},
  });
}

class PaymentResult {
  final bool success;
  final String? transactionId;
  final double amount;
  final String paymentMethod;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.transactionId,
    required this.amount,
    required this.paymentMethod,
    this.errorMessage,
  });
}

enum PaymentStatus { pending, processing, completed, failed, refunded }

class NotificationRequest {
  final String recipient;
  final String subject;
  final String body;
  final String channel;
  final Map<String, dynamic> metadata;

  NotificationRequest({
    required this.recipient,
    required this.subject,
    required this.body,
    required this.channel,
    this.metadata = const {},
  });
}

class ShippingRequest {
  final List<OrderItem> items;
  final ShippingAddress destination;

  ShippingRequest({
    required this.items,
    required this.destination,
  });
}

class ShippingQuote {
  final double cost;
  final Duration estimatedDelivery;
  final String carrier;
  final String serviceLevel;

  ShippingQuote({
    required this.cost,
    required this.estimatedDelivery,
    required this.carrier,
    required this.serviceLevel,
  });
}

enum ShippingStatus { pending, in_transit, delivered, exception }

class OrderRequest {
  final String userId;
  final List<OrderItem> items;
  final String paymentMethod;
  final ShippingAddress shippingAddress;

  OrderRequest({
    required this.userId,
    required this.items,
    required this.paymentMethod,
    required this.shippingAddress,
  });
}

class OrderResult {
  final bool success;
  final Order? order;
  final String? error;

  OrderResult({
    required this.success,
    this.order,
    this.error,
  });
}

class AnalyticsReport {
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> metrics;

  AnalyticsReport({
    required this.startDate,
    required this.endDate,
    required this.metrics,
  });
}

// Simplified implementations for other abstractions
class SimpleInventoryService implements IInventoryService {
  final Map<String, int> _stock = {};
  final Map<String, String> _reservations = {};

  @override
  Future<bool> checkAvailability(String productId, int quantity) async {
    return (_stock[productId] ?? 0) >= quantity;
  }

  @override
  Future<void> reserve(String productId, int quantity, String reservationId) async {
    _stock[productId] = (_stock[productId] ?? 0) - quantity;
    _reservations[reservationId] = productId;
  }

  @override
  Future<void> release(String reservationId) async {
    final productId = _reservations.remove(reservationId);
    if (productId != null) {
      _stock[productId] = (_stock[productId] ?? 0) + 1;
    }
  }

  @override
  Future<void> updateStock(String productId, int quantity) async {
    _stock[productId] = quantity;
  }

  @override
  Future<int> getStockLevel(String productId) async {
    return _stock[productId] ?? 0;
  }
}

class SimpleNotificationService implements INotificationService {
  @override
  Future<void> send(NotificationRequest request) async {
    print('[${request.channel.toUpperCase()}] To: ${request.recipient}');
    print('Subject: ${request.subject}');
    print('Body: ${request.body}');
  }

  @override
  Future<void> sendBulk(List<NotificationRequest> requests) async {
    for (final request in requests) {
      await send(request);
    }
  }

  @override
  List<String> getSupportedChannels() {
    return ['email', 'sms', 'push', 'webhook'];
  }
}

class SimpleShippingCalculator implements IShippingCalculator {
  @override
  Future<ShippingQuote> calculateShipping(ShippingRequest request) async {
    final baseCost = 5.0;
    final itemCount = request.items.length;
    final cost = baseCost + (itemCount * 2.0);

    return ShippingQuote(
      cost: cost,
      estimatedDelivery: const Duration(days: 5),
      carrier: 'Standard',
      serviceLevel: 'Ground',
    );
  }

  @override
  List<String> getSupportedCarriers() {
    return ['UPS', 'FedEx', 'USPS', 'DHL'];
  }

  @override
  Future<ShippingStatus> trackShipment(String trackingNumber) async {
    return ShippingStatus.in_transit;
  }
}

class SimpleAnalyticsService implements IAnalyticsService {
  @override
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties) async {
    print('[ANALYTICS] Event: $eventName | Properties: $properties');
  }

  @override
  Future<void> trackPurchase(Order order) async {
    await trackEvent('purchase', {
      'order_id': order.id,
      'user_id': order.userId,
      'total': order.total,
      'item_count': order.items.length,
    });
  }

  @override
  Future<AnalyticsReport> generateReport(DateTime startDate, DateTime endDate) async {
    return AnalyticsReport(
      startDate: startDate,
      endDate: endDate,
      metrics: {'total_events': 0, 'total_revenue': 0.0},
    );
  }
}

class ConsoleLogger implements ILogger {
  @override
  void debug(String message, [Map<String, dynamic>? context]) {
    print('[DEBUG] $message${context != null ? ' | $context' : ''}');
  }

  @override
  void info(String message, [Map<String, dynamic>? context]) {
    print('[INFO] $message${context != null ? ' | $context' : ''}');
  }

  @override
  void warning(String message, [Map<String, dynamic>? context]) {
    print('[WARNING] $message${context != null ? ' | $context' : ''}');
  }

  @override
  void error(String message, [Map<String, dynamic>? context]) {
    print('[ERROR] $message${context != null ? ' | $context' : ''}');
  }

  @override
  void critical(String message, [Map<String, dynamic>? context]) {
    print('[CRITICAL] $message${context != null ? ' | $context' : ''}');
  }
}

