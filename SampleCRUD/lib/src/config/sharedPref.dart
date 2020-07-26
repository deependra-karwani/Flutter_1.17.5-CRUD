import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _prefs;

class MyPreferences {
	static void initPref() async {
		_prefs = await SharedPreferences.getInstance();
	}

	static void saveSingle(key, value) async {
		_prefs.setString(key, value);
	}

	static void removeAll() async {
		_prefs.clear();
	}

	static void removeSingle(key) async {
		_prefs.remove(key);
	}

	static String getSingle(key) {
		// return _prefs.get(key);
		return _prefs.getString(key);
	}

  static bool exists(key) {
		// return _prefs.get(key) != null;
		return _prefs.getString(key) ?? '' != '';
	}
}