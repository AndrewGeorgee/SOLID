/// EXERCISE: Mid - Single Responsibility Principle
///
/// TASK: Refactor this class to follow Single Responsibility Principle.
/// This class handles order processing, payment, inventory, and notification.
///
/// HINT: Create separate classes for:
/// - Order management
/// - Payment processing
/// - Inventory management
/// - Notification service

class OrderProcessor {
  final List<Map<String, dynamic>> _orders = [];
  final Map<String, int> _inventory = {};

  // Order management responsibility
  void createOrder(String orderId, String productId, int quantity) {
    _orders.add({
      'id': orderId,
      'productId': productId,
      'quantity': quantity,
      'status': 'pending',
    });
  }

  // Payment processing responsibility
  bool processPayment(String orderId, double amount, String paymentMethod) {
    print('Processing payment of \$$amount using $paymentMethod');
    // Payment logic...
    return true;
  }

  // Inventory management responsibility
  bool checkInventory(String productId, int quantity) {
    final available = _inventory[productId] ?? 0;
    return available >= quantity;
  }

  void updateInventory(String productId, int quantity) {
    _inventory[productId] = (_inventory[productId] ?? 0) - quantity;
  }

  // Notification responsibility
  void sendOrderConfirmation(String orderId, String email) {
    print('Sending order confirmation to $email for order $orderId');
    // Email sending logic...
  }

  void sendShippingNotification(String orderId, String email) {
    print('Sending shipping notification to $email for order $orderId');
    // Email sending logic...
  }
}
