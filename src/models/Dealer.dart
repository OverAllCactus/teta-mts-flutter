import 'Person.dart';
import '../services/game.service.dart';

class Dealer extends Person {
  
  @override
  bool decide() {
    print('\nХод Дилера:');
    if (GameService.handSum(hand) < 17)
      return true;
    print('\nДилер - ПАС');
    return false;
  }
}