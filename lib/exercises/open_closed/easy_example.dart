/// EXERCISE: Easy - Open/Closed Principle
///
/// TASK: Refactor this code to follow Open/Closed Principle.
/// Currently, adding a new shape requires modifying the AreaCalculator class.
///
/// HINT: Use polymorphism - create an abstract Shape class with a calculateArea method,
/// then create concrete implementations for each shape.

class AreaCalculator {
  double calculateArea(String shapeType, double value1, double? value2) {
    // To add a new shape, we must modify this method
    switch (shapeType) {
      case 'circle':
        return 3.14159 * value1 * value1; // value1 is radius
      case 'rectangle':
        return value1 * (value2 ?? 0); // value1 is width, value2 is height
      case 'square':
        return value1 * value1; // value1 is side
      // Adding a new shape requires modifying this class
      default:
        return 0;
    }
  }
}
