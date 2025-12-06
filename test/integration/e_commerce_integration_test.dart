import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/single_responsibility/good_example.dart';
import '../../lib/models/user.dart';
import '../../lib/models/order.dart';

/// INTEGRATION TESTS: E-Commerce System
/// 
/// Tests the integration of multiple components working together
/// to process a complete order workflow.

void main() {
  group('E-Commerce Order Processing Integration', () {
    late UserRepository userRepository;
    late OrderRepository orderRepository;
    late PaymentProcessor paymentProcessor;
    late InventoryManager inventoryManager;
    late NotificationService notificationService;

    setUp(() {
      userRepository = UserRepository();
      orderRepository = OrderRepository();
      paymentProcessor = PaymentProcessor();
      inventoryManager = InventoryManager();
      notificationService = NotificationService();
    });

    test('should process complete order workflow', () {
      // Arrange - Setup initial state
      final user = User(
        id: 'user1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 500.0,
      );
      userRepository.addUser(user);

      inventoryManager.updateStock('product1', 10);
      inventoryManager.updateStock('product2', 5);

      // Act - Process order
      // 1. Check inventory
      final product1Available = inventoryManager.checkAvailability('product1', 2);
      final product2Available = inventoryManager.checkAvailability('product2', 1);

      expect(product1Available, isTrue);
      expect(product2Available, isTrue);

      // 2. Process payment
      final paymentSuccess = paymentProcessor.processPayment(150.0, 'credit_card');
      expect(paymentSuccess, isTrue);

      // 3. Create order
      final order = {
        'id': 'order1',
        'userId': 'user1',
        'total': 150.0,
        'items': [
          {'productId': 'product1', 'quantity': 2},
          {'productId': 'product2', 'quantity': 1},
        ],
      };
      orderRepository.saveOrder(order);

      // 4. Update inventory
      inventoryManager.updateStock('product1', 2);
      inventoryManager.updateStock('product2', 1);

      // 5. Send notification
      notificationService.sendOrderConfirmation('user1', 'order1');

      // Assert - Verify final state
      final savedOrder = orderRepository.getOrdersByUserId('user1');
      expect(savedOrder.length, equals(1));
      expect(savedOrder.first['id'], equals('order1'));

      final product1Stock = inventoryManager.checkAvailability('product1', 8);
      expect(product1Stock, isTrue); // 10 - 2 = 8

      final product2Stock = inventoryManager.checkAvailability('product2', 4);
      expect(product2Stock, isTrue); // 5 - 1 = 4
    });

    test('should handle order failure when inventory insufficient', () {
      // Arrange
      final user = User(
        id: 'user1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 500.0,
      );
      userRepository.addUser(user);

      inventoryManager.updateStock('product1', 1); // Only 1 in stock

      // Act - Try to order 2 items
      final available = inventoryManager.checkAvailability('product1', 2);

      // Assert - Order should fail
      expect(available, isFalse);
      // No order should be created
      final orders = orderRepository.getOrdersByUserId('user1');
      expect(orders.isEmpty, isTrue);
    });

    test('should handle multiple orders for same user', () {
      // Arrange
      final user = User(
        id: 'user1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 1000.0,
      );
      userRepository.addUser(user);

      inventoryManager.updateStock('product1', 20);

      // Act - Process multiple orders
      for (int i = 1; i <= 3; i++) {
        final available = inventoryManager.checkAvailability('product1', 2);
        if (available) {
          paymentProcessor.processPayment(100.0, 'credit_card');
          orderRepository.saveOrder({
            'id': 'order$i',
            'userId': 'user1',
            'total': 100.0,
          });
          inventoryManager.updateStock('product1', 2);
        }
      }

      // Assert
      final orders = orderRepository.getOrdersByUserId('user1');
      expect(orders.length, equals(3));
    });
  });

  group('User Registration and Report Generation Integration', () {
    late UserRepository userRepository;
    late EmailValidator emailValidator;
    late EmailService emailService;
    late ReportGenerator reportGenerator;

    setUp(() {
      userRepository = UserRepository();
      emailValidator = EmailValidator();
      emailService = EmailService();
      reportGenerator = ReportGenerator();
    });

    test('should register user and generate report', () {
      // Arrange
      final users = [
        User(id: '1', name: 'User 1', email: 'user1@test.com', balance: 100.0),
        User(id: '2', name: 'User 2', email: 'user2@test.com', balance: 200.0),
        User(id: '3', name: 'User 3', email: 'user3@test.com', balance: 300.0),
      ];

      // Act - Register users
      for (final user in users) {
        // Validate email
        if (emailValidator.isValidEmail(user.email)) {
          userRepository.addUser(user);
          // Send welcome email
          emailService.sendEmail(
            user.email,
            'Welcome!',
            'Welcome to our service, ${user.name}!',
          );
        }
      }

      // Generate report
      final allUsers = userRepository.getAllUsers();
      final report = reportGenerator.generateUserReport(allUsers);

      // Assert
      expect(allUsers.length, equals(3));
      expect(report, contains('Total Users: 3'));
      expect(report, contains('Total Balance: \$600.00'));
    });

    test('should reject invalid emails during registration', () {
      // Arrange
      final invalidEmails = [
        'invalid-email',
        'no@domain',
        'missing@.com',
      ];

      // Act & Assert
      for (final email in invalidEmails) {
        final isValid = emailValidator.isValidEmail(email);
        expect(isValid, isFalse, reason: '$email should be invalid');
      }
    });
  });
}

