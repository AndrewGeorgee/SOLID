/// SOLUTION: Hard - Single Responsibility Principle
///
/// This solution demonstrates how to apply the Single Responsibility Principle
/// by separating authentication, session management, logging, database operations,
/// caching, and analytics into different classes, each with a single responsibility.

/// ============================================================================
/// PART 1: Authentication Service (Single Responsibility: User authentication)
/// ============================================================================

class AuthenticationService {
  final Map<String, String> _users = {}; // username -> password

  bool authenticate(String username, String password) {
    return _users[username] == password;
  }

  void saveUser(String username, String password) {
    _users[username] = password;
    print('Saving user $username to database...');
  }

  Map<String, String> getAllUsers() {
    return Map.unmodifiable(_users);
  }

  bool userExists(String username) {
    return _users.containsKey(username);
  }
}

/// ============================================================================
/// PART 2: Session Manager (Single Responsibility: Managing sessions)
/// ============================================================================

class SessionManager {
  final Map<String, Map<String, dynamic>> _sessions = {};

  String createSession(String username) {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessions[sessionId] = {
      'username': username,
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    };
    return sessionId;
  }

  bool validateSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) return false;

    final expiresAt = DateTime.parse(session['expiresAt']);
    if (DateTime.now().isAfter(expiresAt)) {
      _sessions.remove(sessionId);
      return false;
    }
    return true;
  }

  Map<String, dynamic>? getSession(String sessionId) {
    return _sessions[sessionId];
  }

  void removeSession(String sessionId) {
    _sessions.remove(sessionId);
  }
}

/// ============================================================================
/// PART 3: Logger (Single Responsibility: Logging activities)
/// ============================================================================

class Logger {
  final List<Map<String, dynamic>> _logs = [];

  void log(String action, String details) {
    _logs.add({
      'action': action,
      'details': details,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print('LOG: $action - $details');
  }

  List<Map<String, dynamic>> getLogs() {
    return List.unmodifiable(_logs);
  }

  void clearLogs() {
    _logs.clear();
  }
}

/// ============================================================================
/// PART 4: Database Repository (Single Responsibility: Database operations)
/// ============================================================================

class DatabaseRepository {
  final Map<String, Map<String, dynamic>> _data = {};

  void save(String table, String id, Map<String, dynamic> data) {
    _data['$table:$id'] = data;
    print('Saving to database: $table, id: $id');
  }

  Map<String, dynamic>? findById(String table, String id) {
    return _data['$table:$id'];
  }

  List<Map<String, dynamic>> findAll(String table) {
    return _data.entries
        .where((entry) => entry.key.startsWith('$table:'))
        .map((entry) => entry.value)
        .toList();
  }

  void delete(String table, String id) {
    _data.remove('$table:$id');
    print('Deleting from database: $table, id: $id');
  }
}

/// ============================================================================
/// PART 5: Cache Manager (Single Responsibility: Caching data)
/// ============================================================================

class CacheManager {
  final Map<String, Map<String, dynamic>> _cache = {};

  void cacheData(String key, Map<String, dynamic> data) {
    _cache[key] = data;
    print('Caching data: $key');
  }

  Map<String, dynamic>? getCachedData(String key) {
    return _cache[key];
  }

  void removeCachedData(String key) {
    _cache.remove(key);
    print('Removing cached data: $key');
  }

  void clearCache() {
    _cache.clear();
    print('Cache cleared');
  }
}

/// ============================================================================
/// PART 6: Analytics Tracker (Single Responsibility: Tracking analytics)
/// ============================================================================

class AnalyticsTracker {
  final List<Map<String, dynamic>> _analytics = [];

  void track(String event, Map<String, dynamic> properties) {
    _analytics.add({
      'event': event,
      'properties': properties,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print('ANALYTICS: $event - $properties');
  }

  List<Map<String, dynamic>> getAnalytics() {
    return List.unmodifiable(_analytics);
  }

  void clearAnalytics() {
    _analytics.clear();
  }
}

/// ============================================================================
/// PART 7: User Authentication System V2 (Orchestrates all services)
/// ============================================================================

class UserAuthenticationSystemV2 {
  final AuthenticationService _authService;
  final SessionManager _sessionManager;
  final Logger _logger;
  final DatabaseRepository _databaseRepository;
  final CacheManager _cacheManager;
  final AnalyticsTracker _analyticsTracker;

  UserAuthenticationSystemV2({
    required AuthenticationService authService,
    required SessionManager sessionManager,
    required Logger logger,
    required DatabaseRepository databaseRepository,
    required CacheManager cacheManager,
    required AnalyticsTracker analyticsTracker,
  }) : _authService = authService,
       _sessionManager = sessionManager,
       _logger = logger,
       _databaseRepository = databaseRepository,
       _cacheManager = cacheManager,
       _analyticsTracker = analyticsTracker;

  /// Authenticates user and creates session
  bool authenticate(String username, String password) {
    final success = _authService.authenticate(username, password);

    if (success) {
      _logger.log('login', username);
      _analyticsTracker.track('user_login', {'username': username});
    } else {
      _logger.log('failed_login', username);
    }

    return success;
  }

  /// Creates a session for authenticated user
  String createSession(String username) {
    final sessionId = _sessionManager.createSession(username);

    // Cache session data
    final session = _sessionManager.getSession(sessionId);
    if (session != null) {
      _cacheManager.cacheData('session_$sessionId', session);
    }

    _logger.log('session_created', username);
    return sessionId;
  }

  /// Validates session
  bool validateSession(String sessionId) {
    // Check cache first
    final cachedSession = _cacheManager.getCachedData('session_$sessionId');
    if (cachedSession != null) {
      return _sessionManager.validateSession(sessionId);
    }

    final isValid = _sessionManager.validateSession(sessionId);
    if (!isValid) {
      _logger.log('session_expired', sessionId);
    }
    return isValid;
  }

  /// Saves user to database
  void saveUser(String username, String password) {
    _authService.saveUser(username, password);
    _databaseRepository.save('users', username, {
      'username': username,
      'password': password, // In real app, this would be hashed
    });
    _logger.log('user_saved', username);
  }

  /// Gets all users
  Map<String, String> getAllUsers() {
    return _authService.getAllUsers();
  }

  /// Gets logs
  List<Map<String, dynamic>> getLogs() {
    return _logger.getLogs();
  }

  /// Gets cached data
  Map<String, dynamic>? getCachedData(String key) {
    return _cacheManager.getCachedData(key);
  }

  /// Gets analytics
  List<Map<String, dynamic>> getAnalytics() {
    return _analyticsTracker.getAnalytics();
  }
}
