/// EXERCISE: Hard - Interface Segregation Principle
///
/// TASK: Refactor this code to follow Interface Segregation Principle.
/// Currently, DatabaseConnection interface forces all implementations to support
/// operations they may not need (e.g., read-only connections don't need write methods).
///
/// HINT: Split into focused interfaces:
/// - Readable (read operations)
/// - Writable (write operations)
/// - Transactional (transaction operations)
/// - Queryable (query operations)
/// - Configurable (configuration operations)
/// Classes can implement only the interfaces they need.

abstract class DatabaseConnection {
  // Connection management
  void connect();
  void disconnect();
  bool isConnected();

  // Read operations
  Map<String, dynamic>? read(String table, String id);
  List<Map<String, dynamic>> query(String sql);
  List<Map<String, dynamic>> findAll(String table);

  // Write operations
  void insert(String table, Map<String, dynamic> data);
  void update(String table, String id, Map<String, dynamic> data);
  void delete(String table, String id);
  void bulkInsert(String table, List<Map<String, dynamic>> data);

  // Transaction operations
  void beginTransaction();
  void commitTransaction();
  void rollbackTransaction();

  // Configuration operations
  void setConnectionTimeout(int seconds);
  void setMaxConnections(int max);
  void enableSSL(bool enabled);
  void setConnectionPoolSize(int size);

  // Advanced query operations
  List<Map<String, dynamic>> executeRawQuery(String sql);
  Map<String, dynamic> executeStoredProcedure(
    String procedure,
    Map<String, dynamic> params,
  );
}

/// ReadOnlyConnection is forced to implement write methods it doesn't need
class ReadOnlyConnection implements DatabaseConnection {
  bool _connected = false;

  @override
  void connect() {
    _connected = true;
    print('Read-only connection established');
  }

  @override
  void disconnect() {
    _connected = false;
    print('Read-only connection closed');
  }

  @override
  bool isConnected() => _connected;

  @override
  Map<String, dynamic>? read(String table, String id) {
    print('Reading from $table: $id');
    return {'id': id, 'data': 'sample'};
  }

  @override
  List<Map<String, dynamic>> query(String sql) {
    print('Executing query: $sql');
    return [];
  }

  @override
  List<Map<String, dynamic>> findAll(String table) {
    print('Finding all in $table');
    return [];
  }

  // Forced to implement write methods even though read-only
  @override
  void insert(String table, Map<String, dynamic> data) {
    throw Exception('Read-only connection cannot insert!');
  }

  @override
  void update(String table, String id, Map<String, dynamic> data) {
    throw Exception('Read-only connection cannot update!');
  }

  @override
  void delete(String table, String id) {
    throw Exception('Read-only connection cannot delete!');
  }

  @override
  void bulkInsert(String table, List<Map<String, dynamic>> data) {
    throw Exception('Read-only connection cannot bulk insert!');
  }

  // Forced to implement transaction methods
  @override
  void beginTransaction() {
    throw Exception('Read-only connection does not support transactions!');
  }

  @override
  void commitTransaction() {
    throw Exception('Read-only connection does not support transactions!');
  }

  @override
  void rollbackTransaction() {
    throw Exception('Read-only connection does not support transactions!');
  }

  // Forced to implement configuration methods
  @override
  void setConnectionTimeout(int seconds) {
    print('Setting connection timeout: $seconds');
  }

  @override
  void setMaxConnections(int max) {
    print('Setting max connections: $max');
  }

  @override
  void enableSSL(bool enabled) {
    print('SSL enabled: $enabled');
  }

  @override
  void setConnectionPoolSize(int size) {
    print('Connection pool size: $size');
  }

  @override
  List<Map<String, dynamic>> executeRawQuery(String sql) {
    return query(sql);
  }

  @override
  Map<String, dynamic> executeStoredProcedure(
    String procedure,
    Map<String, dynamic> params,
  ) {
    throw Exception('Read-only connection cannot execute stored procedures!');
  }
}

/// SimpleConnection doesn't need advanced features but is forced to implement them
class SimpleConnection implements DatabaseConnection {
  bool _connected = false;

  @override
  void connect() {
    _connected = true;
    print('Simple connection established');
  }

  @override
  void disconnect() {
    _connected = false;
    print('Simple connection closed');
  }

  @override
  bool isConnected() => _connected;

  @override
  Map<String, dynamic>? read(String table, String id) {
    return {'id': id};
  }

  @override
  List<Map<String, dynamic>> query(String sql) {
    return [];
  }

  @override
  List<Map<String, dynamic>> findAll(String table) {
    return [];
  }

  @override
  void insert(String table, Map<String, dynamic> data) {
    print('Inserting into $table');
  }

  @override
  void update(String table, String id, Map<String, dynamic> data) {
    print('Updating $table: $id');
  }

  @override
  void delete(String table, String id) {
    print('Deleting from $table: $id');
  }

  @override
  void bulkInsert(String table, List<Map<String, dynamic>> data) {
    print('Bulk inserting into $table');
  }

  // Forced to implement transaction methods even though not supported
  @override
  void beginTransaction() {
    throw Exception('Simple connection does not support transactions!');
  }

  @override
  void commitTransaction() {
    throw Exception('Simple connection does not support transactions!');
  }

  @override
  void rollbackTransaction() {
    throw Exception('Simple connection does not support transactions!');
  }

  @override
  void setConnectionTimeout(int seconds) {
    print('Setting timeout: $seconds');
  }

  @override
  void setMaxConnections(int max) {
    print('Max connections: $max');
  }

  @override
  void enableSSL(bool enabled) {
    print('SSL: $enabled');
  }

  @override
  void setConnectionPoolSize(int size) {
    print('Pool size: $size');
  }

  // Forced to implement advanced query methods
  @override
  List<Map<String, dynamic>> executeRawQuery(String sql) {
    return query(sql);
  }

  @override
  Map<String, dynamic> executeStoredProcedure(
    String procedure,
    Map<String, dynamic> params,
  ) {
    throw Exception('Simple connection does not support stored procedures!');
  }
}
