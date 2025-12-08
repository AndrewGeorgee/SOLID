/// EXERCISE: Mid - Liskov Substitution Principle
///
/// TASK: Refactor this code to follow Liskov Substitution Principle.
/// Currently, ReadOnlyFile cannot properly substitute File because it
/// changes the expected behavior of write operations.
///
/// HINT: Consider using composition over inheritance, or create separate
/// interfaces for readable and writable files.

class File {
  String _content = '';
  String _path;

  File(this._path);

  String get path => _path;

  String read() {
    return _content;
  }

  void write(String content) {
    _content = content;
    print('Writing to file $_path: $content');
  }

  void delete() {
    print('Deleting file $_path');
    _content = '';
  }

  int getSize() {
    return _content.length;
  }
}

/// ReadOnlyFile violates LSP because it changes expected behavior
class ReadOnlyFile extends File {
  ReadOnlyFile(super.path);

  @override
  void write(String content) {
    throw Exception('Cannot write to read-only file!'); // Breaks LSP!
  }

  @override
  void delete() {
    throw Exception('Cannot delete read-only file!'); // Breaks LSP!
  }
}

/// Function expecting File behavior but breaks with ReadOnlyFile
void processFile(File file) {
  file.write('New content'); // This will throw exception with ReadOnlyFile!
  print('File size: ${file.getSize()}');
}
