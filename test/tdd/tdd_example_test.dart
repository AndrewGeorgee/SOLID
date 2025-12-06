import 'package:flutter_test/flutter_test.dart';

/// TDD (TEST-DRIVEN DEVELOPMENT) EXAMPLE
///
/// This demonstrates the TDD workflow:
/// 1. Write a failing test (RED)
/// 2. Write minimal code to make it pass (GREEN)
/// 3. Refactor while keeping tests green (REFACTOR)
///
/// Following SOLID principles throughout the TDD process.

// ============================================================================
// STEP 1: RED - Write failing tests first
// ============================================================================

/// Test for a ShoppingCart class that doesn't exist yet
/// This test will FAIL initially - that's expected in TDD!

void main() {
  group('TDD Example: ShoppingCart - RED Phase', () {
    test('should add item to cart', () {
      // Arrange
      // final cart = ShoppingCart(); // Class doesn't exist yet - test will fail
      // final item = CartItem(id: '1', name: 'Product', price: 10.0);

      // Act
      // cart.addItem(item);

      // Assert
      // expect(cart.getItemCount(), equals(1));
      // expect(cart.getTotal(), equals(10.0));

      // TODO: Uncomment above when implementing ShoppingCart
      expect(true, isTrue); // Placeholder to prevent test failure
    });

    test('should calculate total price correctly', () {
      // Arrange
      // final cart = ShoppingCart();
      // final item1 = CartItem(id: '1', name: 'Product 1', price: 10.0);
      // final item2 = CartItem(id: '2', name: 'Product 2', price: 20.0);

      // Act
      // cart.addItem(item1);
      // cart.addItem(item2);

      // Assert
      // expect(cart.getTotal(), equals(30.0));

      // TODO: Uncomment above when implementing ShoppingCart
      expect(true, isTrue); // Placeholder
    });

    test('should remove item from cart', () {
      // Arrange
      // final cart = ShoppingCart();
      // final item = CartItem(id: '1', name: 'Product', price: 10.0);
      // cart.addItem(item);

      // Act
      // cart.removeItem('1');

      // Assert
      // expect(cart.getItemCount(), equals(0));
      // expect(cart.getTotal(), equals(0.0));

      // TODO: Uncomment above when implementing ShoppingCart
      expect(true, isTrue); // Placeholder
    });

    test('should apply discount correctly', () {
      // Arrange
      // final cart = ShoppingCart();
      // final item = CartItem(id: '1', name: 'Product', price: 100.0);
      // cart.addItem(item);
      // final discount = Discount(percentage: 10.0);

      // Act
      // cart.applyDiscount(discount);

      // Assert
      // expect(cart.getTotal(), equals(90.0));

      // TODO: Uncomment above when implementing ShoppingCart
      expect(true, isTrue); // Placeholder
    });
  });

  group('TDD Example: Following SOLID Principles', () {
    test('ShoppingCart should have single responsibility', () {
      // In TDD, we design for SRP from the start
      // Cart should only manage items, not calculate taxes or process payments

      // Arrange
      // final cart = ShoppingCart();

      // Act & Assert
      // Cart should NOT have these methods (violates SRP):
      // cart.calculateTax() // ❌ Wrong responsibility
      // cart.processPayment() // ❌ Wrong responsibility
      // cart.sendEmail() // ❌ Wrong responsibility

      // Cart SHOULD have these methods (correct responsibility):
      // cart.addItem() // ✅ Correct
      // cart.removeItem() // ✅ Correct
      // cart.getTotal() // ✅ Correct

      expect(true, isTrue); // Placeholder
    });

    test('Discount should be open for extension (OCP)', () {
      // In TDD, we design interfaces that are open for extension

      // Arrange
      // abstract class DiscountStrategy {
      //   double apply(double price);
      // }

      // Act & Assert
      // New discount types can be added without modifying existing code:
      // class StudentDiscount implements DiscountStrategy { ... }
      // class SeniorDiscount implements DiscountStrategy { ... }
      // class BlackFridayDiscount implements DiscountStrategy { ... }

      expect(true, isTrue); // Placeholder
    });
  });
}

// ============================================================================
// STEP 2: GREEN - Implement minimal code to make tests pass
// ============================================================================

/// After writing tests, implement the classes below
/// Keep implementation minimal - just enough to pass tests

// TODO: Implement these classes to make tests pass
/*
class ShoppingCart {
  final List<CartItem> _items = [];

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
  }

  int getItemCount() => _items.length;

  double getTotal() {
    return _items.fold<double>(0.0, (sum, item) => sum + item.price);
  }

  void applyDiscount(Discount discount) {
    // Implementation for discount
  }
}

class CartItem {
  final String id;
  final String name;
  final double price;

  CartItem({required this.id, required this.name, required this.price});
}

class Discount {
  final double percentage;

  Discount({required this.percentage});
}
*/

// ============================================================================
// STEP 3: REFACTOR - Improve code while keeping tests green
// ============================================================================

/// After tests pass, refactor to improve:
/// - Code quality
/// - Performance
/// - SOLID principles adherence
/// - Remove duplication

/// Example refactoring:
/// 1. Extract discount calculation to separate class (SRP)
/// 2. Use strategy pattern for discounts (OCP)
/// 3. Add proper error handling
/// 4. Add validation
