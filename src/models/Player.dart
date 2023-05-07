import 'Person.dart';
import '../services/game.service.dart';

class Player extends Person {

  @override
  bool decide() {
    print('\nХод Игрока (y - Взять, n - Пас):');  
    return GameService.form();
  }
}