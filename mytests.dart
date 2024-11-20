import 'package:test/test.dart';
import 'codetotest.dart';

void main() {
  group('MyTests', () {
    test('Add Two Numbers', () {
      expect(sum(10,5), 15);
    });
  });
  group('Testing My Dice', () {
    test('Has the dice been hacked?', () {
      Dice myDice = Dice();
      List<int> myDiceList = [];
      for(int i=0; i <= 100; i++) {
        myDiceList.add(myDice.rollTheDice());
      }
      expect(myDiceList, contains(1));
      expect(myDiceList, contains(2));
      expect(myDiceList, contains(3));
      expect(myDiceList, contains(4));
      expect(myDiceList, contains(5));
      expect(myDiceList, contains(6));
      print(myDiceList);
    });
  });

}
