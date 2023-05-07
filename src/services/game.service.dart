import '../models/Card.dart';
import 'dart:io';

class GameService {

  static int handSum(List<Card> cards) {
    int sum = 0;
    int aceCount = 0;
    cards.forEach((card) {
      sum+= card.weight;
      if (card.weight == 11)
        aceCount++;
    }); 
    while(sum > 21 && aceCount > 0) {
      sum = sum - 10;
      aceCount--;
    } 
    return sum;
  }
  
  static bool form() {
    String? input = '';
    while(input != 'y' && input !='n')
      input = stdin.readLineSync();
    if (input == 'y')
      return true;
    return false;
  }  
}