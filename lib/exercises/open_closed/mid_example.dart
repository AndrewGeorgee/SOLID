/// EXERCISE: Mid - Open/Closed Principle
///
/// TASK: Refactor this code to follow Open/Closed Principle.
/// Currently, adding a new discount type requires modifying the PriceCalculator class.
///
/// HINT: Create an abstract DiscountStrategy interface/abstract class,
/// then create concrete implementations for each discount type.
/// Use strategy pattern to make it extensible.

class PriceCalculator {
  double calculateFinalPrice(
    double basePrice,
    String discountType,
    double? discountValue,
  ) {
    double finalPrice = basePrice;

    // To add a new discount type, we must modify this method
    switch (discountType) {
      case 'percentage':
        finalPrice = basePrice * (1 - (discountValue ?? 0) / 100);
        break;
      case 'fixed':
        finalPrice = basePrice - (discountValue ?? 0);
        break;
      case 'buy_one_get_one':
        // BOGO logic - every second item is free
        finalPrice = basePrice * 0.5;
        break;
      case 'student':
        finalPrice = basePrice * 0.9; // 10% off
        break;
      case 'senior':
        finalPrice = basePrice * 0.85; // 15% off
        break;
      // Adding a new discount requires modifying this switch statement
      default:
        finalPrice = basePrice;
    }

    return finalPrice;
  }
}
