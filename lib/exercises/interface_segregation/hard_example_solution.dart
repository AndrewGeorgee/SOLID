/// Solution: Interface Segregation for database connections.

// Core connection lifecycle
abstract class Connectable {
  void connect();
  void disconnect();
  bool isConnected();
}

// Read capabilities
abstract class Readable {
  Map<String, dynamic>? read(String table, String id);
  List<Map<String, dynamic>> query(String sql);
  List<Map<String, dynamic>> findAll(String table);
}

// Write capabilities
abstract class Writable {
  void insert(String table, Map<String, dynamic> data);
  void update(String table, String id, Map<String, dynamic> data);
  void delete(String table, String id);
  void bulkInsert(String table, List<Map<String, dynamic>> data);
}

// Transaction capabilities
abstract class Transactional {
  void beginTransaction();
  void commitTransaction();
  void rollbackTransaction();
}

// Configuration capabilities
abstract class Configurable {
  void setConnectionTimeout(int seconds);
  void setMaxConnections(int max);
  void enableSSL(bool enabled);
  void setConnectionPoolSize(int size);
}

// Advanced querying capabilities
abstract class Queryable {
  List<Map<String, dynamic>> executeRawQuery(String sql);
  Map<String, dynamic> executeStoredProcedure(
    String procedure,
    Map<String, dynamic> params,
  );
}

/// Read-only connection implements only what it needs.
class ReadOnlyConnection implements Connectable, Readable {
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
}

/// Simple connection implements read/write, but not advanced or transactions.
class SimpleConnection implements Connectable, Readable, Writable {
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
}

/// Full-feature connection implements all capabilities.
class EnterpriseConnection
    implements
        Connectable,
        Readable,
        Writable,
        Transactional,
        Configurable,
        Queryable {
  bool _connected = false;

  @override
  void connect() {
    _connected = true;
    print('Enterprise connection established');
  }

  @override
  void disconnect() {
    _connected = false;
    print('Enterprise connection closed');
  }

  @override
  bool isConnected() => _connected;

  @override
  Map<String, dynamic>? read(String table, String id) {
    return {'id': id, 'source': 'enterprise'};
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
    print('Enterprise insert into $table');
  }

  @override
  void update(String table, String id, Map<String, dynamic> data) {
    print('Enterprise update $table: $id');
  }

  @override
  void delete(String table, String id) {
    print('Enterprise delete from $table: $id');
  }

  @override
  void bulkInsert(String table, List<Map<String, dynamic>> data) {
    print('Enterprise bulk insert into $table');
  }

  @override
  void beginTransaction() {
    print('Transaction started');
  }

  @override
  void commitTransaction() {
    print('Transaction committed');
  }

  @override
  void rollbackTransaction() {
    print('Transaction rolled back');
  }

  @override
  void setConnectionTimeout(int seconds) {
    print('Timeout set to $seconds seconds');
  }

  @override
  void setMaxConnections(int max) {
    print('Max connections set to $max');
  }

  @override
  void enableSSL(bool enabled) {
    print('SSL enabled: $enabled');
  }

  @override
  void setConnectionPoolSize(int size) {
    print('Pool size set to $size');
  }

  @override
  List<Map<String, dynamic>> executeRawQuery(String sql) {
    print('Executing raw SQL: $sql');
    return [];
  }

  @override
  Map<String, dynamic> executeStoredProcedure(
    String procedure,
    Map<String, dynamic> params,
  ) {
    print('Executing stored procedure: $procedure');
    return {'procedure': procedure, 'params': params};
  }
}
