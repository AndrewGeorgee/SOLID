/// BAD EXAMPLE: Violates Liskov Substitution Principle
/// 
/// Square cannot properly substitute Rectangle because it changes
/// the expected behavior (setting width/height independently).

class Rectangle {
  double width;
  double height;

  Rectangle({required this.width, required this.height});

  double getArea() {
    return width * height;
  }

  void setWidth(double w) {
    width = w;
  }

  void setHeight(double h) {
    height = h;
  }
}

/// This violates LSP because Square changes the behavior of setWidth/setHeight
/// A function expecting Rectangle won't work correctly with Square
class Square extends Rectangle {
  Square({required double side}) : super(width: side, height: side);

  @override
  void setWidth(double w) {
    super.setWidth(w);
    super.setHeight(w); // This changes expected behavior!
  }

  @override
  void setHeight(double h) {
    super.setHeight(h);
    super.setWidth(h); // This changes expected behavior!
  }
}

/// This function expects Rectangle behavior but breaks with Square
void resizeRectangle(Rectangle rectangle) {
  rectangle.setWidth(5);
  rectangle.setHeight(4);
  // Expects area = 20, but with Square it becomes 16 (4*4)
  // This violates LSP!
}

/// Another bad example: Bird hierarchy
class Bird {
  void fly() {
    print('Flying...');
  }

  void eat() {
    print('Eating...');
  }
}

/// Penguin cannot fly, so it violates LSP when substituted for Bird
class Penguin extends Bird {
  @override
  void fly() {
    throw Exception('Penguins cannot fly!'); // Breaks LSP!
  }
}

