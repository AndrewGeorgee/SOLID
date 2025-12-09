/// ============================================================================
/// SOLID PRINCIPLES - COMPREHENSIVE DEFINITIONS
/// ============================================================================
///
/// SOLID is an acronym for five object-oriented design principles that make
/// software designs more understandable, flexible, and maintainable.
///
/// ============================================================================

/// ============================================================================
/// S - SINGLE RESPONSIBILITY PRINCIPLE (SRP)
/// ============================================================================
///
/// DEFINITION:
/// A class should have only one reason to change, meaning it should have only
/// one job or responsibility. Each class should be focused on doing one thing well.
///
/// KEY CONCEPTS:
/// - One class = One responsibility
/// - One reason to change
/// - Separation of concerns
/// - High cohesion (related functionality grouped together)
///
/// VIOLATION SIGNS:
/// - Class has multiple reasons to change
/// - Class handles multiple unrelated tasks
/// - Class is too large or complex
/// - Methods in class serve different purposes
///
/// HOW TO APPLY:
/// 1. Identify all responsibilities in a class
/// 2. Split into separate classes, each with one responsibility
/// 3. Use composition to combine classes when needed
/// 4. Keep classes focused and cohesive
///
/// BENEFITS:
/// - Easier to maintain and modify
/// - Better testability (test one thing at a time)
/// - Reduced coupling between classes
/// - Clearer code organization
/// - Easier to understand and document
///
/// EXAMPLE:
/// ❌ BAD: UserManager handles user data, email sending, and database operations
/// ✅ GOOD: UserRepository (data), EmailService (emails), UserManager (orchestration)
///
/// ============================================================================

/// ============================================================================
/// O - OPEN/CLOSED PRINCIPLE (OCP)
/// ============================================================================
///
/// DEFINITION:
/// Software entities (classes, modules, functions, etc.) should be open for
/// extension but closed for modification. This means you should be able to add
/// new functionality without changing existing code.
///
/// KEY CONCEPTS:
/// - Open for extension: New behavior can be added
/// - Closed for modification: Existing code should not be changed
/// - Use abstraction (interfaces/abstract classes)
/// - Strategy pattern, Template method pattern
///
/// VIOLATION SIGNS:
/// - Adding new features requires modifying existing code
/// - Switch/if-else statements for type checking
/// - Hard-coded behavior that can't be extended
/// - Changes to one feature affect others
///
/// HOW TO APPLY:
/// 1. Identify areas that need to be extended
/// 2. Create abstractions (interfaces/abstract classes)
/// 3. Use polymorphism and strategy pattern
/// 4. Inject behaviors rather than hard-coding them
/// 5. Use composition over modification
///
/// BENEFITS:
/// - Reduces risk of breaking existing functionality
/// - Makes code more maintainable
/// - Encourages use of interfaces and abstractions
/// - Easier to add new features
/// - Better code reusability
///
/// EXAMPLE:
/// ❌ BAD: switch statement for different discount types
/// ✅ GOOD: DiscountStrategy interface with concrete implementations
///
/// ============================================================================

/// ============================================================================
/// L - LISKOV SUBSTITUTION PRINCIPLE (LSP)
/// ============================================================================
///
/// DEFINITION:
/// Objects of a superclass should be replaceable with objects of its subclasses
/// without breaking the application. Derived classes must be substitutable for
/// their base classes without altering the correctness of the program.
///
/// KEY CONCEPTS:
/// - Subtypes must be substitutable for their base types
/// - Subclasses should not weaken postconditions
/// - Subclasses should not strengthen preconditions
/// - Subclasses should preserve all invariants
/// - "Is-a" relationship must be true in behavior, not just syntax
///
/// VIOLATION SIGNS:
/// - Subclass throws exceptions for base class methods
/// - Subclass changes expected behavior
/// - Subclass has additional constraints that base class doesn't
/// - Code that works with base class breaks with subclass
/// - Subclass returns null/empty when base class doesn't
///
/// HOW TO APPLY:
/// 1. Ensure subclasses can replace base classes without issues
/// 2. Don't override methods to do nothing or throw exceptions
/// 3. Maintain contracts (preconditions, postconditions, invariants)
/// 4. Use composition when inheritance doesn't fit
/// 5. Design by contract - honor the base class contract
///
/// BENEFITS:
/// - Ensures proper inheritance hierarchy
/// - Prevents unexpected behavior when substituting classes
/// - Makes code more reliable and predictable
/// - Enables polymorphism to work correctly
/// - Better design decisions
///
/// EXAMPLE:
/// ❌ BAD: Square extends Rectangle but changes setWidth/setHeight behavior
/// ✅ GOOD: Shape interface with Rectangle and Square as separate implementations
///
/// ============================================================================

