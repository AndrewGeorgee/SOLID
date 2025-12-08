/// EXERCISE: Mid - Multiple SOLID Principles
///
/// TASK: Refactor this code to follow SOLID principles.
/// This code violates:
/// 1. Single Responsibility Principle (SRP) - handles orders, payments, inventory, notifications
/// 2. Open/Closed Principle (OCP) - adding new payment methods requires modification
/// 3. Dependency Inversion Principle (DIP) - directly depends on concrete implementations
///
/// HINT:
/// - Split OrderProcessor into separate services (SRP)
/// - Create abstract PaymentGateway interface (OCP + DIP)
/// - Create abstract NotificationService interface (DIP)
/// - Use strategy pattern for payment methods (OCP)

class StripePayment {
  bool processPayment(double amount, String cardToken) {
    print('Processing payment via Stripe: \$$amount');
    return true;
  }
}

class PayPalPayment {
  bool processPayment(double amount, String email) {
    print('Processing payment via PayPal: \$$amount');
    return true;
  }
}

class EmailNotification {
  void send(String to, String subject, String body) {
    print('Sending email to $to: $subject');
  }
}

class SMSNotification {
  void send(String phone, String message) {
    print('Sending SMS to $phone: $message');
  }
}

/// Violates SRP, OCP, and DIP
class OrderProcessor {
  final List<Map<String, dynamic>> _orders = [];
  final Map<String, int> _inventory = {};
  final StripePayment _stripe = StripePayment(); // Direct dependency
  final PayPalPayment _paypal = PayPalPayment(); // Direct dependency
  final EmailNotification _email = EmailNotification(); // Direct dependency
  final SMSNotification _sms = SMSNotification(); // Direct dependency

  // Order management
  void createOrder(String orderId, String productId, int quantity) {
    _orders.add({
      'id': orderId,
      'productId': productId,
      'quantity': quantity,
      'status': 'pending',
    });
  }

  // Payment processing - violates OCP (adding new payment method requires modification)
  bool processPayment(
    String orderId,
    String paymentMethod,
    Map<String, dynamic> paymentData,
  ) {
    final order = _orders.firstWhere((o) => o['id'] == orderId);
    final amount = order['quantity'] * 10.0; // Simplified pricing

    // Adding new payment method requires modifying this switch
    switch (paymentMethod) {
      case 'stripe':
        return _stripe.processPayment(amount, paymentData['cardToken'] ?? '');
      case 'paypal':
        return _paypal.processPayment(amount, paymentData['email'] ?? '');
      // Adding new payment method requires modification here
      default:
        throw Exception('Unknown payment method');
    }
  }

  // Inventory management
  bool checkInventory(String productId, int quantity) {
    final available = _inventory[productId] ?? 0;
    return available >= quantity;
  }

  void updateInventory(String productId, int quantity) {
    _inventory[productId] = (_inventory[productId] ?? 0) - quantity;
  }

  // Notification - violates DIP (concrete dependencies)
  void sendOrderConfirmation(String orderId, String email) {
    _email.send(
      email,
      'Order Confirmation',
      'Your order $orderId has been confirmed.',
    );
  }

  void sendShippingNotification(String orderId, String phone) {
    _sms.send(phone, 'Your order $orderId has been shipped!');
  }

  // Complete order processing - violates SRP (does everything)
  void processCompleteOrder(
    String orderId,
    String productId,
    int quantity,
    String paymentMethod,
    Map<String, dynamic> paymentData,
    String customerEmail,
    String customerPhone,
  ) {
    // Check inventory
    if (!checkInventory(productId, quantity)) {
      throw Exception('Insufficient inventory');
    }

    // Create order
    createOrder(orderId, productId, quantity);

    // Process payment
    if (!processPayment(orderId, paymentMethod, paymentData)) {
      throw Exception('Payment failed');
    }

    // Update inventory
    updateInventory(productId, quantity);

    // Send notifications
    sendOrderConfirmation(orderId, customerEmail);
    sendShippingNotification(orderId, customerPhone);
  }
}
