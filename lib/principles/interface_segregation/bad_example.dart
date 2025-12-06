/// BAD EXAMPLE: Violates Interface Segregation Principle
/// 
/// A single fat interface forces all implementers to provide methods
/// they may not need or cannot implement.

/// Fat interface - forces all workers to implement all methods
abstract class Worker {
  void work();
  void eat();
  void sleep();
  void code();
  void manage();
  void design();
}

/// Developer doesn't need manage() or design() methods
class Developer implements Worker {
  @override
  void work() {
    print('Developer is working');
  }

  @override
  void eat() {
    print('Developer is eating');
  }

  @override
  void sleep() {
    print('Developer is sleeping');
  }

  @override
  void code() {
    print('Developer is coding');
  }

  // Forced to implement methods that don't apply
  @override
  void manage() {
    // Developer doesn't manage - empty implementation
    throw UnimplementedError('Developers do not manage');
  }

  @override
  void design() {
    // Developer doesn't design - empty implementation
    throw UnimplementedError('Developers do not design');
  }
}

/// Manager doesn't need code() or design() methods
class Manager implements Worker {
  @override
  void work() {
    print('Manager is working');
  }

  @override
  void eat() {
    print('Manager is eating');
  }

  @override
  void sleep() {
    print('Manager is sleeping');
  }

  @override
  void manage() {
    print('Manager is managing');
  }

  // Forced to implement methods that don't apply
  @override
  void code() {
    throw UnimplementedError('Managers do not code');
  }

  @override
  void design() {
    throw UnimplementedError('Managers do not design');
  }
}

/// Designer doesn't need code() or manage() methods
class Designer implements Worker {
  @override
  void work() {
    print('Designer is working');
  }

  @override
  void eat() {
    print('Designer is eating');
  }

  @override
  void sleep() {
    print('Designer is sleeping');
  }

  @override
  void design() {
    print('Designer is designing');
  }

  // Forced to implement methods that don't apply
  @override
  void code() {
    throw UnimplementedError('Designers do not code');
  }

  @override
  void manage() {
    throw UnimplementedError('Designers do not manage');
  }
}

