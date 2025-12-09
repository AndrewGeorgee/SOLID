/// SOLUTION: Mid - Multiple SOLID Principles (SRP + OCP + DIP)
///
/// This solution demonstrates how to apply Single Responsibility Principle,
/// Open/Closed Principle, and Dependency Inversion Principle together.

/// ============================================================================
/// PART 1: Payment Gateway Abstraction (OCP + DIP)
/// ============================================================================

abstract class PaymentGateway {
  bool processPayment(double amount, Map<String, dynamic> paymentData);
}

class StripePayment implements PaymentGateway {
  @override
  bool processPayment(double amount, Map<String, dynamic> paymentData) {
    print('Processing payment via Stripe: \$$amount');
    // Stripe-specific payment logic using paymentData['cardToken']
    return true;
  }
}

class PayPalPayment implements PaymentGateway {
  @override
  bool processPayment(double amount, Map<String, dynamic> paymentData) {
    final email = paymentData['email'] ?? '';
    print('Processing payment via PayPal: \$$amount to $email');
    return true;
  }
}

/// Example: New payment gateway (demonstrates OCP - can be added without modification)
class SquarePayment implements PaymentGateway {
  @override
  bool processPayment(double amount, Map<String, dynamic> paymentData) {
    print('Processing payment via Square: \$$amount');
    return true;
  }
}

/// ============================================================================
/// PART 2: Notification Service Abstraction (DIP)
/// ============================================================================

abstract class NotificationService {
  void send(String to, String subject, String body);
}

class EmailNotification implements NotificationService {
  @override
  void send(String to, String subject, String body) {
    print('Sending email to $to: $subject');
  }
}

class SMSNotification implements NotificationService {
  @override
  void send(String to, String subject, String body) {
    print('Sending SMS to $to: $body');
  }
}

/// ============================================================================
/// PART 3: Order Management (SRP - Single Responsibility: Managing orders)
/// ============================================================================

class OrderManager {
  final List<Map<String, dynamic>> _orders = [];

  void createOrder(String orderId, String productId, int quantity) {
    _orders.add({
      'id': orderId,
      'productId': productId,
      'quantity': quantity,
      'status': 'pending',
    });
  }

  Map<String, dynamic>? getOrder(String orderId) {
    try {
      return _orders.firstWhere((o) => o['id'] == orderId);
    } catch (e) {
      return null;
    }
  }
}

/// ============================================================================
/// PART 4: Inventory Management (SRP - Single Responsibility: Managing inventory)
/// ============================================================================

class InventoryManager {
  final Map<String, int> _inventory = {};

  bool checkInventory(String productId, int quantity) {
    final available = _inventory[productId] ?? 0;
    return available >= quantity;
  }

  void updateInventory(String productId, int quantity) {
    _inventory[productId] = (_inventory[productId] ?? 0) - quantity;
  }

  void addInventory(String productId, int quantity) {
    _inventory[productId] = (_inventory[productId] ?? 0) + quantity;
  }
}

/// ============================================================================
/// PART 5: Payment Processor (SRP - Single Responsibility: Processing payments)
/// ============================================================================

class PaymentProcessor {
  final PaymentGateway _paymentGateway;

  PaymentProcessor({required PaymentGateway paymentGateway})
    : _paymentGateway = paymentGateway;

  bool processPayment(double amount, Map<String, dynamic> paymentData) {
    return _paymentGateway.processPayment(amount, paymentData);
  }
}

/// ============================================================================
/// PART 6: Order Processor (Orchestrates all services - SRP + OCP + DIP)
/// ============================================================================

class OrderProcessor {
  final OrderManager _orderManager;
  final PaymentProcessor _paymentProcessor;
  final InventoryManager _inventoryManager;
  final NotificationService _notificationService;

  OrderProcessor({
    required OrderManager orderManager,
    required PaymentProcessor paymentProcessor,
    required InventoryManager inventoryManager,
    required NotificationService notificationService,
  }) : _orderManager = orderManager,
       _paymentProcessor = paymentProcessor,
       _inventoryManager = inventoryManager,
       _notificationService = notificationService;

