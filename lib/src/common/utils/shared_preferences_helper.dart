import 'package:shared_preferences/shared_preferences.dart';
import '../constants/global_variables.dart';
import '../constants/static_data.dart';

const String isSellerOnboardedText = 'isSellerOnboarded';
const String accessTokenText = 'access_token';

class SharedPrefHelper {
  static late SharedPreferences _prefs;

  static Future<void> getInitialValue() async {
    _prefs = await SharedPreferences.getInstance();
    StaticData.isFirstTime = getBool(isFirstTimeText) ?? true;
    StaticData.isBuyer = getBool(isBuyerText) ?? true;
    StaticData.isSellerOnboarded = getBool(isSellerOnboardedText) ?? false;
    StaticData.email = getString(emailText) ?? '';
    StaticData.accessToken = getString(accessTokenText) ?? '';
  }

  static Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);

    if (key == isBuyerText) {
      StaticData.isBuyer = value;
    }
    if (key == isSellerOnboardedText) {
      StaticData.isSellerOnboarded = value;
    }
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> saveAccessToken(String token) async {
    await saveString(accessTokenText, token);
    StaticData.accessToken = token;
  }

  static String? getAccessToken() {
    return getString(accessTokenText);
  }
}
