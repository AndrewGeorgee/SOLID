/// SOLUTION: Easy - Open/Closed Principle
///
/// This solution demonstrates how to apply the Open/Closed Principle by using
/// polymorphism. New shapes can be added without modifying the AreaCalculator class.

/// ============================================================================
/// PART 1: Abstract Shape Interface (Open for extension)
/// ============================================================================

abstract class Shape {
  double calculateArea();
}

/// ============================================================================
/// PART 2: Concrete Shape Implementations (Closed for modification)
/// ============================================================================

class Rectangle implements Shape {
  final double width;
  final double height;

  Rectangle({required this.width, required this.height});

  @override
  double calculateArea() {
    return width * height;
  }
}

class Circle implements Shape {
  final double radius;

  Circle({required this.radius});

  @override
  double calculateArea() {
    return 3.14159 * radius * radius;
  }
}

class Square implements Shape {
  final double side;

  Square({required this.side});

  @override
  double calculateArea() {
    return side * side;
  }
}

/// ============================================================================
/// PART 3: Area Calculator (Closed for modification, open for extension)
/// ============================================================================

class AreaCalculator {
  /// Calculates area of any shape without knowing its specific type
  /// New shapes can be added without modifying this method (OCP)
  double calculateArea(Shape shape) {
    return shape.calculateArea();
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  final calculator = AreaCalculator();

  // Works with existing shapes
  print(calculator.calculateArea(Circle(radius: 5))); // 78.53975
  print(calculator.calculateArea(Rectangle(width: 4, height: 6))); // 24
  print(calculator.calculateArea(Square(side: 5))); // 25

  // New shapes can be added without modifying AreaCalculator!
  // Example: Adding Triangle would only require creating Triangle class
  // that implements Shape - no changes to AreaCalculator needed
}
