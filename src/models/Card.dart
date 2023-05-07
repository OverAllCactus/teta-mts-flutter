import '../helpers/suits.dart';
import '../helpers/faces.dart';

class Card { 
  
  late Suits _suit;
  late Faces _face;
  bool _isOpen = false;

  Card(Suits suit, Faces face) {
    this._suit = suit;
    this._face = face;
  }

  int get weight { 
    switch(_face) {
      case Faces.two: return 2;
      case Faces.three: return 3;
      case Faces.four: return 4;
      case Faces.five: return 5;
      case Faces.six: return 6;
      case Faces.seven: return 7;
      case Faces.eight: return 8;
      case Faces.nine: return 9;
      case Faces.ten:
      case Faces.jack:
      case Faces.queen:
      case Faces.king: return 10;
      case Faces.ace: return 11;
      default: return 0;
    }
  }

  String get view {
    String view = '';
    switch(_face) {
      case Faces.two: view = '2'; break;
      case Faces.three: view = '3'; break;
      case Faces.four: view = '4'; break;
      case Faces.five: view = '5'; break;
      case Faces.six: view = '6'; break;
      case Faces.seven: view = '7'; break;
      case Faces.eight: view = '8'; break;
      case Faces.nine: view = '9'; break;
      case Faces.ten: view = '10'; break;
      case Faces.jack: view = 'J'; break;
      case Faces.queen: view = 'Q'; break;
      case Faces.king: view = 'K'; break;
      case Faces.ace: view = 'A'; break;
      default: return '-';
    }
    switch(_suit) {
      case Suits.hearts: return view + '\u2665'; //'♥️'
      case Suits.spades: return view + '\u2660'; //'♠️'
      case Suits.diamonds: return view + '\u2666'; //'♦️'
      case Suits.clubs: return view + '\u2663'; //'♣️'
    }
  }

  bool get isOpen {
    return _isOpen;
  }

  void openCard() {
    _isOpen = true;
  }
}