import 'Card.dart';

abstract class Person {

  List<Card> _hand = [];

  List<Card> get hand {
    return _hand;
  }

  void clearHand() {
    _hand = [];
  }

  void addCard(Card card) {
    hand.add(card);
  }

  bool decide();
 }