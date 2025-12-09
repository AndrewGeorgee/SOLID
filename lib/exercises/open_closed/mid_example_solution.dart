/// SOLUTION: Mid - Open/Closed Principle
///
/// This solution demonstrates how to apply the Open/Closed Principle using
/// the Strategy Pattern. New discount types can be added without modifying
/// the PriceCalculator class.

/// ============================================================================
/// PART 1: Discount Strategy Interface (Open for extension)
/// ============================================================================

abstract class DiscountStrategy {
  double applyDiscount(double price);
}

/// ============================================================================
/// PART 2: Concrete Discount Implementations (Closed for modification)
/// ============================================================================

class PercentageDiscount implements DiscountStrategy {
  final double percentage;

  PercentageDiscount({required this.percentage});

  @override
  double applyDiscount(double price) {
    return price * (1 - percentage / 100);
  }
}

class FixedAmountDiscount implements DiscountStrategy {
  final double amount;

  FixedAmountDiscount({required this.amount});

  @override
  double applyDiscount(double price) {
    // Prevent negative prices
    return (price - amount).clamp(0.0, double.infinity);
  }
}

class BuyOneGetOneDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    // BOGO logic - every second item is free (50% off)
    return price * 0.5;
  }
}

class StudentDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    // 10% discount for students
    return price * 0.9;
  }
}

class SeniorDiscount implements DiscountStrategy {
  @override
  double applyDiscount(double price) {
    // 15% discount for seniors
    return price * 0.85;
  }
}

/// ============================================================================
/// PART 3: Price Calculator (Closed for modification, open for extension)
/// ============================================================================

class PriceCalculator {
  /// Calculates final price with any discount strategy
  /// New discount types can be added without modifying this method (OCP)
  double calculateFinalPrice(
    double basePrice,
    DiscountStrategy discountStrategy,
  ) {
    return discountStrategy.applyDiscount(basePrice);
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  final calculator = PriceCalculator();

  // Works with all discount types
  print(
    calculator.calculateFinalPrice(100, PercentageDiscount(percentage: 10)),
  ); // 90.0

  print(
    calculator.calculateFinalPrice(100, FixedAmountDiscount(amount: 10)),
  ); // 90.0

  print(calculator.calculateFinalPrice(100, BuyOneGetOneDiscount())); // 50.0

  print(calculator.calculateFinalPrice(100, StudentDiscount())); // 90.0

  print(calculator.calculateFinalPrice(100, SeniorDiscount())); // 85.0

  // New discount types can be added without modifying PriceCalculator!
  // Example: Adding VIPDiscount would only require creating VIPDiscount class
  // that implements DiscountStrategy - no changes to PriceCalculator needed
}
