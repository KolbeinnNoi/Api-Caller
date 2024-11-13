
import 'dart:math';

int sum(int a , int b) {
return a + b;
}

class Dice {
  int sides;

  Dice({this.sides = 6});

  int rollTheDice() {
    var random = Random();
    return random.nextInt(sides) + 1;
  }
}