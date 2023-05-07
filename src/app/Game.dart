import '../models/Card.dart';
import '../helpers/suits.dart';
import '../helpers/faces.dart';
import '../models/Player.dart';
import '../models/Dealer.dart';
import '../services/game.service.dart';

class Game {

  static String? input;
  static List<Card> _deck = [];
  static Player _player = new Player();
  static Dealer _dealer = new Dealer();
  static String _upshot = '—--------';


  static mainLoop() {
    
    _createDeck();
    while(_showMenu()) {      
      _playGame();
    }
  }

  static _createDeck() {
    _deck = [];
    Suits.values.forEach((suit) {
      Faces.values.forEach((face) {
        _deck.add(new Card(suit, face));
      });
    });
  }

  static bool _showMenu() {
    print('Сыграть в blackJack? (y/n)');
    return GameService.form();
  }

  static void _playGame() {    
    _player.clearHand();
    _dealer.clearHand();
    _upshot = '—--------';
    print('\nДиллер мешает колоду...');  
    _deck.shuffle();
    print('\nРаздача:'); 
    _firstDeal();
    _showHands(); 
    if (_firstCheck()) {
      print('\n' + _upshot);
      return;
    }
    while(_player.decide()) {
      _player.addCard(_takeCard(true));
      _showHands();
      if (_winnerCheck()) {
        print('\n' + _upshot);
        return;
      }
    }
    print('\n' + '—--------');
    _dealer.hand[1].openCard();
    while(_dealer.decide()) {
      _dealer.addCard(_takeCard(true));
      _showHands();
      if (_winnerCheck()) {
        print('\n' + _upshot);
        return;
      }
    }
    _lastCheck();
    print('\n' + _upshot);
  }
  
  static void _firstDeal() {
    _dealer.addCard(_takeCard(true));
    if (_dealer.hand[0].weight == 10 || _dealer.hand[0].weight == 11)
      _dealer.addCard(_takeCard(true));
    else
      _dealer.addCard(_takeCard(false));
    _player.addCard(_takeCard(true));
    _player.addCard(_takeCard(true));
  }

  static bool _firstCheck() {
    if (_player.hand[0].weight == 11 && _player.hand[1].weight == 11) {
      _upshot = 'Игрок победил';
      return true;
    }
    if (_dealer.hand[0].weight == 11 && _dealer.hand[1].weight == 11) {
      _upshot = 'Дилер победил';
      return true;
    }
    return _winnerCheck();
  }

  static bool _winnerCheck() {
    int sum;
    sum = GameService.handSum(_player.hand);
    if (sum == 21) {
      _upshot = 'Игрок победил';
      return true;
    }
    if (sum > 21) {
      _upshot = 'Дилер победил';
      return true;
    }
    sum = GameService.handSum(_dealer.hand);
    if (sum == 21) {
      _upshot = 'Дилер победил';
      return true;
    }
    if (sum > 21) {
      _upshot = 'Игрок победил';
      return true;
    }
    return false;
  }

  static void _lastCheck() {
    int psum = 0;
    int dsum = 0;
    _player.hand.forEach((card) {
      psum+= card.weight;
    });
    _dealer.hand.forEach((card) {
      dsum+= card.weight;
    });
    if (psum >= dsum) {
      _upshot = 'Игрок победил';
    } else
      _upshot = 'Дилер победил';
  }

  static Card _takeCard(bool open) {
    Card card = _deck[0];
    _deck.removeAt(0);
    if (open)
      card.openCard();
    return card;
  }

  static void _showHands() {
    print('\nД: ' + _cardsToString(_dealer.hand));     
    print('\nИ: ' + _cardsToString(_player.hand)); 
    print('\n' + '—--------');
  }

  static String _cardsToString(List<Card> cards) {
    String cardsView = '';
    cards.forEach((card) {
      if (card.isOpen)
        cardsView += (card.view + ' ');
      else
        cardsView += '- ';
    });
    return cardsView;
  }
}