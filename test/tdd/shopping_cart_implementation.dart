/// TDD IMPLEMENTATION EXAMPLE
///
/// This file shows the implementation after TDD process:
/// 1. Tests were written first (see tdd_example_test.dart)
/// 2. Minimal implementation to pass tests
/// 3. Refactored following SOLID principles

// Product model not needed for this implementation

/// CartItem model
class CartItem {
  final String id;
  final String name;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// Discount Strategy - Following Open/Closed Principle
abstract class DiscountStrategy {
  double apply(double price);
  String getDiscountName();
}

class PercentageDiscount implements DiscountStrategy {
  final double percentage;

  PercentageDiscount({required this.percentage});

  @override
  double apply(double price) {
    return price * (1 - percentage / 100);
  }

  @override
  String getDiscountName() => '${percentage}% Discount';
}

class FixedAmountDiscount implements DiscountStrategy {
  final double amount;

  FixedAmountDiscount({required this.amount});

  @override
  double apply(double price) {
    return (price - amount).clamp(0.0, double.infinity);
  }

  @override
  String getDiscountName() => 'Fixed \$$amount Discount';
}

/// ShoppingCart - Following Single Responsibility Principle
/// Only responsible for managing cart items
class ShoppingCart {
  final List<CartItem> _items = [];

  void addItem(CartItem item) {
    _items.add(item);
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
  }

  void updateQuantity(String itemId, int quantity) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = CartItem(
          id: _items[index].id,
          name: _items[index].name,
          price: _items[index].price,
          quantity: quantity,
        );
      }
    }
  }

  int getItemCount() => _items.length;

  double getSubtotal() {
    return _items.fold<double>(0.0, (sum, item) => sum + item.total);
  }

  void clear() {
    _items.clear();
  }

  List<CartItem> getItems() => List.unmodifiable(_items);
}

/// PriceCalculator - Following Single Responsibility Principle
/// Only responsible for calculating prices with discounts
class CartPriceCalculator {
  double calculateTotal(ShoppingCart cart, {DiscountStrategy? discount}) {
    final subtotal = cart.getSubtotal();
    if (discount != null) {
      return discount.apply(subtotal);
    }
    return subtotal;
  }
}

/// Example usage demonstrating SOLID principles
void exampleUsage() {
  // Create cart
  final cart = ShoppingCart();

  // Add items
  cart.addItem(CartItem(id: '1', name: 'Product 1', price: 10.0, quantity: 2));

  cart.addItem(CartItem(id: '2', name: 'Product 2', price: 20.0, quantity: 1));

  // Calculate price with discount (OCP - can use any discount strategy)
  final calculator = CartPriceCalculator();
  final discount = PercentageDiscount(percentage: 10.0);
  final total = calculator.calculateTotal(cart, discount: discount);

  print('Subtotal: \$${cart.getSubtotal()}');
  print('Discount: ${discount.getDiscountName()}');
  print('Total: \$$total');
}
