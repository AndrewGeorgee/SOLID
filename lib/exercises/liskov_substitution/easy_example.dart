/// EXERCISE: Easy - Liskov Substitution Principle
///
/// TASK: Refactor this code to follow Liskov Substitution Principle.
/// Currently, Penguin cannot properly substitute Bird because it cannot fly.
///
/// HINT: Create separate interfaces/abstract classes for different behaviors.
/// Not all birds can fly, so don't make flying a requirement of the base Bird class.

class Bird {
  void fly() {
    print('Flying...');
  }

  void eat() {
    print('Eating...');
  }

  void makeSound() {
    print('Chirping...');
  }
}

/// Penguin cannot fly, so it violates LSP when substituted for Bird
class Penguin extends Bird {
  @override
  void fly() {
    throw Exception('Penguins cannot fly!'); // Breaks LSP!
  }

  @override
  void makeSound() {
    print('Honking...');
  }
}

/// Function that expects Bird behavior but breaks with Penguin
void makeBirdFly(Bird bird) {
  bird.fly(); // This will throw exception with Penguin!
}
