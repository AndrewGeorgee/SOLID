import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/interface_segregation/good_example.dart';

/// UNIT TESTS: Interface Segregation Principle
/// 
/// Tests that classes only implement interfaces they need,
/// and services work with specific interfaces.

void main() {
  group('Worker Interfaces - Segregated', () {
    test('Developer should only implement needed interfaces', () {
      // Arrange
      final developer = Developer();

      // Act & Assert - Developer can do these
      expect(() => developer.eat(), returnsNormally);
      expect(() => developer.sleep(), returnsNormally);
      expect(() => developer.work(), returnsNormally);
      expect(() => developer.code(), returnsNormally);

      // Developer does NOT have manage() or design() methods
      // This is correct - no fat interface!
    });

    test('Manager should only implement needed interfaces', () {
      // Arrange
      final manager = Manager();

      // Act & Assert - Manager can do these
      expect(() => manager.eat(), returnsNormally);
      expect(() => manager.sleep(), returnsNormally);
      expect(() => manager.work(), returnsNormally);
      expect(() => manager.manage(), returnsNormally);

      // Manager does NOT have code() or design() methods
    });

    test('Designer should only implement needed interfaces', () {
      // Arrange
      final designer = Designer();

      // Act & Assert - Designer can do these
      expect(() => designer.eat(), returnsNormally);
      expect(() => designer.sleep(), returnsNormally);
      expect(() => designer.work(), returnsNormally);
      expect(() => designer.design(), returnsNormally);

      // Designer does NOT have code() or manage() methods
    });

    test('FullStackDeveloper can implement multiple interfaces', () {
      // Arrange
      final fullStack = FullStackDeveloper();

      // Act & Assert - Can do everything
      expect(() => fullStack.code(), returnsNormally);
      expect(() => fullStack.design(), returnsNormally);
      expect(() => fullStack.work(), returnsNormally);
    });
  });

  group('Document Processing - Segregated Interfaces', () {
    test('Printer should only implement Printable', () {
      // Arrange
      final printer = Printer();

      // Act & Assert
      expect(() => printer.printDocument(), returnsNormally);
      // Printer does NOT have scan() or fax() methods
    });

    test('Scanner should only implement Scannable', () {
      // Arrange
      final scanner = Scanner();

      // Act & Assert
      expect(() => scanner.scanDocument(), returnsNormally);
      // Scanner does NOT have print() or fax() methods
    });

    test('FaxMachine should only implement Faxable', () {
      // Arrange
      final faxMachine = FaxMachine();

      // Act & Assert
      expect(() => faxMachine.faxDocument(), returnsNormally);
      // FaxMachine does NOT have print() or scan() methods
    });

    test('Photocopier can implement multiple interfaces', () {
      // Arrange
      final photocopier = Photocopier();

      // Act & Assert - Can do both
      expect(() => photocopier.printDocument(), returnsNormally);
      expect(() => photocopier.scanDocument(), returnsNormally);
    });

    test('MultiFunctionDevice implements all interfaces', () {
      // Arrange
      final mfd = MultiFunctionDevice();

      // Act & Assert - Can do everything
      expect(() => mfd.printDocument(), returnsNormally);
      expect(() => mfd.scanDocument(), returnsNormally);
      expect(() => mfd.faxDocument(), returnsNormally);
    });
  });

  group('Vehicle Interfaces - Segregated', () {
    test('Car should only implement Drivable', () {
      // Arrange
      final car = Car();

      // Act & Assert
      expect(() => car.drive(), returnsNormally);
      // Car does NOT have fly() or swim() methods
    });

    test('Airplane should only implement Flyable', () {
      // Arrange
      final airplane = Airplane();

      // Act & Assert
      expect(() => airplane.fly(), returnsNormally);
      // Airplane does NOT have drive() or swim() methods
    });

    test('Boat should only implement Swimmable', () {
      // Arrange
      final boat = Boat();

      // Act & Assert
      expect(() => boat.swim(), returnsNormally);
      // Boat does NOT have drive() or fly() methods
    });

    test('AmphibiousVehicle can implement multiple interfaces', () {
      // Arrange
      final amphibious = AmphibiousVehicle();

      // Act & Assert - Can do both
      expect(() => amphibious.drive(), returnsNormally);
      expect(() => amphibious.swim(), returnsNormally);
    });
  });
}

