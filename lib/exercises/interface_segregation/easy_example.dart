/// EXERCISE: Easy - Interface Segregation Principle
///
/// TASK: Refactor this code to follow Interface Segregation Principle.
/// Currently, Worker interface forces all classes to implement methods they don't need.
///
/// HINT: Split the large interface into smaller, focused interfaces.
/// Not all workers need to eat, sleep, and work - create separate interfaces.

abstract class Worker {
  // All workers must implement all methods, even if they don't need them
  void work();
  void eat();
  void sleep();
}

/// Human worker needs all methods
class HumanWorker implements Worker {
  @override
  void work() {
    print('Human is working...');
  }

  @override
  void eat() {
    print('Human is eating...');
  }

  @override
  void sleep() {
    print('Human is sleeping...');
  }
}

/// Robot worker doesn't need eat() or sleep(), but is forced to implement them
class RobotWorker implements Worker {
  @override
  void work() {
    print('Robot is working...');
  }

  @override
  void eat() {
    // Robot doesn't eat! Forced to implement empty method
    throw Exception('Robots do not eat!');
  }

  @override
  void sleep() {
    // Robot doesn't sleep! Forced to implement empty method
    throw Exception('Robots do not sleep!');
  }
}
