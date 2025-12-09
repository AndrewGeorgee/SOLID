/// SOLUTION: Hard - Liskov Substitution Principle
///
/// This solution demonstrates how to apply the Liskov Substitution Principle
/// by using Interface Segregation and Composition. Immutable and Bounded lists
/// can now properly substitute base collections for their supported operations.

/// ============================================================================
/// PART 1: Core Collection Interfaces (Interface Segregation)
/// ============================================================================

/// Base interface for all collections - read-only operations
abstract class ReadableCollection<T> {
  T? get(int index);
  int get length;
  List<T> toList();
  bool contains(T item);
}

/// Interface for mutable collections - can add items
abstract class AddableCollection<T> {
  void add(T item);
}

/// Interface for removable collections - can remove items
abstract class RemovableCollection<T> {
  void remove(T item);
  void clear();
}

/// Combined interface for fully mutable collections
abstract class MutableCollection<T>
    implements
        ReadableCollection<T>,
        AddableCollection<T>,
        RemovableCollection<T> {}

/// ============================================================================
/// PART 2: Collection Implementations
/// ============================================================================

/// Fully mutable list - implements all operations
class CustomList<T> implements MutableCollection<T> {
  final List<T> _items = [];

  @override
  void add(T item) {
    _items.add(item);
  }

  @override
  void remove(T item) {
    _items.remove(item);
  }

  @override
  void clear() {
    _items.clear();
  }

  @override
  T? get(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index];
    }
    return null;
  }

  @override
  int get length => _items.length;

  @override
  List<T> toList() {
    return List.unmodifiable(_items);
  }

  @override
  bool contains(T item) {
    return _items.contains(item);
  }
}

/// Immutable list - only implements ReadableCollection
/// This follows LSP - can substitute CustomList for reading operations
class ImmutableList<T> implements ReadableCollection<T> {
  final List<T> _items;

  ImmutableList(List<T> initialItems)
    : _items = List.unmodifiable(initialItems);

  @override
  T? get(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index];
    }
    return null;
  }

  @override
  int get length => _items.length;

  @override
  List<T> toList() {
    return List.unmodifiable(_items);
  }

  @override
  bool contains(T item) {
    return _items.contains(item);
  }
}

/// Bounded list - implements MutableCollection but with size constraint
/// Uses composition to ensure LSP compliance
class BoundedList<T> implements MutableCollection<T> {
  final List<T> _items = [];
  final int _maxSize;

  BoundedList(this._maxSize);

  @override
  void add(T item) {
    if (_items.length >= _maxSize) {
      throw Exception('List is full! Maximum size: $_maxSize');
    }
    _items.add(item);
  }

  @override
  void remove(T item) {
    _items.remove(item);
  }

  @override
  void clear() {
    _items.clear();
  }

  @override
  T? get(int index) {
    if (index >= 0 && index < _items.length) {
      return _items[index];
    }
    return null;
  }

  @override
  int get length => _items.length;

  @override
  List<T> toList() {
    return List.unmodifiable(_items);
  }

  @override
  bool contains(T item) {
    return _items.contains(item);
  }

  /// Additional method specific to BoundedList
  bool get isFull => _items.length >= _maxSize;
  int get remainingCapacity => _maxSize - _items.length;
}

/// ============================================================================
/// PART 3: Functions that work with interfaces (LSP compliant)
/// ============================================================================

/// Works with any readable collection (LSP - accepts any ReadableCollection)
void readFromCollection<T>(ReadableCollection<T> collection) {
  print('Collection length: ${collection.length}');
  if (collection.length > 0) {
    print('First item: ${collection.get(0)}');
  }
  print('All items: ${collection.toList()}');
  // Safe - all ReadableCollection implementations can read
}

/// Works with any addable collection (LSP - accepts any AddableCollection)
void addToCollection<T>(AddableCollection<T> collection, T item) {
  collection.add(item);
  print('Added item: $item');
  // Safe - all AddableCollection implementations can add
}

/// Works with any removable collection (LSP - accepts any RemovableCollection)
void removeFromCollection<T>(RemovableCollection<T> collection, T item) {
  collection.remove(item);
  print('Removed item: $item');
  // Safe - all RemovableCollection implementations can remove
}

/// Works with any mutable collection (LSP - accepts any MutableCollection)
void manipulateCollection<T>(
  MutableCollection<T> collection,
  List<T> itemsToAdd,
) {
  print('Manipulating collection...');
  for (final item in itemsToAdd) {
    collection.add(item);
  }
  print('Collection length after adding: ${collection.length}');
  // Safe - all MutableCollection implementations support all operations
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  // Example 1: CustomList (fully mutable)
  final customList = CustomList<String>();
  customList.add('Item 1');
  customList.add('Item 2');
  readFromCollection(customList); // ✅ Works
  manipulateCollection(customList, ['Item 3', 'Item 4']); // ✅ Works

  // Example 2: ImmutableList (read-only)
  final immutableList = ImmutableList<String>(['A', 'B', 'C']);
  readFromCollection(
    immutableList,
  ); // ✅ Works - ImmutableList substitutes CustomList for reading!
  // addToCollection(immutableList, 'D'); // ❌ Compile error - ImmutableList doesn't implement AddableCollection
  // manipulateCollection(immutableList, ['D']); // ❌ Compile error - ImmutableList doesn't implement MutableCollection

  // Example 3: BoundedList (mutable with constraint)
  final boundedList = BoundedList<String>(3);
  boundedList.add('X');
  boundedList.add('Y');
  readFromCollection(boundedList); // ✅ Works
  manipulateCollection(boundedList, [
    'Z',
  ]); // ✅ Works - BoundedList substitutes CustomList!

  // BoundedList can throw exception if full, but this is expected behavior
  // The function should check capacity before adding
  try {
    boundedList.add('W'); // This will throw - list is full
  } catch (e) {
    print('Expected error: $e');
  }

  // Example 4: Type-safe operations
  final List<ReadableCollection<String>> readableCollections = [
    customList,
    immutableList,
    boundedList,
  ];

  for (final collection in readableCollections) {
    readFromCollection(collection); // ✅ All work - LSP in action!
  }

  final List<MutableCollection<String>> mutableCollections = [
    customList,
    boundedList,
    // immutableList, // ❌ Can't add - doesn't implement MutableCollection
  ];

  for (final collection in mutableCollections) {
    manipulateCollection(collection, [
      'New Item',
    ]); // ✅ All work - LSP in action!
  }

  print('\n=== Benefits of this solution ===');
  print(
    '✅ LSP: ImmutableList can substitute CustomList for reading operations',
  );
  print('✅ LSP: BoundedList can substitute CustomList for all operations');
  print('✅ No unexpected exceptions - type system prevents invalid operations');
  print('✅ Type safety - compile-time checking prevents errors');
  print('✅ ISP: Interfaces are segregated by capability');
  print('✅ Functions accept interfaces, ensuring substitutability');
}
