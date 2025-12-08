# SOLID Principles Practice Exercises

This folder contains practice exercises for each SOLID principle. Each exercise file contains code that violates the principle and needs to be refactored.

## 📚 Definitions

For comprehensive definitions of all SOLID principles, see:
- **`definitions.dart`** - Complete definitions, concepts, examples, and best practices for all 5 principles

## Structure

```
exercises/
├── single_responsibility/
│   ├── easy_example.dart      # Easy level exercise
│   ├── mid_example.dart        # Medium level exercise
│   └── hard_example.dart       # Hard level exercise
├── open_closed/
│   ├── easy_example.dart
│   ├── mid_example.dart
│   └── hard_example.dart
├── liskov_substitution/
│   ├── easy_example.dart
│   ├── mid_example.dart
│   └── hard_example.dart
├── interface_segregation/
│   ├── easy_example.dart
│   ├── mid_example.dart
│   └── hard_example.dart
├── dependency_inversion/
│   ├── easy_example.dart
│   ├── mid_example.dart
│   └── hard_example.dart
└── combined/
    ├── easy_example.dart       # Multiple principles (SRP + DIP)
    ├── mid_example.dart        # Multiple principles (SRP + OCP + DIP)
    ├── hard_example.dart       # Multiple principles (SRP + OCP + LSP + ISP + DIP)
    └── advanced_example.dart   # All 5 principles combined
```

## How to Use

1. **Read Definitions**: Start by reading `definitions.dart` to understand each principle
2. **Start with Easy**: Begin with the easy examples to understand the basic concept
3. **Progress to Mid**: Move to medium difficulty when comfortable with easy examples
4. **Challenge with Hard**: Tackle hard examples to master the principle
5. **Try Combined**: Practice applying multiple principles together

## Exercise Guidelines

### Single Responsibility Principle (SRP)
- **Easy**: Split user management and email operations
- **Mid**: Separate order processing, payment, inventory, and notifications
- **Hard**: Refactor authentication system with multiple responsibilities

### Open/Closed Principle (OCP)
- **Easy**: Make shape calculator extensible without modification
- **Mid**: Create extensible discount system
- **Hard**: Build flexible report generator with multiple extension points

### Liskov Substitution Principle (LSP)
- **Easy**: Fix bird hierarchy where penguins can't fly
- **Mid**: Refactor file system with read-only files
- **Hard**: Fix collection hierarchy with immutable and bounded lists

### Interface Segregation Principle (ISP)
- **Easy**: Split worker interface for humans and robots
- **Mid**: Separate audio and video player interfaces
- **Hard**: Refactor database connection interface for different connection types

### Dependency Inversion Principle (DIP)
- **Easy**: Inject logger and email service abstractions
- **Mid**: Create payment gateway abstraction
- **Hard**: Refactor e-commerce service with multiple dependencies

### Combined Principles
- **Easy**: Apply SRP + DIP together (UserManager with email service)
- **Mid**: Apply SRP + OCP + DIP (OrderProcessor with extensible payments)
- **Hard**: Apply all principles (UserManagementSystem with multiple violations)
- **Advanced**: Complete e-commerce system violating all 5 principles

## Refactoring Tips

1. **Read the code carefully**: Understand what the code is trying to do
2. **Identify violations**: Find where the SOLID principle is being violated
3. **Design abstractions**: Create interfaces/abstract classes where needed
4. **Apply the principle**: Refactor to follow the principle
5. **Test your solution**: Make sure the refactored code works correctly
6. **Compare with good examples**: Check `lib/principles/[principle]/good_example.dart` for reference

## Single Responsibility in Practice

Each exercise file follows single responsibility:
- One file = One exercise
- One class = One responsibility (after refactoring)
- Clear separation of concerns

## Next Steps

After completing an exercise:
1. Create your solution in a new file (e.g., `easy_example_solution.dart`)
2. Compare with the good examples in `lib/principles/`
3. Write tests to verify your solution
4. Move to the next difficulty level

Happy coding! 🚀
