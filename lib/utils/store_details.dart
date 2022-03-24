import 'package:shared_preferences/shared_preferences.dart';

class StoreDetails
{
  static const isUserLinkedInLoggedIn = 'isUserLinkedInLoggedIn';
  static const isUserFacebookLoggedIn = 'isUserFacebookLoggedIn';

  static SharedPreferences? _prefsInstance;
  static Future<SharedPreferences> get _instance async => _prefsInstance ??= await SharedPreferences.getInstance();
  static Future<SharedPreferences> init() async
  {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static bool checkLinkedInLoginSession(String key)
  {
    return _prefsInstance?.getBool(key) ?? false;
  }

  static Future<bool> createLinkedInLoginSession() async{
    var prefs = await _instance;
    return prefs.setBool(isUserLinkedInLoggedIn, true);
  }

  static bool checkFacebookLoginSession(String key)
  {
    return _prefsInstance?.getBool(key) ?? false;
  }

  static Future<bool> createFacebookLoginSession() async{
    var prefs = await _instance;
    return prefs.setBool(isUserFacebookLoggedIn, true);
  }

  static callLinkedInLogout()
  {
    _prefsInstance?.remove(isUserLinkedInLoggedIn);
  }

  static callFacebookLogout()
  {
    _prefsInstance?.remove(isUserFacebookLoggedIn);
  }
}