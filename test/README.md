# Testing Guide - SOLID Principles

This directory contains comprehensive unit tests, integration tests, and TDD examples for all SOLID principles.

## Test Structure

```
test/
├── unit/                          # Unit tests for individual components
│   ├── single_responsibility_test.dart
│   ├── open_closed_test.dart
│   ├── liskov_substitution_test.dart
│   ├── interface_segregation_test.dart
│   └── dependency_inversion_test.dart
├── integration/                   # Integration tests for workflows
│   ├── e_commerce_integration_test.dart
│   └── pricing_integration_test.dart
└── tdd/                          # Test-Driven Development examples
    ├── tdd_example_test.dart
    ├── shopping_cart_implementation.dart
    └── shopping_cart_tdd_test.dart
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Unit Tests Only
```bash
flutter test test/unit/
```

### Run Integration Tests Only
```bash
flutter test test/integration/
```

### Run TDD Examples
```bash
flutter test test/tdd/
```

### Run Specific Test File
```bash
flutter test test/unit/single_responsibility_test.dart
```

### Run with Coverage
```bash
flutter test --coverage
```

## Test Types

### Unit Tests
Unit tests verify individual components in isolation:
- **Single Responsibility**: Tests each class has one responsibility
- **Open/Closed**: Tests new implementations can be added without modification
- **Liskov Substitution**: Tests subclasses are substitutable
- **Interface Segregation**: Tests classes only implement needed interfaces
- **Dependency Inversion**: Tests high-level modules depend on abstractions

### Integration Tests
Integration tests verify multiple components working together:
- **E-Commerce Integration**: Complete order processing workflow
- **Pricing Integration**: Discount, payment, and calculation integration

### TDD Examples
Test-Driven Development examples showing:
- **RED**: Write failing tests first
- **GREEN**: Implement minimal code to pass
- **REFACTOR**: Improve while keeping tests green

## Test Coverage

Current test coverage includes:
- ✅ All 5 SOLID principles
- ✅ Good examples for each principle
- ✅ Integration workflows
- ✅ TDD workflow demonstration
- ✅ 66+ unit tests
- ✅ Multiple integration scenarios

## Writing New Tests

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/[principle]/good_example.dart';

void main() {
  group('ComponentName - Description', () {
    late Component component;

    setUp(() {
      component = Component();
    });

    test('should do something', () {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### Integration Test Template
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Workflow Integration', () {
    test('should complete full workflow', () {
      // Arrange - Setup multiple components
      // Act - Execute workflow
      // Assert - Verify end-to-end behavior
    });
  });
}
```

## TDD Workflow

1. **RED**: Write a failing test
   ```dart
   test('should add item to cart', () {
     final cart = ShoppingCart();
     cart.addItem(item);
     expect(cart.getItemCount(), equals(1));
   });
   ```

2. **GREEN**: Write minimal code to pass
   ```dart
   class ShoppingCart {
     final List<CartItem> _items = [];
     void addItem(CartItem item) => _items.add(item);
     int getItemCount() => _items.length;
   }
   ```

3. **REFACTOR**: Improve while keeping tests green
   - Apply SOLID principles
   - Remove duplication
   - Improve readability

## Best Practices

1. **Test Isolation**: Each test should be independent
2. **Arrange-Act-Assert**: Follow AAA pattern
3. **Descriptive Names**: Test names should describe behavior
4. **One Assertion**: Focus on one behavior per test
5. **SOLID Principles**: Apply SOLID in test code too
6. **Mock External Dependencies**: Use abstractions for testing

## Continuous Integration

Tests are designed to run in CI/CD pipelines:
- Fast execution (< 5 seconds)
- No external dependencies
- Deterministic results
- Clear failure messages

## Contributing

When adding new examples:
1. Write tests first (TDD)
2. Ensure all tests pass
3. Maintain test coverage
4. Follow existing test patterns
5. Document complex test scenarios

