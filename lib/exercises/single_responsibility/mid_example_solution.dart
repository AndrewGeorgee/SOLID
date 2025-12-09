/// SOLUTION: Mid - Single Responsibility Principle
///
/// This solution demonstrates how to apply the Single Responsibility Principle
/// by separating order processing, payment, inventory, and notification into
/// different classes, each with a single responsibility.

/// ============================================================================
/// PART 1: Order Management (Single Responsibility: Managing orders)
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
      return _orders.firstWhere((order) => order['id'] == orderId);
    } catch (e) {
      return null;
    }
  }
}

/// ============================================================================
/// PART 2: Payment Processing (Single Responsibility: Processing payments)
/// ============================================================================

class PaymentProcessor {
  bool processPayment(String orderId, double amount, String paymentMethod) {
    print('Processing payment of \$$amount using $paymentMethod');
    // Payment logic...
    return true;
  }
}

/// ============================================================================
/// PART 3: Inventory Management (Single Responsibility: Managing inventory)
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
/// PART 4: Notification Service (Single Responsibility: Sending notifications)
/// ============================================================================

class NotificationService {
  void sendOrderConfirmation(String orderId, String email) {
    print('Sending order confirmation to $email for order $orderId');
    // Email sending logic...
  }

  void sendShippingNotification(String orderId, String email) {
    print('Sending shipping notification to $email for order $orderId');
    // Email sending logic...
  }
}

/// ============================================================================
/// PART 5: Order Processor (Orchestrates all services)
/// ============================================================================

class OrderProcessor {
  final OrderManager _orderManager = OrderManager();
  final PaymentProcessor _paymentProcessor = PaymentProcessor();
  final InventoryManager _inventoryManager = InventoryManager();
  final NotificationService _notificationService = NotificationService();

  /// Creates an order (delegates to OrderManager)
  void createOrder(String orderId, String productId, int quantity) {
    _orderManager.createOrder(orderId, productId, quantity);
  }

  /// Processes a complete order workflow
  bool processCompleteOrder(
    String orderId,
    String productId,
    int quantity,
    double amount,
    String paymentMethod,
    String customerEmail,
  ) {
    // 1. Check inventory
    if (!_inventoryManager.checkInventory(productId, quantity)) {
      print('Insufficient inventory for product $productId');
      return false;
    }

    // 2. Create order
    _orderManager.createOrder(orderId, productId, quantity);

    // 3. Process payment
    final paymentSuccess = _paymentProcessor.processPayment(
      orderId,
      amount,
      paymentMethod,
    );

    if (!paymentSuccess) {
      print('Payment failed for order $orderId');
      return false;
    }

    // 4. Update inventory
    _inventoryManager.updateInventory(productId, quantity);

    // 5. Send order confirmation
    _notificationService.sendOrderConfirmation(orderId, customerEmail);

    print('Order $orderId processed successfully');
    return true;
  }

  /// Sends shipping notification
  void notifyShipping(String orderId, String customerEmail) {
    _notificationService.sendShippingNotification(orderId, customerEmail);
  }
}
