/// GOOD EXAMPLE: Follows Interface Segregation Principle
/// 
/// Interfaces are segregated into small, focused interfaces.
/// Classes only implement the interfaces they actually need.

/// Segregated interfaces - each has a single, focused responsibility

/// Basic human functions
abstract class Human {
  void eat();
  void sleep();
}

/// Work interface
abstract class Workable {
  void work();
}

/// Coding interface
abstract class Codeable {
  void code();
}

/// Management interface
abstract class Manageable {
  void manage();
}

/// Design interface
abstract class Designable {
  void design();
}

/// Developer implements only relevant interfaces
class Developer implements Human, Workable, Codeable {
  @override
  void eat() {
    print('Developer is eating');
  }

  @override
  void sleep() {
    print('Developer is sleeping');
  }

  @override
  void work() {
    print('Developer is working');
  }

  @override
  void code() {
    print('Developer is coding');
  }
  // No need to implement manage() or design()
}

/// Manager implements only relevant interfaces
class Manager implements Human, Workable, Manageable {
  @override
  void eat() {
    print('Manager is eating');
  }

  @override
  void sleep() {
    print('Manager is sleeping');
  }

  @override
  void work() {
    print('Manager is working');
  }

  @override
  void manage() {
    print('Manager is managing');
  }
  // No need to implement code() or design()
}

/// Designer implements only relevant interfaces
class Designer implements Human, Workable, Designable {
  @override
  void eat() {
    print('Designer is eating');
  }

  @override
  void sleep() {
    print('Designer is sleeping');
  }

  @override
  void work() {
    print('Designer is working');
  }

  @override
  void design() {
    print('Designer is designing');
  }
  // No need to implement code() or manage()
}

/// Full-stack developer can implement multiple interfaces
class FullStackDeveloper implements Human, Workable, Codeable, Designable {
  @override
  void eat() {
    print('Full-stack developer is eating');
  }

  @override
  void sleep() {
    print('Full-stack developer is sleeping');
  }

  @override
  void work() {
    print('Full-stack developer is working');
  }

  @override
  void code() {
    print('Full-stack developer is coding');
  }

  @override
  void design() {
    print('Full-stack developer is designing');
  }
}

/// REAL-WORLD EXAMPLE: Document Processing
/// 
/// Segregated interfaces for different document operations

/// Basic document interface
abstract class Document {
  String getContent();
}

/// Printing interface
abstract class Printable {
  void printDocument();
}

/// Scannable interface
abstract class Scannable {
  void scanDocument();
}

/// Faxable interface
abstract class Faxable {
  void faxDocument();
}

/// Photocopier implements all interfaces
class Photocopier implements Printable, Scannable {
  @override
  void printDocument() {
    print('Printing document...');
  }

  @override
  void scanDocument() {
    print('Scanning document...');
  }
}

/// Printer only needs printing
class Printer implements Printable {
  @override
  void printDocument() {
    print('Printing document...');
  }
}

/// Scanner only needs scanning
class Scanner implements Scannable {
  @override
  void scanDocument() {
    print('Scanning document...');
  }
}

/// Fax machine only needs faxing
class FaxMachine implements Faxable {
  @override
  void faxDocument() {
    print('Faxing document...');
  }
}

/// Multi-function device implements multiple interfaces
class MultiFunctionDevice implements Printable, Scannable, Faxable {
  @override
  void printDocument() {
    print('Printing document...');
  }

  @override
  void scanDocument() {
    print('Scanning document...');
  }

  @override
  void faxDocument() {
    print('Faxing document...');
  }
}

/// REAL-WORLD EXAMPLE: Vehicle Interfaces
abstract class Drivable {
  void drive();
}

abstract class Flyable {
  void fly();
}

abstract class Swimmable {
  void swim();
}

class Car implements Drivable {
  @override
  void drive() {
    print('Car is driving');
  }
}

class Airplane implements Flyable {
  @override
  void fly() {
    print('Airplane is flying');
  }
}

class Boat implements Swimmable {
  @override
  void swim() {
    print('Boat is swimming');
  }
}

/// Amphibious vehicle can implement multiple interfaces
class AmphibiousVehicle implements Drivable, Swimmable {
  @override
  void drive() {
    print('Amphibious vehicle is driving');
  }

  @override
  void swim() {
    print('Amphibious vehicle is swimming');
  }
}

