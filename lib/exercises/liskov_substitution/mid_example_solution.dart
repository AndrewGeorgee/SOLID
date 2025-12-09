/// SOLUTION: Mid - Liskov Substitution Principle
///
/// This solution demonstrates how to apply the Liskov Substitution Principle
/// by using Interface Segregation. ReadOnlyFile can substitute File for reading
/// operations without violating LSP.

/// ============================================================================
/// PART 1: Behavior Interfaces (Interface Segregation)
/// ============================================================================

abstract class Readable {
  String read();
  String get path;
  int getSize();
}

abstract class Writable {
  void write(String content);
}

abstract class Deletable {
  void delete();
}

/// ============================================================================
/// PART 2: File Implementations
/// ============================================================================

/// File implements all interfaces (can read, write, and delete)
class File implements Readable, Writable, Deletable {
  String _content = '';
  final String _path;

  File(this._path);

  @override
  String get path => _path;

  @override
  String read() {
    return _content;
  }

  @override
  void write(String content) {
    _content = content;
    print('Writing to file $_path: $content');
  }

  @override
  void delete() {
    print('Deleting file $_path');
    _content = '';
  }

  @override
  int getSize() {
    return _content.length;
  }
}

/// ReadOnlyFile only implements Readable (cannot write or delete)
/// This follows LSP - ReadOnlyFile can substitute File for reading operations
class ReadOnlyFile implements Readable {
  String _content = '';
  final String _path;

  ReadOnlyFile(this._path);

  @override
  String get path => _path;

  @override
  String read() {
    return _content;
  }

  @override
  int getSize() {
    return _content.length;
  }
}

/// ============================================================================
/// PART 3: Functions that work with interfaces (LSP compliant)
/// ============================================================================

/// Works with any readable file (LSP - accepts any Readable implementation)
void processFile(Readable file) {
  print('Reading from ${file.path}: ${file.read()}');
  print('File size: ${file.getSize()}');
  // Safe - all Readable implementations can read
}

/// Works with any writable file (LSP - accepts any Writable implementation)
void writeToFile(Writable file, String content) {
  file.write(content);
  // Safe - all Writable implementations can write
}

/// Works with any deletable file (LSP - accepts any Deletable implementation)
void deleteFile(Deletable file) {
  file.delete();
  // Safe - all Deletable implementations can delete
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  final file = File('/path/to/file.txt');
  final readOnlyFile = ReadOnlyFile('/path/to/readonly.txt');

  // Example 1: Both File and ReadOnlyFile can be used for reading (LSP)
  processFile(file); // ✅ Works
  processFile(
    readOnlyFile,
  ); // ✅ Works - ReadOnlyFile substitutes File for reading!

  // Example 2: Only File can write (ReadOnlyFile doesn't implement Writable)
  writeToFile(file, 'New content'); // ✅ Works
  // writeToFile(readOnlyFile, 'content'); // ❌ Compile error - ReadOnlyFile doesn't implement Writable

  // Example 3: Only File can delete (ReadOnlyFile doesn't implement Deletable)
  deleteFile(file); // ✅ Works
  // deleteFile(readOnlyFile); // ❌ Compile error - ReadOnlyFile doesn't implement Deletable

  print('\n=== Benefits of this solution ===');
  print('✅ LSP: ReadOnlyFile can substitute File for reading operations');
  print('✅ No exceptions thrown - all implementations are valid');
  print('✅ Type safety - compile-time checking prevents errors');
  print('✅ ISP: Interfaces are segregated by capability');
  print('✅ Functions accept interfaces, ensuring substitutability');
}
