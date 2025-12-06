import '../../models/product.dart';

/// GOOD EXAMPLE: Follows Open/Closed Principle
/// 
/// Using abstraction (interfaces) to allow extension without modification.
/// New discount types can be added by implementing the interface,
/// without changing existing code.

/// Abstract base class for discount strategies
abstract class DiscountStrategy {
  double applyDiscount(double price);
}

/// Concrete implementation: Student discount
class StudentDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    return price * 0.9; // 10% off
  }
}

/// Concrete implementation: Senior discount
class SeniorDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    return price * 0.85; // 15% off
  }
}

/// Concrete implementation: VIP discount
class VipDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    return price * 0.8; // 20% off
  }
}

/// NEW discount can be added without modifying existing code
class BlackFridayDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    return price * 0.5; // 50% off
  }
}

/// Price calculator is closed for modification but open for extension
class PriceCalculator {
  double calculatePrice(Product product, DiscountStrategy discount) {
    return discount.applyDiscount(product.price);
  }
}

/// REAL-WORLD EXAMPLE: Payment Processing
/// 
/// Abstract payment processor - closed for modification
abstract class PaymentProcessor {
  bool processPayment(double amount);
  String getPaymentMethod();
}

/// Concrete implementations - can add new payment methods without modifying existing code
class CreditCardProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount) {
    print('Processing \$$amount via Credit Card');
    return true;
  }

  @override
  String getPaymentMethod() => 'Credit Card';
}

class PayPalProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount) {
    print('Processing \$$amount via PayPal');
    return true;
  }

  @override
  String getPaymentMethod() => 'PayPal';
}

class CryptoProcessor implements PaymentProcessor {
  @override
  bool processPayment(double amount) {
    print('Processing \$$amount via Cryptocurrency');
    return true;
  }

  @override
  String getPaymentMethod() => 'Cryptocurrency';
}

/// Payment service - closed for modification, open for extension
class PaymentService {
  void processOrderPayment(double amount, PaymentProcessor processor) {
    final success = processor.processPayment(amount);
    if (success) {
      print('Payment successful via ${processor.getPaymentMethod()}');
    }
  }
}

/// REAL-WORLD EXAMPLE: Shape Area Calculation
abstract class Shape {
  double calculateArea();
}

class Rectangle implements Shape {
  final double width;
  final double height;

  Rectangle({required this.width, required this.height});

  @override
  double calculateArea() {
    return width * height;
  }
}

class Circle implements Shape {
  final double radius;

  Circle({required this.radius});

  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }
}

/// New shape can be added without modifying AreaCalculator
class Triangle implements Shape {
  final double base;
  final double height;

  Triangle({required this.base, required this.height});

  @override
  double calculateArea() {
    return 0.5 * base * height;
  }
}

/// Area calculator - closed for modification
class AreaCalculator {
  double calculateTotalArea(List<Shape> shapes) {
    return shapes.fold<double>(
      0.0,
      (sum, shape) => sum + shape.calculateArea(),
    );
  }
}

