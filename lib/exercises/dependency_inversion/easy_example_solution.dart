/// SOLUTION: Easy - Dependency Inversion Principle
///
/// This solution demonstrates how to apply the Dependency Inversion Principle
/// by depending on abstractions instead of concrete implementations.

/// ============================================================================
/// STEP 1: Create abstractions (interfaces)
/// ============================================================================

/// Abstract interface for logging functionality
abstract class Logger {
  void log(String message);
}

/// Abstract interface for email/notification functionality
abstract class NotificationService {
  void sendEmail(String to, String subject, String body);
}

/// ============================================================================
/// STEP 2: Implement the abstractions with concrete classes
/// ============================================================================

/// Concrete implementation of Logger - writes to file
class FileLogger implements Logger {
  @override
  void log(String message) {
    print('FILE LOG: $message');
    // File logging logic...
  }
}

/// Alternative implementation - writes to console
class ConsoleLogger implements Logger {
  @override
  void log(String message) {
    print('CONSOLE LOG: $message');
  }
}

/// Alternative implementation - writes to database
class DatabaseLogger implements Logger {
  @override
  void log(String message) {
    print('DATABASE LOG: $message');
    // Database logging logic...
  }
}

/// Concrete implementation of NotificationService - sends email
class EmailService implements NotificationService {
  @override
  void sendEmail(String to, String subject, String body) {
    print('Sending email to $to: $subject');
    // Email sending logic...
  }
}

/// Alternative implementation - sends SMS
class SMSService implements NotificationService {
  @override
  void sendEmail(String to, String subject, String body) {
    print('Sending SMS to $to: $subject');
    // SMS sending logic...
  }
}

/// Alternative implementation - sends push notification
class PushNotificationService implements NotificationService {
  @override
  void sendEmail(String to, String subject, String body) {
    print('Sending push notification to $to: $subject');
    // Push notification logic...
  }
}

/// ============================================================================
/// STEP 3: Refactor OrderService to depend on abstractions
/// ============================================================================

/// OrderService now depends on abstractions (Logger and NotificationService)
/// instead of concrete implementations. This follows the Dependency Inversion Principle.
class OrderService {
  // Depend on abstractions, not concrete classes
  final Logger _logger;
  final NotificationService _notificationService;

  /// Constructor injection - dependencies are injected from outside
  /// This makes the class flexible and testable
  OrderService({
    required Logger logger,
    required NotificationService notificationService,
  }) : _logger = logger,
       _notificationService = notificationService;

  void processOrder(String orderId, String customerEmail) {
    _logger.log('Processing order: $orderId');

    // Order processing logic...

    _notificationService.sendEmail(
      customerEmail,
      'Order Confirmation',
      'Your order $orderId has been processed.',
    );

    _logger.log('Order processed: $orderId');
  }
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void exampleUsage() {
  // Example 1: Use FileLogger and EmailService (original behavior)
  final orderService1 = OrderService(
    logger: FileLogger(),
    notificationService: EmailService(),
  );
  orderService1.processOrder('ORD-001', 'customer@example.com');

  // Example 2: Use ConsoleLogger and EmailService
  final orderService2 = OrderService(
    logger: ConsoleLogger(),
    notificationService: EmailService(),
  );
  orderService2.processOrder('ORD-002', 'customer@example.com');

  // Example 3: Use FileLogger and SMSService
  final orderService3 = OrderService(
    logger: FileLogger(),
    notificationService: SMSService(),
  );
  orderService3.processOrder('ORD-003', 'customer@example.com');

  // Example 4: Use DatabaseLogger and PushNotificationService
  final orderService4 = OrderService(
    logger: DatabaseLogger(),
    notificationService: PushNotificationService(),
  );
  orderService4.processOrder('ORD-004', 'customer@example.com');
}

/// ============================================================================
/// BENEFITS OF THIS SOLUTION
/// ============================================================================
///
/// 1. **Flexibility**: Easy to swap implementations without changing OrderService
/// 2. **Testability**: Can inject mock implementations for testing
/// 3. **Extensibility**: Can add new logger/notification types without modifying OrderService
/// 4. **Loose Coupling**: OrderService doesn't know about concrete implementations
/// 5. **Open/Closed Principle**: Open for extension (new implementations), closed for modification
///
/// ============================================================================
