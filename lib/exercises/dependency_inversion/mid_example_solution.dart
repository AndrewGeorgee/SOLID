abstract class PaymentGateway {
  bool processPayment(double amount, String paymentData);
  void refund(String transactionId);
}

class StripeGateway implements PaymentGateway {
  @override
  void refund(String transactionId) {
    print('Refunding via Stripe: $transactionId');
  }

  @override
  bool processPayment(double amount, String paymentData) {
    print('Processing payment via Stripe: \$$amount');
    return true;
  }
}

class PayPalGateway implements PaymentGateway {
  @override
  void refund(String transactionId) {
    print('Refunding via PayPal: $transactionId');
  }

  @override
  bool processPayment(double amount, String paymentData) {
    print('Processing payment via PayPal: \$$amount');
    return true;
  }
}

class SquareGateway implements PaymentGateway {
  @override
  void refund(String transactionId) {
    print('Refunding via Square: $transactionId');
  }

  @override
  bool processPayment(double amount, String paymentData) {
    print('Processing payment via Square: \$$amount');
    return true;
  }
}

class PaymentProcessor {
  final PaymentGateway _gateway;

  PaymentProcessor({required PaymentGateway gateway}) : _gateway = gateway;

  bool processPayment(double amount, String paymentData) {
    return _gateway.processPayment(amount, paymentData);
  }

  void refund(String transactionId) {
    _gateway.refund(transactionId);
  }
}

/// ============================================================================
/// HOW IT WORKS: The caller decides which gateway to use!
/// ============================================================================
///
/// PaymentProcessor doesn't decide which gateway to use - YOU decide when
/// creating the PaymentProcessor instance. This is called "Dependency Injection".
///
/// ============================================================================

/// Example 1: Direct instantiation - You choose the gateway
void example1_DirectChoice() {
  // You decide: Use Stripe
  final processor1 = PaymentProcessor(gateway: StripeGateway());
  processor1.processPayment(100.0, 'card_123');

  // You decide: Use PayPal
  final processor2 = PaymentProcessor(gateway: PayPalGateway());
  processor2.processPayment(100.0, 'user@example.com');

  // You decide: Use Square
  final processor3 = PaymentProcessor(gateway: SquareGateway());
  processor3.processPayment(100.0, 'token_456');
}

/// Example 2: Based on user preference or configuration
void example2_UserPreference(String userPreferredGateway) {
  PaymentGateway gateway;

  // Decision is made HERE, not inside PaymentProcessor
  switch (userPreferredGateway.toLowerCase()) {
    case 'stripe':
      gateway = StripeGateway();
      break;
    case 'paypal':
      gateway = PayPalGateway();
      break;
    case 'square':
      gateway = SquareGateway();
      break;
    default:
      gateway = StripeGateway(); // Default
  }

  // Now PaymentProcessor uses the chosen gateway
  final processor = PaymentProcessor(gateway: gateway);
  processor.processPayment(100.0, 'payment_data');
}

/// Example 3: Factory pattern - Gateway factory decides
class PaymentGatewayFactory {
  static PaymentGateway create(String gatewayType) {
    switch (gatewayType.toLowerCase()) {
      case 'stripe':
        return StripeGateway();
      case 'paypal':
        return PayPalGateway();
      case 'square':
        return SquareGateway();
      default:
        throw Exception('Unknown gateway type: $gatewayType');
    }
  }
}

void example3_FactoryPattern() {
  // Factory decides which gateway to create
  final gateway = PaymentGatewayFactory.create('stripe');

  // PaymentProcessor receives the gateway
  final processor = PaymentProcessor(gateway: gateway);
  processor.processPayment(100.0, 'payment_data');
}

/// Example 4: Configuration-based - Read from config/settings
class PaymentConfig {
  static String getDefaultGateway() {
    // This could read from config file, environment variable, database, etc.
    return 'stripe'; // or 'paypal', 'square'
  }
}

void example4_ConfigurationBased() {
  // Read gateway type from configuration
  final gatewayType = PaymentConfig.getDefaultGateway();
  final gateway = PaymentGatewayFactory.create(gatewayType);

  final processor = PaymentProcessor(gateway: gateway);
  processor.processPayment(100.0, 'payment_data');
}

/// Example 5: Order-based - Different gateway for different order types
void example5_OrderBased(String orderType) {
  PaymentGateway gateway;

  // Business logic decides: VIP orders use PayPal, regular use Stripe
  if (orderType == 'vip') {
    gateway = PayPalGateway();
  } else {
    gateway = StripeGateway();
  }

  final processor = PaymentProcessor(gateway: gateway);
  processor.processPayment(100.0, 'payment_data');
}

/// ============================================================================
/// KEY POINT: Dependency Injection Pattern
/// ============================================================================
///
/// BEFORE (Bad - PaymentProcessor decides):
///   PaymentProcessor processor = PaymentProcessor(gatewayType: 'stripe');
///   // PaymentProcessor internally creates StripeGateway
///
/// AFTER (Good - You decide):
///   PaymentProcessor processor = PaymentProcessor(gateway: StripeGateway());
///   // You create the gateway and inject it
///
/// BENEFITS:
/// 1. PaymentProcessor doesn't need to know about all gateway types
/// 2. Easy to test (inject mock gateway)
/// 3. Easy to add new gateways (just implement PaymentGateway interface)
/// 4. Flexible (choose gateway at runtime based on any condition)
///
/// ============================================================================
