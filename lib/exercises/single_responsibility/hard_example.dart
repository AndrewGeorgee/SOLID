/// EXERCISE: Hard - Single Responsibility Principle
///
/// TASK: Refactor this class to follow Single Responsibility Principle.
/// This class handles user authentication, session management, logging,
/// database operations, caching, and analytics.
///
/// HINT: Create separate classes/services for each responsibility:
/// - Authentication service
/// - Session manager
/// - Logger
/// - Database repository
/// - Cache manager
/// - Analytics tracker

class UserAuthenticationSystem {
  final Map<String, String> _users = {}; // username -> password
  final Map<String, Map<String, dynamic>> _sessions =
      {}; // sessionId -> session data
  final List<Map<String, dynamic>> _logs = [];
  final Map<String, Map<String, dynamic>> _cache = {};

  // Authentication responsibility
  bool authenticate(String username, String password) {
    if (_users[username] == password) {
      _logActivity('login', username);
      _trackAnalytics('user_login', {'username': username});
      return true;
    }
    _logActivity('failed_login', username);
    return false;
  }

  // Session management responsibility
  String createSession(String username) {
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    _sessions[sessionId] = {
      'username': username,
      'createdAt': DateTime.now().toIso8601String(),
      'expiresAt': DateTime.now().add(Duration(hours: 24)).toIso8601String(),
    };
    _cache['session_$sessionId'] = _sessions[sessionId]!;
    _logActivity('session_created', username);
    return sessionId;
  }

  bool validateSession(String sessionId) {
    final session = _sessions[sessionId];
    if (session == null) return false;

    final expiresAt = DateTime.parse(session['expiresAt']);
    if (DateTime.now().isAfter(expiresAt)) {
      _sessions.remove(sessionId);
      _cache.remove('session_$sessionId');
      _logActivity('session_expired', sessionId);
      return false;
    }
    return true;
  }

  // Logging responsibility
  void _logActivity(String action, String details) {
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

  // Database responsibility
  void saveUser(String username, String password) {
    _users[username] = password;
    print('Saving user $username to database...');
    _logActivity('user_saved', username);
  }

  Map<String, String> getAllUsers() {
    return Map.unmodifiable(_users);
  }

  // Caching responsibility
  void cacheData(String key, Map<String, dynamic> data) {
    _cache[key] = data;
  }

  Map<String, dynamic>? getCachedData(String key) {
    return _cache[key];
  }

  // Analytics responsibility
  void _trackAnalytics(String event, Map<String, dynamic> properties) {
    print('ANALYTICS: $event - $properties');
    // Analytics tracking logic...
  }
}
