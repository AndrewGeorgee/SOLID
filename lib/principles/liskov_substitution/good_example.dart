/// GOOD EXAMPLE: Follows Liskov Substitution Principle
/// 
/// All subclasses can be substituted for their base classes without
/// breaking functionality or changing expected behavior.

/// Base class with proper abstraction
abstract class Shape {
  double getArea();
  double getPerimeter();
}

/// Rectangle implementation - can be substituted anywhere Shape is expected
class Rectangle implements Shape {
  final double width;
  final double height;

  Rectangle({required this.width, required this.height});

  @override
  double getArea() {
    return width * height;
  }

  @override
  double getPerimeter() {
    return 2 * (width + height);
  }
}

/// Square implementation - properly substitutable for Shape
class Square implements Shape {
  final double side;

  Square({required this.side});

  @override
  double getArea() {
    return side * side;
  }

  @override
  double getPerimeter() {
    return 4 * side;
  }
}

/// Circle implementation - also substitutable
class Circle implements Shape {
  final double radius;

  Circle({required this.radius});

  @override
  double getArea() {
    return 3.14159 * radius * radius;
  }

  @override
  double getPerimeter() {
    return 2 * 3.14159 * radius;
  }
}

/// This function works correctly with any Shape subclass
double calculateTotalArea(List<Shape> shapes) {
  return shapes.fold<double>(
    0.0,
    (sum, shape) => sum + shape.getArea(),
  );
}

/// REAL-WORLD EXAMPLE: Payment Processing
/// 
/// All payment methods are substitutable for PaymentMethod

abstract class PaymentMethod {
  bool processPayment(double amount);
  String getMethodName();
}

class CreditCardPayment implements PaymentMethod {
  final String cardNumber;

  CreditCardPayment({required this.cardNumber});

  @override
  bool processPayment(double amount) {
    print('Processing \$$amount with credit card ending in ${cardNumber.substring(cardNumber.length - 4)}');
    return true;
  }

  @override
  String getMethodName() => 'Credit Card';
}

class DebitCardPayment implements PaymentMethod {
  final String cardNumber;

  DebitCardPayment({required this.cardNumber});

  @override
  bool processPayment(double amount) {
    print('Processing \$$amount with debit card ending in ${cardNumber.substring(cardNumber.length - 4)}');
    return true;
  }

  @override
  String getMethodName() => 'Debit Card';
}

class PayPalPayment implements PaymentMethod {
  final String email;

  PayPalPayment({required this.email});

  @override
  bool processPayment(double amount) {
    print('Processing \$$amount via PayPal account $email');
    return true;
  }

  @override
  String getMethodName() => 'PayPal';
}

/// This function works with any PaymentMethod - LSP is satisfied
void processOrderPayment(double amount, PaymentMethod paymentMethod) {
  final success = paymentMethod.processPayment(amount);
  if (success) {
    print('Order payment successful via ${paymentMethod.getMethodName()}');
  }
}

/// REAL-WORLD EXAMPLE: Bird Hierarchy (Fixed)
/// 
/// Proper abstraction separates flying birds from non-flying birds

abstract class Bird {
  void eat();
  void sleep();
}

abstract class FlyingBird extends Bird {
  void fly();
}

abstract class NonFlyingBird extends Bird {
  void walk();
}

/// Can fly - properly substitutable for FlyingBird
class Sparrow extends FlyingBird {
  @override
  void eat() {
    print('Sparrow is eating seeds');
  }

  @override
  void sleep() {
    print('Sparrow is sleeping');
  }

  @override
  void fly() {
    print('Sparrow is flying');
  }
}

/// Cannot fly - properly substitutable for NonFlyingBird
class Penguin extends NonFlyingBird {
  @override
  void eat() {
    print('Penguin is eating fish');
  }

  @override
  void sleep() {
    print('Penguin is sleeping');
  }

  @override
  void walk() {
    print('Penguin is walking');
  }
}

/// Functions work correctly with proper abstractions
void makeBirdFly(FlyingBird bird) {
  bird.fly(); // Works correctly - all FlyingBird subclasses can fly
}

void makeBirdWalk(NonFlyingBird bird) {
  bird.walk(); // Works correctly - all NonFlyingBird subclasses can walk
}

