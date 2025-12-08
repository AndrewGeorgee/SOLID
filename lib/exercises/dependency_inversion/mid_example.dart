/// EXERCISE: Mid - Dependency Inversion Principle
///
/// TASK: Refactor this code to follow Dependency Inversion Principle.
/// Currently, PaymentProcessor directly depends on concrete payment gateways
/// instead of abstractions. Adding a new payment gateway requires modifying
/// the PaymentProcessor class.
///
/// HINT: Create an abstract PaymentGateway interface, then inject the
/// specific gateway implementation through constructor or dependency injection.

class StripeGateway {
  bool processPayment(double amount, String cardNumber) {
    print('Processing payment via Stripe: \$$amount');
    // Stripe-specific logic...
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via Stripe: $transactionId');
    // Stripe refund logic...
  }
}

class PayPalGateway {
  bool processPayment(double amount, String email) {
    print('Processing payment via PayPal: \$$amount to $email');
    // PayPal-specific logic...
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via PayPal: $transactionId');
    // PayPal refund logic...
  }
}

class SquareGateway {
  bool processPayment(double amount, String paymentToken) {
    print('Processing payment via Square: \$$amount');
    // Square-specific logic...
    return true;
  }

  void refund(String transactionId) {
    print('Refunding via Square: $transactionId');
    // Square refund logic...
  }
}

/// PaymentProcessor directly depends on concrete gateways (violates DIP)
class PaymentProcessor {
  String _gatewayType = 'stripe'; // Hard-coded dependency

  PaymentProcessor({String? gatewayType}) {
    _gatewayType = gatewayType ?? 'stripe';
  }

  bool processPayment(double amount, Map<String, dynamic> paymentData) {
    // Direct dependency on concrete classes
    switch (_gatewayType) {
      case 'stripe':
        final stripe = StripeGateway();
        return stripe.processPayment(amount, paymentData['cardNumber'] ?? '');
      case 'paypal':
        final paypal = PayPalGateway();
        return paypal.processPayment(amount, paymentData['email'] ?? '');
      case 'square':
        final square = SquareGateway();
        return square.processPayment(amount, paymentData['paymentToken'] ?? '');
      default:
        throw Exception('Unknown payment gateway');
    }
  }

  void refund(String transactionId) {
    // Direct dependency on concrete classes
    switch (_gatewayType) {
      case 'stripe':
        final stripe = StripeGateway();
        stripe.refund(transactionId);
        break;
      case 'paypal':
        final paypal = PayPalGateway();
        paypal.refund(transactionId);
        break;
      case 'square':
        final square = SquareGateway();
        square.refund(transactionId);
        break;
      default:
        throw Exception('Unknown payment gateway');
    }
  }
}
