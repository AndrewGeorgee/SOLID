abstract class Eat {
  void eat();
}

abstract class Sleep {
  void sleep();
}

abstract class Work {
  void work();
}

class HumanWorker implements Eat, Sleep, Work {
  @override
  void eat() {
    print('Human is eating...');
  }

  @override
  void sleep() {
    print('Human is sleeping...');
  }

  @override
  void work() {
    print('Human is working...');
  }
}

class RobotWorker implements Work {
  @override
  void work() {
    print('Robot is working...');
  }
}
