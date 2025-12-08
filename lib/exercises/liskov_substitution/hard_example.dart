/// EXERCISE: Hard - Liskov Substitution Principle
///
/// TASK: Refactor this code to follow Liskov Substitution Principle.
/// Currently, ImmutableList and BoundedList cannot properly substitute List
/// because they change the expected behavior of add/remove operations.
///
/// HINT: Consider using composition, or create separate interfaces for
/// mutable and immutable collections. Think about what contracts each
/// collection type should guarantee.

class CustomList<T> {
  final List<T> _items = [];

  void add(T item) {
    _items.add(item);
  }

  void remove(T item) {
    _items.remove(item);
  }

  void clear() {
    _items.clear();
  }

  T? get(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index];
    }
    return null;
  }

  int get length => _items.length;

  List<T> toList() {
    return List.unmodifiable(_items);
  }
}

/// ImmutableList violates LSP because it changes expected behavior
class ImmutableList<T> extends CustomList<T> {
  ImmutableList(List<T> initialItems) {
    _items.addAll(initialItems);
  }

  @override
  void add(T item) {
    throw Exception('Cannot add to immutable list!'); // Breaks LSP!
  }

  @override
  void remove(T item) {
    throw Exception('Cannot remove from immutable list!'); // Breaks LSP!
  }

  @override
  void clear() {
    throw Exception('Cannot clear immutable list!'); // Breaks LSP!
  }
}

/// BoundedList violates LSP because it changes expected behavior
class BoundedList<T> extends CustomList<T> {
  final int _maxSize;

  BoundedList(this._maxSize);

  @override
  void add(T item) {
    if (_items.length >= _maxSize) {
      throw Exception('List is full! Maximum size: $_maxSize'); // Breaks LSP!
    }
    super.add(item);
  }
}

/// Function expecting CustomList behavior but breaks with subclasses
void manipulateList(CustomList<String> list) {
  list.add('Item 1');
  list.add('Item 2');
  list.add('Item 3');
  // This will fail with ImmutableList or BoundedList!

  list.remove('Item 2');
  // This will fail with ImmutableList!

  print('List length: ${list.length}');
}
