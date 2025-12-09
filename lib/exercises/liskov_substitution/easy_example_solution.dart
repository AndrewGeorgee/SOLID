/// SOLUTION: Easy - Liskov Substitution Principle
///
/// This solution demonstrates how to apply the Liskov Substitution Principle
/// by using Interface Segregation. Not all birds can fly, so we separate
/// behaviors into different interfaces.

/// ============================================================================
/// PART 1: Behavior Interfaces (Interface Segregation)
/// ============================================================================

abstract class Eat {
  void eat();
}

abstract class Fly {
  void fly();
}

abstract class MakeSound {
  void makeSound();
}

/// ============================================================================
/// PART 2: Bird Implementations
/// ============================================================================

/// Bird implements all behaviors (can eat, fly, and make sound)
class Bird implements Eat, Fly, MakeSound {
  @override
  void eat() {
    print('Bird is eating...');
  }

  @override
  void fly() {
    print('Bird is flying...');
  }

  @override
  void makeSound() {
    print('Chirping...');
  }
}

/// Penguin only implements Eat and MakeSound (cannot fly)
/// This follows LSP - Penguin can substitute Bird for eating operations
class Penguin implements Eat, MakeSound {
  @override
  void eat() {
    print('Penguin is eating...');
  }

  @override
  void makeSound() {
    print('Honking...');
  }
}

/// ============================================================================
/// PART 3: Functions that work with interfaces (LSP compliant)
/// ============================================================================

/// Works with any animal that can fly (LSP - accepts any Fly implementation)
void makeAnimalFly(Fly flyer) {
  flyer.fly(); // Safe - all Fly implementations can fly
}

/// Works with any animal that can eat (LSP - accepts any Eat implementation)
void makeAnimalEat(Eat eater) {
  eater.eat(); // Safe - all Eat implementations can eat
}

/// Works with any animal that can make sound (LSP - accepts any MakeSound implementation)
void makeAnimalMakeSound(MakeSound soundMaker) {
  soundMaker.makeSound(); // Safe - all MakeSound implementations can make sound
}

/// ============================================================================
/// USAGE EXAMPLES
/// ============================================================================

void main() {
  final bird = Bird();
  final penguin = Penguin();

  // Example 1: Both Bird and Penguin can eat (LSP - substitutable for eating)
  makeAnimalEat(bird); // ✅ Works
  makeAnimalEat(penguin); // ✅ Works - Penguin substitutes Bird for eating!

  // Example 2: Only Bird can fly (Penguin doesn't implement Fly)
  makeAnimalFly(bird); // ✅ Works
  // makeAnimalFly(penguin); // ❌ Compile error - Penguin doesn't implement Fly

  // Example 3: Both can make sound
  makeAnimalMakeSound(bird); // ✅ Works
  makeAnimalMakeSound(penguin); // ✅ Works

  print('\n=== Benefits of this solution ===');
  print('✅ LSP: Penguin can substitute Bird for eating operations');
  print('✅ No exceptions thrown - all implementations are valid');
  print('✅ Type safety - compile-time checking prevents errors');
  print('✅ ISP: Interfaces are segregated by behavior');
}