  /// Processes a complete order workflow
  void processCompleteOrder(
    String orderId,
    String productId,
    int quantity,
    Map<String, dynamic> paymentData,
    String customerEmail,
    String customerPhone,
  ) {
    // 1. Check inventory
    if (!_inventoryManager.checkInventory(productId, quantity)) {
      throw Exception('Insufficient inventory');
    }

    // 2. Create order
    _orderManager.createOrder(orderId, productId, quantity);

    // 3. Process payment
    final amount = quantity * 10.0; // Simplified pricing
    final paymentSuccess = _paymentProcessor.processPayment(
      amount,
      paymentData,
    );

    if (!paymentSuccess) {
      throw Exception('Payment failed');
    }

    // 4. Update inventory
    _inventoryManager.updateInventory(productId, quantity);

    // 5. Send notifications
    _notificationService.send(
      customerEmail,
      'Order Confirmation',
      'Your order $orderId has been confirmed.',
    );

    _notificationService.send(
      customerPhone,
      'Shipping Notification',
      'Your order $orderId has been shipped!',
    );
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  // Example 1: Using Stripe payment with Email notifications
  final orderProcessor1 = OrderProcessor(
    orderManager: OrderManager(),
    paymentProcessor: PaymentProcessor(paymentGateway: StripePayment()),
    inventoryManager: InventoryManager()
      ..addInventory('PROD-001', 10), // Add inventory
    notificationService: EmailNotification(),
  );

  try {
    orderProcessor1.processCompleteOrder(
      'ORD-001',
      'PROD-001',
      2,
      {'cardToken': 'tok_123456'},
      'customer@example.com',
      '+1234567890',
    );
    print('Order processed successfully!\n');
  } catch (e) {
    print('Error: $e\n');
  }

  // Example 2: Using PayPal payment with SMS notifications
  final orderProcessor2 = OrderProcessor(
    orderManager: OrderManager(),
    paymentProcessor: PaymentProcessor(paymentGateway: PayPalPayment()),
    inventoryManager: InventoryManager()..addInventory('PROD-002', 5),
    notificationService: SMSNotification(),
  );

  try {
    orderProcessor2.processCompleteOrder(
      'ORD-002',
      'PROD-002',
      1,
      {'email': 'paypal@example.com'},
      'customer2@example.com',
      '+9876543210',
    );
    print('Order processed successfully!\n');
  } catch (e) {
    print('Error: $e\n');
  }

  // Example 3: Demonstrating SRP - Each service can be used independently
  final orderManager = OrderManager();
  final inventoryManager = InventoryManager()..addInventory('PROD-003', 20);
  final paymentProcessor = PaymentProcessor(paymentGateway: StripePayment());

  // Use services independently
  orderManager.createOrder('ORD-003', 'PROD-003', 3);
  print('Order created independently');

  final hasInventory = inventoryManager.checkInventory('PROD-003', 3);
  print('Inventory check: $hasInventory');

  final paymentSuccess = paymentProcessor.processPayment(30.0, {
    'cardToken': 'tok_789',
  });
  print('Payment processed: $paymentSuccess');

  // Example 4: Easy to add new payment gateway (OCP)
  // SquarePayment is already defined above - just use it!
  // No changes needed to OrderProcessor - demonstrates OCP
  final orderProcessor3 = OrderProcessor(
    orderManager: OrderManager(),
    paymentProcessor: PaymentProcessor(
      paymentGateway: SquarePayment(), // New payment method!
    ),
    inventoryManager: InventoryManager()..addInventory('PROD-004', 15),
    notificationService: EmailNotification(),
  );

  try {
    orderProcessor3.processCompleteOrder(
      'ORD-004',
      'PROD-004',
      2,
      {'paymentToken': 'sq_token_123'},
      'customer3@example.com',
      '+1112223333',
    );
    print('Order with Square payment processed successfully!\n');
  } catch (e) {
    print('Error: $e\n');
  }

  print('\n=== Benefits of this solution ===');
  print('✅ SRP: Each class has one responsibility');
  print('✅ OCP: New payment methods can be added without modification');
  print(
    '✅ DIP: Depends on abstractions, easy to test and swap implementations',
  );
}
