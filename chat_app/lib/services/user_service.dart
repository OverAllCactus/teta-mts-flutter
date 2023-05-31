import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  
  Future<String?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString('userId');
    return value;
  }

  String createUser() {
    const uuid = Uuid();
    String userId = uuid.v4();
    return userId;
  }

  Future setUser(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userId', userId);
  }

  Future checkUser() async {
    String? userFromService = await getUser();
    if (userFromService == null) {
      setUser(createUser());
    }
  }
}
