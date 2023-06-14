import 'package:chat_app/services/database_service.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  
  Future<String?> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString('userId');
    return value;
  }

  Future setUser(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('userId', userId);
  }
}
