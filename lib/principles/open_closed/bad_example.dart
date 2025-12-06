import '../../models/product.dart';

/// BAD EXAMPLE: Violates Open/Closed Principle
/// 
/// To add a new discount type, we must modify the existing class.
/// This violates the "closed for modification" part of OCP.
class PriceCalculator {
  double calculatePrice(Product product, String discountType) {
    double price = product.price;

    // If we want to add a new discount type, we must modify this method
    switch (discountType) {
      case 'student':
        price = product.price * 0.9; // 10% off
        break;
      case 'senior':
        price = product.price * 0.85; // 15% off
        break;
      case 'vip':
        price = product.price * 0.8; // 20% off
        break;
      // Adding a new discount requires modifying this switch statement
      default:
        price = product.price;
    }

    return price;
  }
}

/// Another bad example: Shape area calculator
class AreaCalculator {
  double calculateArea(String shapeType, double width, double? height) {
    // To add a new shape, we must modify this method
    switch (shapeType) {
      case 'rectangle':
        return width * (height ?? 0);
      case 'circle':
        return 3.14159 * width * width; // width is radius
      // Adding triangle requires modifying this class
      default:
        return 0;
    }
  }
}

