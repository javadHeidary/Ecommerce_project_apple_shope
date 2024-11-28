import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/di/di.dart';

class AuthManagment {
  static final SharedPreferences _sharedPref = locator.get<SharedPreferences>();

  static void saveToken(String token) {
    _sharedPref.setString('access_token', token);
  }

  static String readToken() {
    String token = _sharedPref.getString('access_token') ?? '';
    return token;
  }

  static void saveUserId(String userId) {
    _sharedPref.setString('user_Id', userId);
  }

  static String getUserId() {
    String userId = _sharedPref.getString('user_Id') ?? '';
    return userId;
  }

  static void logout() {
    _sharedPref.clear();
  }

  static bool isLogin() {
    String token = readToken();
    return token.isNotEmpty;
  }
}
