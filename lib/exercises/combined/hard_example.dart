/// EXERCISE: Hard - Multiple SOLID Principles
///
/// TASK: Refactor this code to follow ALL SOLID principles.
/// This code violates:
/// 1. Single Responsibility Principle (SRP) - handles auth, sessions, logging, database, cache, analytics
/// 2. Open/Closed Principle (OCP) - adding new user types or log levels requires modification
/// 3. Liskov Substitution Principle (LSP) - AdminUser changes behavior of base User
/// 4. Interface Segregation Principle (ISP) - User interface forces all users to implement all methods
/// 5. Dependency Inversion Principle (DIP) - directly depends on concrete implementations
///
/// HINT:
/// - Split into separate services (SRP)
/// - Create abstractions for all dependencies (DIP)
/// - Use strategy pattern for user types and log levels (OCP)
/// - Split User interface into smaller interfaces (ISP)
/// - Fix AdminUser to properly substitute User (LSP)

class FileLogger {
  void log(String level, String message) {
    // Adding new log level requires modification
    switch (level) {
      case 'info':
        print('INFO: $message');
        break;
      case 'error':
        print('ERROR: $message');
        break;
      case 'debug':
        print('DEBUG: $message');
        break;
      // Adding new level requires modification
      default:
        print('LOG: $message');
    }
  }
}

class MySQLDatabase {
  void save(String table, Map<String, dynamic> data) {
    print('Saving to MySQL: $table');
  }

  Map<String, dynamic>? find(String table, String id) {
    print('Finding in MySQL: $table, id: $id');
    return {'id': id};
  }
}

class RedisCache {
  void set(String key, String value) {
    print('Caching in Redis: $key');
  }

  String? get(String key) {
    print('Getting from Redis: $key');
    return null;
  }
}

class AnalyticsTracker {
  void track(String event, Map<String, dynamic> properties) {
    print('ANALYTICS: $event - $properties');
  }
}

/// Violates ISP - forces all users to implement all methods
abstract class User {
  String get username;
  String get email;

  // All users must implement all methods, even if they don't need them
  void login();
  void logout();
  void viewProfile();
  void editProfile();
  void deleteAccount();
  void manageUsers(); // Only admins need this
  void viewReports(); // Only admins/managers need this
  void approveContent(); // Only moderators need this
}

/// Regular user - forced to implement methods they don't need (violates ISP)
class RegularUser implements User {
  @override
  final String username;
  @override
  final String email;

  RegularUser(this.username, this.email);

  @override
  void login() {
    print('$username logged in');
  }

  @override
  void logout() {
    print('$username logged out');
  }

  @override
  void viewProfile() {
    print('Viewing profile for $username');
  }

  @override
  void editProfile() {
    print('Editing profile for $username');
  }

  @override
  void deleteAccount() {
    print('Deleting account for $username');
  }

  // Regular users don't need these, but are forced to implement
  @override
  void manageUsers() {
    throw Exception('Regular users cannot manage users!');
  }

  @override
  void viewReports() {
    throw Exception('Regular users cannot view reports!');
  }

  @override
  void approveContent() {
    throw Exception('Regular users cannot approve content!');
  }
}

/// Admin user - violates LSP by changing behavior
class AdminUser extends RegularUser {
  AdminUser(super.username, super.email);

  @override
  void deleteAccount() {
    // Admin users cannot delete their own account (changes expected behavior - violates LSP)
    throw Exception('Admin accounts cannot be deleted!');
  }

  @override
  void manageUsers() {
    print('$username is managing users');
  }

  @override
  void viewReports() {
    print('$username is viewing reports');
  }

  @override
  void approveContent() {
    print('$username is approving content');
  }
}

/// Violates SRP, OCP, and DIP
class UserManagementSystem {
  final FileLogger _logger = FileLogger(); // Direct dependency
  final MySQLDatabase _database = MySQLDatabase(); // Direct dependency
  final RedisCache _cache = RedisCache(); // Direct dependency
  final AnalyticsTracker _analytics = AnalyticsTracker(); // Direct dependency
  final Map<String, User> _users = {};
  final Map<String, Map<String, dynamic>> _sessions = {};

  // Authentication responsibility
  bool authenticate(String username, String password) {
    _logger.log('info', 'Authentication attempt: $username');

    final user = _users[username];
    if (user == null) {
      _logger.log('error', 'User not found: $username');
      return false;
    }

    // Simplified password check
    _logger.log('info', 'User authenticated: $username');
    _analytics.track('user_login', {'username': username});
    return true;
  }

  // Session management responsibility
  String createSession(String username) {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessions[sessionId] = {
      'username': username,
      'createdAt': DateTime.now().toIso8601String(),
    };
    _cache.set('session_$sessionId', sessionId);
    _logger.log('info', 'Session created: $sessionId');
    return sessionId;
  }

  // User type handling - violates OCP (adding new user type requires modification)
  void registerUser(String username, String email, String userType) {
    // Adding new user type requires modifying this switch
    User user;
    switch (userType) {
      case 'regular':
        user = RegularUser(username, email);
        break;
      case 'admin':
        user = AdminUser(username, email);
        break;
      // Adding new user type requires modification
      default:
        throw Exception('Unknown user type');
    }

    _users[username] = user;
    _database.save('users', {
      'username': username,
      'email': email,
      'type': userType,
    });
    _logger.log('info', 'User registered: $username');
    _analytics.track('user_registered', {
      'username': username,
      'type': userType,
    });
  }

  // User operations - violates LSP (AdminUser changes deleteAccount behavior)
  void deleteUserAccount(String username) {
    final user = _users[username];
    if (user == null) {
      throw Exception('User not found');
    }

    // This will throw exception for AdminUser (violates LSP)
    user.deleteAccount();
    _users.remove(username);
    _database.save('users', {'username': username, 'status': 'deleted'});
    _logger.log('info', 'User account deleted: $username');
  }

  // Complete user management - violates SRP (does everything)
  void processUserRegistration(
    String username,
    String email,
    String password,
    String userType,
  ) {
    // Validate
    if (_users.containsKey(username)) {
      throw Exception('User already exists');
    }

    // Register
    registerUser(username, email, userType);

    // Authenticate
    if (authenticate(username, password)) {
      createSession(username);
    }

    // Log and track
    _logger.log('info', 'User registration completed: $username');
    _analytics.track('registration_complete', {'username': username});
  }
}
