import 'package:flutter/material.dart';

class PrincipleDetailScreen extends StatefulWidget {
  final String principlePath;
  final String principleName;
  final String principleLetter;
  final Color principleColor;

  const PrincipleDetailScreen({
    super.key,
    required this.principlePath,
    required this.principleName,
    required this.principleLetter,
    required this.principleColor,
  });

  @override
  State<PrincipleDetailScreen> createState() => _PrincipleDetailScreenState();
}

class _PrincipleDetailScreenState extends State<PrincipleDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: widget.principleColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.principleLetter,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.principleColor,
                      widget.principleColor.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        widget.principleName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: widget.principleColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: widget.principleColor,
                  tabs: const [
                    Tab(text: 'Definition'),
                    Tab(text: 'Bad Example'),
                    Tab(text: 'Good Example'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 300,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDefinitionTab(),
                      _buildBadExampleTab(),
                      _buildGoodExampleTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefinitionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildContentSection(
        title: 'Definition',
        content: _getDefinitionContent(),
        icon: Icons.info_outline,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildBadExampleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildContentSection(
        title: 'Bad Example',
        content: _getBadExampleContent(),
        icon: Icons.error_outline,
        color: Colors.red,
      ),
    );
  }

  Widget _buildGoodExampleTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: _buildContentSection(
        title: 'Good Example',
        content: _getGoodExampleContent(),
        icon: Icons.check_circle_outline,
        color: Colors.green,
      ),
    );
  }

  Widget _buildContentSection({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  String _getDefinitionContent() {
    switch (widget.principlePath) {
      case 'single_responsibility':
        return '''
SINGLE RESPONSIBILITY PRINCIPLE (SRP)

Definition:
A class should have only one reason to change, meaning it should have only one job or responsibility. Each class should be focused on doing one thing well.

Key Points:
• Each class should have a single, well-defined purpose
• Changes to one aspect of functionality should not affect unrelated features
• Makes code more maintainable, testable, and easier to understand

Benefits:
• Easier to maintain and modify
• Better testability
• Reduced coupling between classes
• Clearer code organization
''';
      case 'open_closed':
        return '''
OPEN/CLOSED PRINCIPLE (OCP)

Definition:
Software entities (classes, modules, functions, etc.) should be open for extension but closed for modification. This means you should be able to add new functionality without changing existing code.

Key Points:
• Open for extension: New behavior can be added
• Closed for modification: Existing code should not be changed
• Use abstraction (interfaces/abstract classes) to achieve this
• Prefer composition and polymorphism over modification

Benefits:
• Reduces risk of breaking existing functionality
• Makes code more maintainable
• Encourages use of interfaces and abstractions
• Easier to add new features
''';
      case 'liskov_substitution':
        return '''
LISKOV SUBSTITUTION PRINCIPLE (LSP)

Definition:
Objects of a superclass should be replaceable with objects of its subclasses without breaking the application. Derived classes must be substitutable for their base classes without altering the correctness of the program.

Key Points:
• Subtypes must be substitutable for their base types
• Subclasses should not weaken the postconditions of the base class
• Subclasses should not strengthen the preconditions of the base class
• Subclasses should preserve all invariants of the base class

Benefits:
• Ensures proper inheritance hierarchy
• Prevents unexpected behavior when substituting classes
• Makes code more reliable and predictable
• Enables polymorphism to work correctly
''';
      case 'interface_segregation':
        return '''
INTERFACE SEGREGATION PRINCIPLE (ISP)

Definition:
Clients should not be forced to depend on interfaces they do not use. Instead of one fat interface, many small, specific interfaces are preferred.

Key Points:
• No client should be forced to depend on methods it doesn't use
• Split large interfaces into smaller, more specific ones
• Classes should only implement interfaces they actually need
• Prefer composition of multiple interfaces over one large interface

Benefits:
• Reduces coupling between classes
• Makes interfaces more focused and easier to understand
• Prevents classes from implementing unnecessary methods
• Improves code maintainability and flexibility
''';
      case 'dependency_inversion':
        return '''
DEPENDENCY INVERSION PRINCIPLE (DIP)

Definition:
High-level modules should not depend on low-level modules. Both should depend on abstractions. Abstractions should not depend on details. Details should depend on abstractions.

Key Points:
• Depend on abstractions (interfaces/abstract classes), not concrete classes
• High-level modules define the business logic
• Low-level modules implement the details
• Both depend on abstractions, not each other
• Enables dependency injection and inversion of control

Benefits:
• Reduces coupling between modules
• Makes code more flexible and testable
• Enables easy swapping of implementations
• Facilitates dependency injection
• Improves maintainability
''';
      default:
        return 'Definition not available';
    }
  }

  String _getBadExampleContent() {
    switch (widget.principlePath) {
      case 'single_responsibility':
        return '''
BAD EXAMPLE: Violates Single Responsibility Principle

The UserManager class has multiple responsibilities:
1. User data management
2. Email validation
3. Email sending
4. Database operations
5. Report generation

If any of these change, this class needs to be modified, violating SRP.

See the bad_example.dart file for the complete code example showing a class that handles too many responsibilities.
''';
      case 'open_closed':
        return '''
BAD EXAMPLE: Violates Open/Closed Principle

The PriceCalculator class uses a switch statement to handle different discount types. To add a new discount type, you must modify the existing class, violating the "closed for modification" part of OCP.

See the bad_example.dart file for the complete code example showing classes that require modification to extend functionality.
''';
      case 'liskov_substitution':
        return '''
BAD EXAMPLE: Violates Liskov Substitution Principle

The Square class extends Rectangle but changes the behavior of setWidth and setHeight methods. A function expecting Rectangle won't work correctly with Square, violating LSP.

Also, Penguin extends Bird but cannot fly, breaking the expected behavior when substituted for Bird.

See the bad_example.dart file for the complete code examples showing improper inheritance.
''';
      case 'interface_segregation':
        return '''
BAD EXAMPLE: Violates Interface Segregation Principle

A single fat Worker interface forces all implementers (Developer, Manager, Designer) to provide methods they may not need or cannot implement. This forces empty implementations or throwing exceptions.

See the bad_example.dart file for the complete code example showing a fat interface that forces unnecessary method implementations.
''';
      case 'dependency_inversion':
        return '''
BAD EXAMPLE: Violates Dependency Inversion Principle

High-level modules (UserService, OrderService) depend directly on low-level concrete implementations (MySQLDatabase, EmailService). This creates tight coupling and makes testing and changes difficult.

See the bad_example.dart file for the complete code examples showing direct dependencies on concrete classes.
''';
      default:
        return 'Bad example not available';
    }
  }

  String _getGoodExampleContent() {
    switch (widget.principlePath) {
      case 'single_responsibility':
        return '''
GOOD EXAMPLE: Follows Single Responsibility Principle

Each class has a single, well-defined responsibility:
• UserRepository: Only handles data storage/retrieval
• EmailValidator: Only validates email format
• EmailService: Only sends emails
• ReportGenerator: Only generates reports

Real-world example includes OrderRepository, PaymentProcessor, InventoryManager, and NotificationService - each with a single responsibility.

COMPLEX EXAMPLE:
See complex_example.dart for an enterprise e-commerce system with:
• Data Layer (IUserRepository, IOrderRepository)
• Validation Layer (IValidator with EmailValidator, PasswordValidator, OrderValidator)
• Notification Layer (INotificationService with Email/SMS implementations)
• Logging Layer (ILogger with ConsoleLogger)
• Calculation Layer (IPriceCalculator)
• Reporting Layer (IReportGenerator)
• Caching Layer (ICacheService)

Each component has a single, focused responsibility, making the system maintainable and testable.

See the good_example.dart and complex_example.dart files for complete code examples.
''';
      case 'open_closed':
        return '''
GOOD EXAMPLE: Follows Open/Closed Principle

Using abstraction (interfaces) to allow extension without modification:
• DiscountStrategy interface with concrete implementations
• New discount types can be added by implementing the interface
• PriceCalculator is closed for modification but open for extension

Real-world examples include PaymentProcessor abstraction and Shape hierarchy, allowing new implementations without modifying existing code.

COMPLEX EXAMPLE:
See complex_example.dart for an advanced pricing system with:
• Multiple discount strategies (Student, Senior, VIP, Bulk, Seasonal, Cart Total, Composite)
• Tax calculators (Standard, Regional, Category-based, Progressive)
• Shipping calculators (Standard, Express, International)
• AdvancedPriceCalculator that combines all strategies

New discount types, tax rules, or shipping methods can be added without modifying existing code.

See the good_example.dart and complex_example.dart files for complete code examples.
''';
      case 'liskov_substitution':
        return '''
GOOD EXAMPLE: Follows Liskov Substitution Principle

All subclasses can be substituted for their base classes without breaking functionality:
• Shape interface with Rectangle, Square, and Circle implementations
• All shapes are properly substitutable
• PaymentMethod interface with multiple payment implementations
• Proper bird hierarchy separating FlyingBird and NonFlyingBird

COMPLEX EXAMPLE:
See complex_example.dart for a complete banking system with:
• IAccount interface with BaseAccount implementation
• Multiple account types (CheckingAccount, SavingsAccount, BusinessAccount, InvestmentAccount)
• All accounts are fully substitutable - AccountService works with any IAccount
• Complex operations: deposits, withdrawals, transfers, transaction history
• Account search and reporting that works with any account type

All account types maintain the contract and can be used interchangeably.

See the good_example.dart and complex_example.dart files for complete code examples.
''';
      case 'interface_segregation':
        return '''
GOOD EXAMPLE: Follows Interface Segregation Principle

Interfaces are segregated into small, focused interfaces:
• Human, Workable, Codeable, Manageable, Designable interfaces
• Classes only implement the interfaces they actually need
• Developer implements Human, Workable, Codeable
• Manager implements Human, Workable, Manageable
• Designer implements Human, Workable, Designable

Real-world examples include document processing (Printable, Scannable, Faxable) and vehicle interfaces.

COMPLEX EXAMPLE:
See complex_example.dart for a multi-media processing system with:
• Segregated interfaces: IReadableMedia, IWritableMedia, IEditableMedia, ICompressibleMedia, IConvertibleMedia, IPublishableMedia, IStreamableMedia, IShareableMedia
• TextFile implements only Readable/Writable
• ImageFile implements Readable, Writable, Editable, Compressible, Convertible
• VideoFile implements Readable, Editable, Compressible, Convertible, Publishable, Streamable
• SocialMediaPost implements Publishable, Shareable
• Specialized services (ImageProcessingService, PublishingService, StreamingService) work only with needed interfaces

See the good_example.dart and complex_example.dart files for complete code examples.
''';
      case 'dependency_inversion':
        return '''
GOOD EXAMPLE: Follows Dependency Inversion Principle

High-level modules depend on abstractions, not concrete implementations:
• UserRepository and NotificationService abstractions
• UserService depends on abstractions via dependency injection
• PaymentProcessor abstraction with multiple implementations
• DataStorage abstraction with FileStorage, CloudStorage, CacheStorage

COMPLEX EXAMPLE:
See complex_example.dart for an enterprise e-commerce platform with:
• Multiple abstractions: IRepository, ICacheService, ILogger, IPaymentGateway, INotificationService, IInventoryService, IShippingCalculator, IAnalyticsService
• Multiple implementations: MySQLRepository, PostgreSQLRepository, RedisCacheService, StripePaymentGateway, PayPalPaymentGateway
• OrderService (high-level) depends on all abstractions, not concrete classes
• Easy to swap implementations (MySQL to PostgreSQL, Stripe to PayPal)
• Testable with mock implementations
• Supports dependency injection for flexible configuration

See the good_example.dart and complex_example.dart files for complete code examples.
''';
      default:
        return 'Good example not available';
    }
  }
}

