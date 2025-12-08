/// EXERCISE: Advanced - All SOLID Principles Combined
///
/// TASK: Refactor this complex e-commerce system to follow ALL SOLID principles.
/// This code violates ALL 5 SOLID principles:
/// 1. SRP - OrderService handles orders, payments, shipping, inventory, notifications, reports
/// 2. OCP - Adding new payment methods, shipping providers, or report types requires modification
/// 3. LSP - ExpressShipping changes expected behavior of ShippingService
/// 4. ISP - PaymentProcessor interface forces all implementations to support all payment types
/// 5. DIP - Direct dependencies on concrete implementations
///
/// HINT: This is a comprehensive refactoring exercise. Consider:
/// - Separate services for each responsibility (SRP)
/// - Strategy pattern for extensible behaviors (OCP)
/// - Proper inheritance hierarchy (LSP)
/// - Segregated interfaces (ISP)
/// - Dependency injection with abstractions (DIP)

class StripeGateway {
  bool charge(double amount, String cardToken) {
    print('Charging via Stripe: \$$amount');
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via Stripe: $transactionId');
  }
}

class PayPalGateway {
  bool charge(double amount, String email) {
    print('Charging via PayPal: \$$amount');
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via PayPal: $transactionId');
  }
}

class CryptoGateway {
  bool charge(double amount, String walletAddress) {
    print('Charging via Crypto: \$$amount');
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via Crypto: $transactionId');
  }
}

/// Violates ISP - forces all processors to support all payment types
abstract class PaymentProcessor {
  // All processors must implement all methods
  bool processCreditCard(double amount, String cardNumber);
  bool processPayPal(double amount, String email);
  bool processCrypto(double amount, String walletAddress);
  bool processBankTransfer(double amount, String accountNumber);
  void refund(String transactionId);
}

class BasicPaymentProcessor implements PaymentProcessor {
  @override
  bool processCreditCard(double amount, String cardNumber) {
    final stripe = StripeGateway();
    return stripe.charge(amount, cardNumber);
  }

  @override
  bool processPayPal(double amount, String email) {
    final paypal = PayPalGateway();
    return paypal.charge(amount, email);
  }

  // Forced to implement methods it doesn't support
  @override
  bool processCrypto(double amount, String walletAddress) {
    throw Exception('Crypto not supported');
  }

  @override
  bool processBankTransfer(double amount, String accountNumber) {
    throw Exception('Bank transfer not supported');
  }

  @override
  void refund(String transactionId) {
    final stripe = StripeGateway();
    stripe.refund(transactionId);
  }
}

class StandardShipping {
  String ship(String address, double weight) {
    print('Standard shipping to $address');
    return 'standard_12345';
  }

  double calculateCost(double weight, double distance) {
    return weight * distance * 0.5;
  }

  int getEstimatedDays(double distance) {
    return (distance / 100).ceil();
  }
}

/// Violates LSP - changes expected behavior
class ExpressShipping extends StandardShipping {
  @override
  String ship(String address, double weight) {
    print('Express shipping to $address');
    return 'express_12345';
  }

  @override
  double calculateCost(double weight, double distance) {
    // Express is always more expensive
    return super.calculateCost(weight, distance) * 2;
  }

  @override
  int getEstimatedDays(double distance) {
    // Express is faster, but this changes the contract
    final days = super.getEstimatedDays(distance);
    return days > 1 ? days - 1 : 1; // At least 1 day
  }

  // Additional method that base class doesn't have
  void requireSignature() {
    print('Signature required for express shipping');
  }
}

class EmailService {
  void send(String to, String subject, String body) {
    print('Email to $to: $subject');
  }
}

class SMSService {
  void send(String phone, String message) {
    print('SMS to $phone: $message');
  }
}

class MySQLDatabase {
  void save(String table, Map<String, dynamic> data) {
    print('Saving to MySQL: $table');
  }

  Map<String, dynamic>? find(String table, String id) {
    return {'id': id};
  }

  List<Map<String, dynamic>> query(String sql) {
    return [];
  }
}

class FileLogger {
  void log(String message) {
    print('LOG: $message');
  }
}

/// Violates ALL SOLID principles
class OrderService {
  final MySQLDatabase _database = MySQLDatabase(); // DIP violation
  final FileLogger _logger = FileLogger(); // DIP violation
  final EmailService _email = EmailService(); // DIP violation
  final SMSService _sms = SMSService(); // DIP violation
  final PaymentProcessor _paymentProcessor =
      BasicPaymentProcessor(); // DIP violation
  final Map<String, int> _inventory = {};

