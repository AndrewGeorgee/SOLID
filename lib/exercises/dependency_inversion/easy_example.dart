/// EXERCISE: Easy - Dependency Inversion Principle
///
/// TASK: Refactor this code to follow Dependency Inversion Principle.
/// Currently, OrderService directly depends on concrete implementations
/// (FileLogger and EmailService) instead of abstractions.
///
/// HINT: Create abstract interfaces for Logger and NotificationService,
/// then inject them into OrderService through constructor.

class FileLogger {
  void log(String message) {
    print('FILE LOG: $message');
    // File logging logic...
  }
}

class EmailService {
  void sendEmail(String to, String subject, String body) {
    print('Sending email to $to: $subject');
    // Email sending logic...
  }
}

/// OrderService directly depends on concrete classes (violates DIP)
class OrderService {
  final FileLogger _logger =
      FileLogger(); // Direct dependency on concrete class
  final EmailService _emailService =
      EmailService(); // Direct dependency on concrete class

  void processOrder(String orderId, String customerEmail) {
    _logger.log('Processing order: $orderId');

    // Order processing logic...

    _emailService.sendEmail(
      customerEmail,
      'Order Confirmation',
      'Your order $orderId has been processed.',
    );

    _logger.log('Order processed: $orderId');
  }
}

/// SOLUTION: Easy - Dependency Inversion Principle

//! High-Level modules (abstract classes/interfaces)
abstract class Logger {
  void log(String message);
}

abstract class NotificationService {
  void sendEmailNotification(String to, String subject, String body);
}

//! Low-Level modules (concrete implementations)
class FileLoggerV2 implements Logger {
  @override
  void log(String message) {
    print('FILE LOG: $message');
  }
}

class EmailServiceV2 implements NotificationService {
  @override
  void sendEmailNotification(String to, String subject, String body) {
    print('Sending email to $to: $subject');
    // Email sending logic...
  }
}

//! High-Level module depends on abstractions (DIP)
class OrderServiceV2 {
  final Logger _logger;
  final NotificationService _notificationService;

  OrderServiceV2({
    required Logger logger,
    required NotificationService notificationService,
  }) : _logger = logger,
       _notificationService = notificationService;

  void processOrder(String orderId, String customerEmail) {
    _logger.log('Processing order: $orderId');

    // Order processing logic...

    _notificationService.sendEmailNotification(
      customerEmail,
      'Order Confirmation',
      'Your order $orderId has been processed.',
    );

    _logger.log('Order processed: $orderId');
  }
}
