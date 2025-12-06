import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/open_closed/good_example.dart';
import '../../lib/models/product.dart';

/// INTEGRATION TESTS: Pricing System
/// 
/// Tests the integration of discount strategies, payment processors,
/// and price calculation working together.

void main() {
  group('Pricing System Integration', () {
    late PriceCalculator priceCalculator;
    late PaymentService paymentService;
    late Product product;

    setUp(() {
      priceCalculator = PriceCalculator();
      paymentService = PaymentService();
      product = Product(
        id: '1',
        name: 'Test Product',
        price: 100.0,
        category: 'electronics',
      );
    });

    test('should calculate price and process payment with discount', () {
      // Arrange
      final discount = StudentDiscount();
      final paymentProcessor = CreditCardProcessor();

      // Act
      final discountedPrice = priceCalculator.calculatePrice(product, discount);
      final paymentSuccess = paymentProcessor.processPayment(discountedPrice);

      // Assert
      expect(discountedPrice, equals(90.0));
      expect(paymentSuccess, isTrue);
    });

    test('should work with multiple discount and payment combinations', () {
      // Arrange
      final discounts = [
        StudentDiscount(),
        SeniorDiscount(),
        VipDiscount(),
        BlackFridayDiscount(),
      ];
      final processors = [
        CreditCardProcessor(),
        PayPalProcessor(),
        CryptoProcessor(),
      ];

      // Act & Assert - All combinations should work
      for (final discount in discounts) {
        for (final processor in processors) {
          final price = priceCalculator.calculatePrice(product, discount);
          final success = processor.processPayment(price);

          expect(price, greaterThan(0));
          expect(success, isTrue);
        }
      }
    });

    test('should handle complete purchase flow', () {
      // Arrange
      final discount = VipDiscount();
      final processor = PayPalProcessor();

      // Act
      // 1. Calculate discounted price
      final finalPrice = priceCalculator.calculatePrice(product, discount);

      // 2. Process payment
      paymentService.processOrderPayment(finalPrice, processor);

      // Assert
      expect(finalPrice, equals(80.0)); // 20% discount
    });
  });

  group('Shape Calculation Integration', () {
    late AreaCalculator areaCalculator;

    setUp(() {
      areaCalculator = AreaCalculator();
    });

    test('should calculate total area of mixed shapes', () {
      // Arrange
      final shapes = [
        Rectangle(width: 10.0, height: 5.0), // 50
        // Square not available in this example, using Rectangle instead
        Rectangle(width: 5.0, height: 5.0), // 25
        Circle(radius: 5.0), // ~78.54
        Triangle(base: 10.0, height: 5.0), // 25
      ];

      // Act
      final totalArea = areaCalculator.calculateTotalArea(shapes);

      // Assert
      expect(totalArea, closeTo(178.54, 0.01));
    });

    test('should handle empty shape list', () {
      // Arrange
      final shapes = <Shape>[];

      // Act
      final totalArea = areaCalculator.calculateTotalArea(shapes);

      // Assert
      expect(totalArea, equals(0.0));
    });
  });
}

