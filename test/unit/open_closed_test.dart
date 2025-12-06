import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/open_closed/good_example.dart';
import '../../lib/models/product.dart';

/// UNIT TESTS: Open/Closed Principle
/// 
/// Tests that new discount strategies can be added without modifying
/// existing code, demonstrating the principle in action.

void main() {
  group('Discount Strategies - Open for Extension', () {
    test('StudentDiscount should apply 10% discount', () {
      // Arrange
      final discount = StudentDiscount();
      final originalPrice = 100.0;

      // Act
      final discountedPrice = discount.applyDiscount(originalPrice);

      // Assert
      expect(discountedPrice, equals(90.0));
    });

    test('SeniorDiscount should apply 15% discount', () {
      // Arrange
      final discount = SeniorDiscount();
      final originalPrice = 100.0;

      // Act
      final discountedPrice = discount.applyDiscount(originalPrice);

      // Assert
      expect(discountedPrice, equals(85.0));
    });

    test('VipDiscount should apply 20% discount', () {
      // Arrange
      final discount = VipDiscount();
      final originalPrice = 100.0;

      // Act
      final discountedPrice = discount.applyDiscount(originalPrice);

      // Assert
      expect(discountedPrice, equals(80.0));
    });

    test('BlackFridayDiscount should apply 50% discount', () {
      // Arrange
      final discount = BlackFridayDiscount();
      final originalPrice = 100.0;

      // Act
      final discountedPrice = discount.applyDiscount(originalPrice);

      // Assert
      expect(discountedPrice, equals(50.0));
    });
  });

  group('PriceCalculator - Closed for Modification', () {
    late PriceCalculator calculator;
    late Product product;

    setUp(() {
      calculator = PriceCalculator();
      product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        category: 'electronics',
      );
    });

    test('should calculate price with StudentDiscount', () {
      // Arrange
      final discount = StudentDiscount();

      // Act
      final finalPrice = calculator.calculatePrice(product, discount);

      // Assert
      expect(finalPrice, equals(90.0));
    });

    test('should calculate price with VipDiscount', () {
      // Arrange
      final discount = VipDiscount();

      // Act
      final finalPrice = calculator.calculatePrice(product, discount);

      // Assert
      expect(finalPrice, equals(80.0));
    });

    test('should work with new discount types without modification', () {
      // Arrange - New discount type added without modifying PriceCalculator
      final discount = BlackFridayDiscount();

      // Act
      final finalPrice = calculator.calculatePrice(product, discount);

      // Assert
      expect(finalPrice, equals(50.0));
    });
  });

  group('Payment Processors - Open for Extension', () {
    test('CreditCardProcessor should process payment', () {
      // Arrange
      final processor = CreditCardProcessor();

      // Act
      final result = processor.processPayment(100.0);

      // Assert
      expect(result, isTrue);
      expect(processor.getPaymentMethod(), equals('Credit Card'));
    });

    test('PayPalProcessor should process payment', () {
      // Arrange
      final processor = PayPalProcessor();

      // Act
      final result = processor.processPayment(100.0);

      // Assert
      expect(result, isTrue);
      expect(processor.getPaymentMethod(), equals('PayPal'));
    });

    test('CryptoProcessor should process payment', () {
      // Arrange
      final processor = CryptoProcessor();

      // Act
      final result = processor.processPayment(100.0);

      // Assert
      expect(result, isTrue);
      expect(processor.getPaymentMethod(), equals('Cryptocurrency'));
    });
  });

  group('PaymentService - Closed for Modification', () {
    late PaymentService paymentService;

    setUp(() {
      paymentService = PaymentService();
    });

    test('should process payment with any processor', () {
      // Arrange
      final processor = CreditCardProcessor();

      // Act & Assert - Should not throw
      expect(
        () => paymentService.processOrderPayment(100.0, processor),
        returnsNormally,
      );
    });

    test('should work with new payment processors without modification', () {
      // Arrange - New processor added without modifying PaymentService
      final processor = CryptoProcessor();

      // Act & Assert
      expect(
        () => paymentService.processOrderPayment(100.0, processor),
        returnsNormally,
      );
    });
  });

  group('Shape Hierarchy - Open for Extension', () {
    test('Rectangle should calculate area correctly', () {
      // Arrange
      final rectangle = Rectangle(width: 5.0, height: 4.0);

      // Act
      final area = rectangle.calculateArea();

      // Assert
      expect(area, equals(20.0));
    });

    test('Circle should calculate area correctly', () {
      // Arrange
      final circle = Circle(radius: 5.0);

      // Act
      final area = circle.calculateArea();

      // Assert
      expect(area, closeTo(78.54, 0.01));
    });

    test('Triangle should calculate area correctly', () {
      // Arrange
      final triangle = Triangle(base: 10.0, height: 5.0);

      // Act
      final area = triangle.calculateArea();

      // Assert
      expect(area, equals(25.0));
    });
  });

  group('AreaCalculator - Closed for Modification', () {
    late AreaCalculator calculator;

    setUp(() {
      calculator = AreaCalculator();
    });

    test('should calculate total area of multiple shapes', () {
      // Arrange
      final shapes = [
        Rectangle(width: 5.0, height: 4.0), // 20
        Circle(radius: 5.0), // ~78.54
        Triangle(base: 10.0, height: 5.0), // 25
      ];

      // Act
      final totalArea = calculator.calculateTotalArea(shapes);

      // Assert
      expect(totalArea, closeTo(123.54, 0.01));
    });

    test('should work with new shape types without modification', () {
      // Arrange - New shape added without modifying AreaCalculator
      final shapes = [
        Rectangle(width: 5.0, height: 4.0),
        Circle(radius: 5.0),
        Triangle(base: 10.0, height: 5.0), // New shape
      ];

      // Act
      final totalArea = calculator.calculateTotalArea(shapes);

      // Assert
      expect(totalArea, greaterThan(0));
    });
  });
}

