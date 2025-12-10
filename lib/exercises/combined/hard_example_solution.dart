/// SOLUTION: Hard - Applying ALL SOLID Principles
///
/// - SRP: Split responsibilities into focused services (auth, sessions, users,
///   logging, analytics).
/// - OCP: Add new log levels or user types via strategies/factories without
///   modifying existing classes.
/// - LSP: Specialized users honor the base user contracts (no thrown surprises).
/// - ISP: Users implement only the capabilities they need.
/// - DIP: High-level services depend on abstractions, not concrete classes.

// -----------------------------------------------------------------------------
// Logging (OCP + DIP)
// -----------------------------------------------------------------------------

abstract class LogChannel {
  void log(String message);
}

class InfoLog implements LogChannel {
  @override
  void log(String message) => print('INFO: $message');
}

class ErrorLog implements LogChannel {
  @override
  void log(String message) => print('ERROR: $message');
}

class DebugLog implements LogChannel {
  @override
  void log(String message) => print('DEBUG: $message');
}

/// Add new channels without modifying `Logger` by registering them.
class Logger {
  final Map<String, LogChannel> _channels;

  Logger({required Map<String, LogChannel> channels})
    : _channels = Map.of(channels);

  void log(String level, String message) {
    final channel = _channels[level];
    (channel ?? _channels['default'])?.log(message);
  }
}

// -----------------------------------------------------------------------------
// Persistence + Cache + Analytics (DIP)
// -----------------------------------------------------------------------------

abstract class DataStore {
  void save(String table, Map<String, dynamic> data);
  Map<String, dynamic>? find(String table, String id);
}

class MySQLDataStore implements DataStore {
  @override
  void save(String table, Map<String, dynamic> data) {
    print('Saving to MySQL: $table');
  }

  @override
  Map<String, dynamic>? find(String table, String id) {
    print('Finding in MySQL: $table, id: $id');
    return {'id': id};
  }
}

abstract class CacheStore {
  void set(String key, String value);
  String? get(String key);
}

class RedisCacheStore implements CacheStore {
  @override
  void set(String key, String value) {
    print('Caching in Redis: $key');
  }

  @override
  String? get(String key) {
    print('Getting from Redis: $key');
    return null;
  }
}

abstract class Analytics {
  void track(String event, Map<String, dynamic> properties);
}

class ConsoleAnalytics implements Analytics {
  @override
  void track(String event, Map<String, dynamic> properties) {
    print('ANALYTICS: $event - $properties');
  }
}

// -----------------------------------------------------------------------------
// User capabilities (ISP)
// -----------------------------------------------------------------------------

abstract class Identity {
  String get username;
  String get email;
}

abstract class SessionParticipant {
  void login();
  void logout();
}

abstract class ProfileOwner {
  void viewProfile();
  void editProfile();
  void deleteAccount();
}

abstract class AdminCapabilities {
  void manageUsers();
  void viewReports();
}

abstract class ModeratorCapabilities {
  void approveContent();
}

class RegularUser implements Identity, SessionParticipant, ProfileOwner {
  @override
  final String username;
  @override
  final String email;

  RegularUser(this.username, this.email);

  @override
  void login() => print('$username logged in');

  @override
  void logout() => print('$username logged out');

  @override
  void viewProfile() => print('Viewing profile for $username');

  @override
  void editProfile() => print('Editing profile for $username');

  @override
  void deleteAccount() => print('Deleting account for $username');
}

class AdminUser
    implements Identity, SessionParticipant, ProfileOwner, AdminCapabilities {
  @override
  final String username;
  @override
  final String email;

  AdminUser(this.username, this.email);

  @override
  void login() => print('Admin $username logged in');

  @override
  void logout() => print('Admin $username logged out');

  @override
  void viewProfile() => print('Viewing admin profile for $username');

  @override
  void editProfile() => print('Editing admin profile for $username');

  @override
  void deleteAccount() =>
      print('Admin account deletion requires approval for $username');

  @override
  void manageUsers() => print('$username is managing users');

  @override
  void viewReports() => print('$username is viewing reports');
}

class ModeratorUser
    implements
        Identity,
        SessionParticipant,
        ProfileOwner,
        ModeratorCapabilities {
  @override
  final String username;
  @override
  final String email;

  ModeratorUser(this.username, this.email);

  @override
  void login() => print('Moderator $username logged in');

  @override
  void logout() => print('Moderator $username logged out');

  @override
  void viewProfile() => print('Viewing moderator profile for $username');

  @override
  void editProfile() => print('Editing moderator profile for $username');

  @override
  void deleteAccount() =>
      print('Moderator account deletion requires review for $username');

  @override
  void approveContent() => print('$username approved content');
}

// -----------------------------------------------------------------------------
// Factories and Repositories (OCP + DIP)
// -----------------------------------------------------------------------------

abstract class UserFactory {
  Identity create(String username, String email);
}

