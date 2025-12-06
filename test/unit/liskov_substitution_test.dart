import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/liskov_substitution/good_example.dart';

/// UNIT TESTS: Liskov Substitution Principle
/// 
/// Tests that all subclasses can be substituted for their base classes
/// without breaking functionality.

void main() {
  group('Shape Hierarchy - Liskov Substitution', () {
    test('Rectangle should be substitutable for Shape', () {
      // Arrange
      final rectangle = Rectangle(width: 5.0, height: 4.0);
      final shapes = <Shape>[rectangle];

      // Act
      final totalArea = calculateTotalArea(shapes);

      // Assert
      expect(totalArea, equals(20.0));
    });

    test('Square should be substitutable for Shape', () {
      // Arrange
      final square = Square(side: 5.0);
      final shapes = <Shape>[square];

      // Act
      final totalArea = calculateTotalArea(shapes);

      // Assert
      expect(totalArea, equals(25.0));
    });

    test('Circle should be substitutable for Shape', () {
      // Arrange
      final circle = Circle(radius: 5.0);
      final shapes = <Shape>[circle];

      // Act
      final totalArea = calculateTotalArea(shapes);

      // Assert
      expect(totalArea, closeTo(78.54, 0.01));
    });

    test('All shapes should work together in same function', () {
      // Arrange - Mix of different shape types
      final shapes = <Shape>[
        Rectangle(width: 5.0, height: 4.0),
        Square(side: 5.0),
        Circle(radius: 5.0),
      ];

      // Act
      final totalArea = calculateTotalArea(shapes);

      // Assert
      expect(totalArea, greaterThan(0));
      expect(totalArea, closeTo(123.54, 0.01));
    });
  });

  group('Payment Methods - Liskov Substitution', () {
    test('CreditCardPayment should be substitutable for PaymentMethod', () {
      // Arrange
      final payment = CreditCardPayment(cardNumber: '1234567890123456');
      final amount = 100.0;

      // Act
      final result = payment.processPayment(amount);

      // Assert
      expect(result, isTrue);
      expect(payment.getMethodName(), equals('Credit Card'));
    });

    test('DebitCardPayment should be substitutable for PaymentMethod', () {
      // Arrange
      final payment = DebitCardPayment(cardNumber: '1234567890123456');
      final amount = 100.0;

      // Act
      final result = payment.processPayment(amount);

      // Assert
      expect(result, isTrue);
      expect(payment.getMethodName(), equals('Debit Card'));
    });

    test('PayPalPayment should be substitutable for PaymentMethod', () {
      // Arrange
      final payment = PayPalPayment(email: 'user@example.com');
      final amount = 100.0;

      // Act
      final result = payment.processPayment(amount);

      // Assert
      expect(result, isTrue);
      expect(payment.getMethodName(), equals('PayPal'));
    });

    test('All payment methods should work with same function', () {
      // Arrange - Function accepts any PaymentMethod
      final payments = <PaymentMethod>[
        CreditCardPayment(cardNumber: '1234567890123456'),
        DebitCardPayment(cardNumber: '6543210987654321'),
        PayPalPayment(email: 'user@example.com'),
      ];

      // Act & Assert - All should work
      for (final payment in payments) {
        // processOrderPayment returns void, so we just verify it doesn't throw
        expect(() => processOrderPayment(100.0, payment), returnsNormally);
      }
    });
  });

  group('Bird Hierarchy - Liskov Substitution', () {
    test('Sparrow should be substitutable for FlyingBird', () {
      // Arrange
      final sparrow = Sparrow();

      // Act & Assert - Should not throw
      expect(() => makeBirdFly(sparrow), returnsNormally);
    });

    test('Penguin should be substitutable for NonFlyingBird', () {
      // Arrange
      final penguin = Penguin();

      // Act & Assert - Should not throw
      expect(() => makeBirdWalk(penguin), returnsNormally);
    });

    test('All birds should support basic operations', () {
      // Arrange
      final flyingBird = Sparrow();
      final nonFlyingBird = Penguin();

      // Act & Assert - All birds can eat and sleep
      expect(() => flyingBird.eat(), returnsNormally);
      expect(() => flyingBird.sleep(), returnsNormally);
      expect(() => nonFlyingBird.eat(), returnsNormally);
      expect(() => nonFlyingBird.sleep(), returnsNormally);
    });
  });
}

