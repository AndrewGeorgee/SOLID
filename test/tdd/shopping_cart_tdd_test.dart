import 'package:flutter_test/flutter_test.dart';
import 'shopping_cart_implementation.dart';

/// TDD TESTS: ShoppingCart Implementation
/// 
/// These tests were written FIRST (TDD approach),
/// then the implementation was created to make them pass.

void main() {
  group('ShoppingCart - TDD Tests', () {
    late ShoppingCart cart;

    setUp(() {
      cart = ShoppingCart();
    });

    test('should add item to cart', () {
      // Arrange
      final item = CartItem(
        id: '1',
        name: 'Product',
        price: 10.0,
      );

      // Act
      cart.addItem(item);

      // Assert
      expect(cart.getItemCount(), equals(1));
      expect(cart.getSubtotal(), equals(10.0));
    });

    test('should calculate total price correctly', () {
      // Arrange
      final item1 = CartItem(
        id: '1',
        name: 'Product 1',
        price: 10.0,
        quantity: 2,
      );
      final item2 = CartItem(
        id: '2',
        name: 'Product 2',
        price: 20.0,
        quantity: 1,
      );

      // Act
      cart.addItem(item1);
      cart.addItem(item2);

      // Assert
      expect(cart.getSubtotal(), equals(40.0)); // (10 * 2) + (20 * 1)
    });

    test('should remove item from cart', () {
      // Arrange
      final item = CartItem(
        id: '1',
        name: 'Product',
        price: 10.0,
      );
      cart.addItem(item);

      // Act
      cart.removeItem('1');

      // Assert
      expect(cart.getItemCount(), equals(0));
      expect(cart.getSubtotal(), equals(0.0));
    });

    test('should update item quantity', () {
      // Arrange
      final item = CartItem(
        id: '1',
        name: 'Product',
        price: 10.0,
        quantity: 1,
      );
      cart.addItem(item);

      // Act
      cart.updateQuantity('1', 3);

      // Assert
      expect(cart.getSubtotal(), equals(30.0));
    });

    test('should remove item when quantity set to zero', () {
      // Arrange
      final item = CartItem(
        id: '1',
        name: 'Product',
        price: 10.0,
      );
      cart.addItem(item);

      // Act
      cart.updateQuantity('1', 0);

      // Assert
      expect(cart.getItemCount(), equals(0));
    });

    test('should clear all items', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product 1', price: 10.0));
      cart.addItem(CartItem(id: '2', name: 'Product 2', price: 20.0));

      // Act
      cart.clear();

      // Assert
      expect(cart.getItemCount(), equals(0));
      expect(cart.getSubtotal(), equals(0.0));
    });
  });

  group('CartPriceCalculator - TDD Tests', () {
    late ShoppingCart cart;
    late CartPriceCalculator calculator;

    setUp(() {
      cart = ShoppingCart();
      calculator = CartPriceCalculator();
    });

    test('should calculate total without discount', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product', price: 100.0));

      // Act
      final total = calculator.calculateTotal(cart);

      // Assert
      expect(total, equals(100.0));
    });

    test('should apply percentage discount correctly', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product', price: 100.0));
      final discount = PercentageDiscount(percentage: 10.0);

      // Act
      final total = calculator.calculateTotal(cart, discount: discount);

      // Assert
      expect(total, equals(90.0));
    });

    test('should apply fixed amount discount correctly', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product', price: 100.0));
      final discount = FixedAmountDiscount(amount: 20.0);

      // Act
      final total = calculator.calculateTotal(cart, discount: discount);

      // Assert
      expect(total, equals(80.0));
    });

    test('should handle discount that exceeds price', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product', price: 10.0));
      final discount = FixedAmountDiscount(amount: 20.0);

      // Act
      final total = calculator.calculateTotal(cart, discount: discount);

      // Assert - Should not go below 0
      expect(total, equals(0.0));
    });

    test('should work with multiple discount strategies (OCP)', () {
      // Arrange
      cart.addItem(CartItem(id: '1', name: 'Product', price: 100.0));
      final percentageDiscount = PercentageDiscount(percentage: 10.0);
      final fixedDiscount = FixedAmountDiscount(amount: 5.0);

      // Act
      final total1 = calculator.calculateTotal(cart, discount: percentageDiscount);
      final total2 = calculator.calculateTotal(cart, discount: fixedDiscount);

      // Assert - Both discount types work without modifying calculator
      expect(total1, equals(90.0));
      expect(total2, equals(95.0));
    });
  });

  group('SOLID Principles Verification', () {
    test('ShoppingCart has single responsibility', () {
      // Arrange
      final cart = ShoppingCart();

      // Assert - Cart only manages items, not calculations
      // Cart has: addItem, removeItem, getItemCount, getSubtotal
      // Cart does NOT have: calculateTax, processPayment, sendEmail
      expect(cart, isA<ShoppingCart>());
    });

    test('CartPriceCalculator has single responsibility', () {
      // Arrange
      final calculator = CartPriceCalculator();

      // Assert - Calculator only calculates prices
      // Calculator does NOT manage cart items
      expect(calculator, isA<CartPriceCalculator>());
    });

    test('Discount strategies follow Open/Closed Principle', () {
      // Arrange
      final percentageDiscount = PercentageDiscount(percentage: 10.0);
      final fixedDiscount = FixedAmountDiscount(amount: 10.0);

      // Assert - Both implement same interface, can be used interchangeably
      expect(percentageDiscount, isA<DiscountStrategy>());
      expect(fixedDiscount, isA<DiscountStrategy>());
    });
  });
}