  // Order management (SRP violation - mixed with other responsibilities)
  void createOrder(String orderId, Map<String, dynamic> orderData) {
    _database.save('orders', {'id': orderId, ...orderData});
    _logger.log('Order created: $orderId');
  }

  // Payment processing - violates OCP (adding payment method requires modification)
  bool processPayment(
    String orderId,
    String paymentType,
    Map<String, dynamic> paymentData,
  ) {
    final order = _database.find('orders', orderId);
    if (order == null) throw Exception('Order not found');

    final amount = order['amount'] ?? 0.0;

    // Adding new payment type requires modification
    switch (paymentType) {
      case 'credit_card':
        return _paymentProcessor.processCreditCard(
          amount,
          paymentData['cardNumber'] ?? '',
        );
      case 'paypal':
        return _paymentProcessor.processPayPal(
          amount,
          paymentData['email'] ?? '',
        );
      case 'crypto':
        return _paymentProcessor.processCrypto(
          amount,
          paymentData['walletAddress'] ?? '',
        );
      // Adding new type requires modification
      default:
        throw Exception('Unknown payment type');
    }
  }

  // Shipping - violates LSP (ExpressShipping changes behavior)
  String shipOrder(String orderId, String shippingType, String address) {
    final order = _database.find('orders', orderId);
    if (order == null) throw Exception('Order not found');

    // Violates LSP - ExpressShipping changes expected behavior
    StandardShipping shipping;
    switch (shippingType) {
      case 'standard':
        shipping = StandardShipping();
        break;
      case 'express':
        shipping = ExpressShipping();
        // ExpressShipping has additional methods that StandardShipping doesn't
        (shipping as ExpressShipping).requireSignature();
        break;
      default:
        throw Exception('Unknown shipping type');
    }

    final trackingNumber = shipping.ship(address, order['weight'] ?? 0.0);
    _database.save('orders', {'id': orderId, 'trackingNumber': trackingNumber});
    return trackingNumber;
  }

  // Inventory management (SRP violation)
  bool checkInventory(String productId, int quantity) {
    return (_inventory[productId] ?? 0) >= quantity;
  }

  void updateInventory(String productId, int quantity) {
    _inventory[productId] = (_inventory[productId] ?? 0) - quantity;
  }

  // Notifications (SRP violation, DIP violation)
  void notifyCustomer(String orderId, String email, String phone) {
    _email.send(
      email,
      'Order Update',
      'Your order $orderId status has been updated.',
    );
    _sms.send(phone, 'Order $orderId updated');
  }

  // Report generation - violates OCP (adding report type requires modification)
  Map<String, dynamic> generateReport(
    String reportType,
    List<Map<String, dynamic>> data,
  ) {
    // Adding new report type requires modification
    switch (reportType) {
      case 'sales':
        return _generateSalesReport(data);
      case 'inventory':
        return _generateInventoryReport(data);
      case 'shipping':
        return _generateShippingReport(data);
      // Adding new type requires modification
      default:
        throw Exception('Unknown report type');
    }
  }

  Map<String, dynamic> _generateSalesReport(List<Map<String, dynamic>> data) {
    return {'type': 'sales', 'data': data};
  }

  Map<String, dynamic> _generateInventoryReport(
    List<Map<String, dynamic>> data,
  ) {
    return {'type': 'inventory', 'data': data};
  }

  Map<String, dynamic> _generateShippingReport(
    List<Map<String, dynamic>> data,
  ) {
    return {'type': 'shipping', 'data': data};
  }

  // Complete order processing - violates SRP (does everything)
  void processCompleteOrder(
    String orderId,
    Map<String, dynamic> orderData,
    String paymentType,
    Map<String, dynamic> paymentData,
    String shippingType,
    String address,
    String customerEmail,
    String customerPhone,
  ) {
    // Check inventory
    if (!checkInventory(
      orderData['productId'] ?? '',
      orderData['quantity'] ?? 0,
    )) {
      throw Exception('Insufficient inventory');
    }

    // Create order
    createOrder(orderId, orderData);

    // Process payment
    if (!processPayment(orderId, paymentType, paymentData)) {
      throw Exception('Payment failed');
    }

    // Update inventory
    updateInventory(orderData['productId'] ?? '', orderData['quantity'] ?? 0);

    // Ship order
    final trackingNumber = shipOrder(orderId, shippingType, address);

    // Generate report
    generateReport('sales', [orderData]);

    // Notify customer
    notifyCustomer(orderId, customerEmail, customerPhone);

    _logger.log('Order processing completed: $orderId');
  }
}