class RegularUserFactory implements UserFactory {
  @override
  Identity create(String username, String email) =>
      RegularUser(username, email);
}

class AdminUserFactory implements UserFactory {
  @override
  Identity create(String username, String email) => AdminUser(username, email);
}

class ModeratorUserFactory implements UserFactory {
  @override
  Identity create(String username, String email) =>
      ModeratorUser(username, email);
}

abstract class UserRepository {
  void addUser(Identity user);
  Identity? findUser(String username);
  void removeUser(String username);
}

class InMemoryUserRepository implements UserRepository {
  final Map<String, Identity> _users = {};

  @override
  void addUser(Identity user) => _users[user.username] = user;

  @override
  Identity? findUser(String username) => _users[username];

  @override
  void removeUser(String username) => _users.remove(username);
}

// -----------------------------------------------------------------------------
// Services (SRP + DIP)
// -----------------------------------------------------------------------------

class AuthService {
  final Logger _logger;
  final Analytics _analytics;
  final UserRepository _users;

  AuthService(this._logger, this._analytics, this._users);

  bool authenticate(String username, String password) {
    _logger.log('info', 'Authentication attempt: $username');
    final user = _users.findUser(username);
    if (user == null) {
      _logger.log('error', 'User not found: $username');
      return false;
    }
    _logger.log('info', 'User authenticated: $username');
    _analytics.track('user_login', {'username': username});
    return true;
  }
}

class SessionService {
  final CacheStore _cache;
  final Logger _logger;

  SessionService(this._cache, this._logger);

  String createSession(String username) {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _cache.set('session_$sessionId', sessionId);
    _logger.log('info', 'Session created: $sessionId');
    return sessionId;
  }
}

class UserRegistrationService {
  final UserRepository _users;
  final DataStore _store;
  final Logger _logger;
  final Analytics _analytics;
  final Map<String, UserFactory> _factories;

  UserRegistrationService(
    this._users,
    this._store,
    this._logger,
    this._analytics,
    Map<String, UserFactory> factories,
  ) : _factories = Map.of(factories);

  void registerUser(String username, String email, String userType) {
    final factory = _factories[userType];
    if (factory == null) {
      throw Exception('Unknown user type: $userType');
    }

    final user = factory.create(username, email);
    _users.addUser(user);
    _store.save('users', {
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
}

class UserRemovalService {
  final UserRepository _users;
  final DataStore _store;
  final Logger _logger;

  UserRemovalService(this._users, this._store, this._logger);

  void deleteUser(String username) {
    final user = _users.findUser(username);
    if (user == null) {
      throw Exception('User not found');
    }

    // Respect LSP: all users provide a safe deleteAccount implementation
    (user as ProfileOwner).deleteAccount();

    _users.removeUser(username);
    _store.save('users', {'username': username, 'status': 'deleted'});
    _logger.log('info', 'User account deleted: $username');
  }
}

// -----------------------------------------------------------------------------
// Facade wiring everything together (SRP orchestration + DIP)
// -----------------------------------------------------------------------------

class UserManagementSystem {
  final AuthService _auth;
  final SessionService _sessions;
  final UserRegistrationService _registration;
  final UserRemovalService _removal;

  UserManagementSystem({
    required AuthService auth,
    required SessionService sessions,
    required UserRegistrationService registration,
    required UserRemovalService removal,
  }) : _auth = auth,
       _sessions = sessions,
       _registration = registration,
       _removal = removal;

  void processUserRegistration(
    String username,
    String email,
    String password,
    String userType,
  ) {
    _registration.registerUser(username, email, userType);

    if (_auth.authenticate(username, password)) {
      _sessions.createSession(username);
    }
  }

  void deleteUserAccount(String username) {
    _removal.deleteUser(username);
  }
}

// -----------------------------------------------------------------------------
// Example Composition (would live in DI / main in real app)
// -----------------------------------------------------------------------------

Logger buildDefaultLogger() {
  return Logger(
    channels: {
      'info': InfoLog(),
      'error': ErrorLog(),
      'debug': DebugLog(),
      'default': InfoLog(),
    },
  );
}

UserManagementSystem buildSystem() {
  final logger = buildDefaultLogger();
  final analytics = ConsoleAnalytics();
  final dataStore = MySQLDataStore();
  final cache = RedisCacheStore();
  final users = InMemoryUserRepository();

  final auth = AuthService(logger, analytics, users);
  final sessions = SessionService(cache, logger);
  final registration =
      UserRegistrationService(users, dataStore, logger, analytics, {
        'regular': RegularUserFactory(),
        'admin': AdminUserFactory(),
        'moderator': ModeratorUserFactory(),
      });
  final removal = UserRemovalService(users, dataStore, logger);

  return UserManagementSystem(
    auth: auth,
    sessions: sessions,
    registration: registration,
    removal: removal,
  );
}
