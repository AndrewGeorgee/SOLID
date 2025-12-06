# SOLID Principles - Flutter Implementation

A comprehensive Flutter application demonstrating all five SOLID principles with definitions, bad examples, and good examples.

## 📚 Overview

This project provides a complete implementation and explanation of the SOLID principles:

- **S** - Single Responsibility Principle
- **O** - Open/Closed Principle
- **L** - Liskov Substitution Principle
- **I** - Interface Segregation Principle
- **D** - Dependency Inversion Principle

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Main app entry point
├── models/                            # Data models
│   ├── user.dart
│   └── product.dart
├── principles/                        # SOLID principles implementation
│   ├── single_responsibility/
│   │   ├── definition.dart
│   │   ├── bad_example.dart
│   │   └── good_example.dart
│   ├── open_closed/
│   │   ├── definition.dart
│   │   ├── bad_example.dart
│   │   └── good_example.dart
│   ├── liskov_substitution/
│   │   ├── definition.dart
│   │   ├── bad_example.dart
│   │   └── good_example.dart
│   ├── interface_segregation/
│   │   ├── definition.dart
│   │   ├── bad_example.dart
│   │   └── good_example.dart
│   └── dependency_inversion/
│       ├── definition.dart
│       ├── bad_example.dart
│       └── good_example.dart
└── screens/                           # UI screens
    ├── home_screen.dart               # Main navigation screen
    └── principle_detail_screen.dart  # Detailed view for each principle
```

## 🎯 SOLID Principles

### 1. Single Responsibility Principle (SRP)

**Definition:** A class should have only one reason to change, meaning it should have only one job or responsibility.

**Examples:**
- Bad: `UserManager` class handling data, validation, email, database, and reports
- Good: Separate classes: `UserRepository`, `EmailValidator`, `EmailService`, `ReportGenerator`

**Real-world examples:**
- E-commerce order processing with separate `OrderRepository`, `PaymentProcessor`, `InventoryManager`, and `NotificationService`

### 2. Open/Closed Principle (OCP)

**Definition:** Software entities should be open for extension but closed for modification.

**Examples:**
- Bad: `PriceCalculator` with switch statements requiring modification for new discount types
- Good: `DiscountStrategy` interface allowing new discount types without modifying existing code

**Real-world examples:**
- Payment processing with `PaymentProcessor` abstraction
- Shape hierarchy with `Shape` interface

### 3. Liskov Substitution Principle (LSP)

**Definition:** Objects of a superclass should be replaceable with objects of its subclasses without breaking the application.

**Examples:**
- Bad: `Square` extending `Rectangle` but changing behavior, `Penguin` extending `Bird` but cannot fly
- Good: Proper `Shape` hierarchy, `PaymentMethod` interface with substitutable implementations

**Real-world examples:**
- Payment methods: `CreditCardPayment`, `DebitCardPayment`, `PayPalPayment`
- Bird hierarchy: `FlyingBird` and `NonFlyingBird` abstractions

### 4. Interface Segregation Principle (ISP)

**Definition:** Clients should not be forced to depend on interfaces they do not use.

**Examples:**
- Bad: Fat `Worker` interface forcing all workers to implement all methods
- Good: Segregated interfaces: `Human`, `Workable`, `Codeable`, `Manageable`, `Designable`

**Real-world examples:**
- Document processing: `Printable`, `Scannable`, `Faxable`
- Vehicle interfaces: `Drivable`, `Flyable`, `Swimmable`

### 5. Dependency Inversion Principle (DIP)

**Definition:** High-level modules should not depend on low-level modules. Both should depend on abstractions.

**Examples:**
- Bad: `UserService` directly depending on `MySQLDatabase` and `EmailService`
- Good: `UserService` depending on `UserRepository` and `NotificationService` abstractions

**Real-world examples:**
- Payment processing with `PaymentProcessor` abstraction
- Data storage with `DataStorage` abstraction (File, Cloud, Cache)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.10.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd solid
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## 📱 Features

- **Interactive UI**: Beautiful, modern Flutter UI with Material Design 3
- **Comprehensive Examples**: Each principle includes:
  - Clear definition and explanation
  - Bad example showing violations
  - Good example showing proper implementation
  - Real-world examples
- **Easy Navigation**: Browse through all five principles with intuitive navigation
- **Code Examples**: Complete, runnable code examples for each principle

## 🎨 UI Features

- Gradient backgrounds
- Color-coded principles
- Tabbed interface for Definition/Bad Example/Good Example
- Responsive design
- Material Design 3 components

## 📖 Usage

1. Launch the app
2. Browse the home screen to see all five SOLID principles
3. Tap on any principle to view details
4. Navigate through tabs to see:
   - **Definition**: Explanation of the principle
   - **Bad Example**: Code that violates the principle
   - **Good Example**: Code that follows the principle

## 🔍 Code Examples

All code examples are located in the `lib/principles/` directory. Each principle has:
- `definition.dart`: Explanation and key points
- `bad_example.dart`: Violations of the principle
- `good_example.dart`: Proper implementation

## 🧪 Testing

To run tests:
```bash
flutter test
```

## 📝 Notes

- All examples are written in Dart/Flutter
- Code follows Flutter best practices
- Examples are designed to be educational and easy to understand
- Real-world examples demonstrate practical applications

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is open source and available for educational purposes.

## 🙏 Acknowledgments

- SOLID principles by Robert C. Martin (Uncle Bob)
- Flutter team for the amazing framework
# SOLID