/// ============================================================================
/// I - INTERFACE SEGREGATION PRINCIPLE (ISP)
/// ============================================================================
///
/// DEFINITION:
/// Clients should not be forced to depend on interfaces they do not use.
/// Instead of one fat interface, many small, specific interfaces are preferred.
///
/// KEY CONCEPTS:
/// - No client should depend on unused methods
/// - Split large interfaces into smaller, specific ones
/// - Classes should only implement what they need
/// - Prefer composition of multiple interfaces
/// - "Many client-specific interfaces are better than one general-purpose interface"
///
/// VIOLATION SIGNS:
/// - Classes implementing empty methods or throwing exceptions
/// - Large interfaces with many methods
/// - Classes forced to implement methods they don't use
/// - Interface has methods for different concerns
/// - Clients depend on methods they never call
///
/// HOW TO APPLY:
/// 1. Identify groups of methods used together
/// 2. Split large interfaces into smaller, focused ones
/// 3. Create interfaces for specific roles/capabilities
/// 4. Use interface composition when needed
/// 5. Keep interfaces minimal and focused
///
/// BENEFITS:
/// - Reduces coupling between classes
/// - Makes interfaces more focused and easier to understand
/// - Prevents classes from implementing unnecessary methods
/// - Improves code maintainability and flexibility
/// - Better separation of concerns
///
/// EXAMPLE:
/// ❌ BAD: Worker interface with work(), eat(), sleep() - Robot forced to implement eat/sleep
/// ✅ GOOD: Workable, Eatable, Sleepable interfaces - classes implement only what they need
///
/// ============================================================================

/// ============================================================================
/// D - DEPENDENCY INVERSION PRINCIPLE (DIP)
/// ============================================================================
///
/// DEFINITION:
/// High-level modules should not depend on low-level modules. Both should
/// depend on abstractions. Abstractions should not depend on details.
/// Details should depend on abstractions.
///
/// KEY CONCEPTS:
/// - Depend on abstractions, not concrete classes
/// - High-level modules define business logic
/// - Low-level modules implement details
/// - Both depend on abstractions, not each other
/// - Dependency injection and inversion of control
///
/// VIOLATION SIGNS:
/// - Direct instantiation of concrete classes
/// - High-level modules import low-level modules
/// - Hard to test (can't mock dependencies)
/// - Tight coupling between modules
/// - Changes in low-level affect high-level
///
/// HOW TO APPLY:
/// 1. Create abstractions (interfaces) for dependencies
/// 2. Inject dependencies through constructor/methods
/// 3. High-level modules depend on abstractions
/// 4. Low-level modules implement abstractions
/// 5. Use dependency injection framework if needed
///
/// BENEFITS:
/// - Reduces coupling between modules
/// - Makes code more flexible and testable
/// - Enables easy swapping of implementations
/// - Facilitates dependency injection
/// - Improves maintainability
/// - Better separation of concerns
///
/// EXAMPLE:
/// ❌ BAD: OrderService directly creates FileLogger and EmailService
/// ✅ GOOD: OrderService receives ILogger and IEmailService through constructor
///
/// ============================================================================

/// ============================================================================
/// SOLID PRINCIPLES - RELATIONSHIPS
/// ============================================================================
///
/// HOW THEY WORK TOGETHER:
///
/// 1. SRP provides the foundation - each class has one responsibility
/// 2. OCP builds on SRP - use abstractions to extend without modification
/// 3. LSP ensures inheritance works correctly with OCP
/// 4. ISP refines interfaces created for OCP - keep them focused
/// 5. DIP ties it all together - depend on abstractions, not concretions
///
/// COMMON PATTERNS:
/// - Strategy Pattern: OCP + DIP (extensible behaviors via interfaces)
/// - Factory Pattern: DIP (create objects through abstractions)
/// - Adapter Pattern: ISP (adapt interfaces to client needs)
/// - Template Method: OCP (extend behavior via inheritance)
///
/// BEST PRACTICES:
/// 1. Start with SRP - identify responsibilities
/// 2. Apply OCP - make it extensible via abstractions
/// 3. Ensure LSP - verify inheritance is correct
/// 4. Apply ISP - split interfaces if needed
/// 5. Apply DIP - inject dependencies
///
/// ============================================================================

/// ============================================================================
/// QUICK REFERENCE GUIDE
/// ============================================================================
///
/// SRP: "One class, one responsibility"
/// OCP: "Open for extension, closed for modification"
/// LSP: "Subtypes must be substitutable for their base types"
/// ISP: "Many specific interfaces better than one general interface"
/// DIP: "Depend on abstractions, not concretions"
///
/// ============================================================================
