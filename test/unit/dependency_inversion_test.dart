import 'package:flutter_test/flutter_test.dart';
import '../../lib/principles/dependency_inversion/good_example.dart';
import '../../lib/models/user.dart';

/// UNIT TESTS: Dependency Inversion Principle
///
/// Tests that high-level modules depend on abstractions,
/// and can work with any implementation.

void main() {
  group('UserService - Depends on Abstractions', () {
    test('should work with MySQLUserRepository', () {
      // Arrange
      final repository = MySQLUserRepository();
      final notificationService = EmailNotificationService();
      final userService = UserService(
        repository: repository,
        notificationService: notificationService,
      );
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 100.0,
      );

      // Act & Assert - Should not throw
      expect(() => userService.registerUser(user), returnsNormally);
    });

    test('should work with PostgreSQLUserRepository', () {
      // Arrange
      final repository = PostgreSQLUserRepository();
      final notificationService = EmailNotificationService();
      final userService = UserService(
        repository: repository,
        notificationService: notificationService,
      );
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 100.0,
      );

      // Act & Assert - Should not throw
      expect(() => userService.registerUser(user), returnsNormally);
    });

    test('should work with different notification services', () {
      // Arrange
      final repository = MySQLUserRepository();
      final smsService = SMSNotificationService();
      final userService = UserService(
        repository: repository,
        notificationService: smsService,
      );
      final user = User(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        balance: 100.0,
      );

      // Act & Assert - Should not throw
      expect(() => userService.registerUser(user), returnsNormally);
    });

    test('should retrieve user from any repository implementation', () {
      // Arrange
      final repository = PostgreSQLUserRepository();
      final notificationService = PushNotificationService();
      final userService = UserService(
        repository: repository,
        notificationService: notificationService,
      );

      // Act
      final user = userService.getUser('1');

      // Assert - Works with any repository
      expect(user, isNull); // Repository is empty, but no error
    });
  });

  group('OrderService - Depends on Abstractions', () {
    test('should work with StripeProcessor', () {
      // Arrange
      final processor = StripeProcessor();
      final orderService = OrderService(paymentProcessor: processor);

      // Act & Assert - Should not throw
      expect(
        () => orderService.processOrder(100.0, {'method': 'card'}),
        returnsNormally,
      );
    });

    test('should work with PayPalProcessor', () {
      // Arrange
      final processor = PayPalProcessor();
      final orderService = OrderService(paymentProcessor: processor);

      // Act & Assert - Should not throw
      expect(
        () => orderService.processOrder(100.0, {'method': 'paypal'}),
        returnsNormally,
      );
    });

    test('should work with SquareProcessor', () {
      // Arrange
      final processor = SquareProcessor();
      final orderService = OrderService(paymentProcessor: processor);

      // Act & Assert - Should not throw
      expect(
        () => orderService.processOrder(100.0, {'method': 'square'}),
        returnsNormally,
      );
    });
  });

  group('SettingsService - Depends on Abstractions', () {
    test('should work with FileStorage', () {
      // Arrange
      final storage = FileStorage();
      final settingsService = SettingsService(storage: storage);

      // Act & Assert - Should not throw
      expect(
        () => settingsService.saveSetting('key', 'value'),
        returnsNormally,
      );
      expect(() => settingsService.getSetting('key'), returnsNormally);
    });

    test('should work with CloudStorage', () {
      // Arrange
      final storage = CloudStorage();
      final settingsService = SettingsService(storage: storage);

      // Act & Assert - Should not throw
      expect(
        () => settingsService.saveSetting('key', 'value'),
        returnsNormally,
      );
      expect(() => settingsService.getSetting('key'), returnsNormally);
    });

    test('should work with CacheStorage', () {
      // Arrange
      final storage = CacheStorage();
      final settingsService = SettingsService(storage: storage);

      // Act
      settingsService.saveSetting('key', 'value');
      final value = settingsService.getSetting('key');

      // Assert
      expect(value, equals('value'));
    });

    test('should retrieve from CacheStorage correctly', () {
      // Arrange
      final storage = CacheStorage();
      final settingsService = SettingsService(storage: storage);

      // Act
      settingsService.saveSetting('theme', 'dark');
      final theme = settingsService.getSetting('theme');

      // Assert
      expect(theme, equals('dark'));
    });
  });
}
