import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';


class SharedPreferencesManager {

  String displayNameKey = 'displayName';
  String emailKey = 'email';
  String idKey = 'id';
  String photoUrlKey = 'photoUrl';
  String serverAuthCodeKey = 'serverAuthCode';

  //late List<String> calendarListKey;

  String calendarListKey = 'calendarList';

  String selectedCalKey = 'selectedCal';

  //WRITE TO PREFERENCES

  Future<void> setUser(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(displayNameKey, data.displayName ?? '');
    prefs.setString(emailKey, data.email ?? '');
    prefs.setString(idKey, data.id ?? '');
    prefs.setString(photoUrlKey, data.photoUrl ?? '');
    prefs.setString(serverAuthCodeKey, data.serverAuthCode ?? '');
  }

  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(displayNameKey);
    prefs.remove(emailKey);
    prefs.remove(idKey);
    prefs.remove(photoUrlKey);
    prefs.remove(serverAuthCodeKey);
  }

  //maybe change to a map? for claendar set summary and id
  Future<void> setUserCalendarSets(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print("DATA: $data");
    print("TYPE: ${data.runtimeType}");

    prefs.setStringList(calendarListKey, data);

    print("KEY PRINT: $calendarListKey");
  }

  Future<void> setSelectedCal(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(selectedCalKey, data);
  }

  //READ FROM PREFERENCES

  Future<String> getEmailKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey) ?? '';
  }

//changed from object to string?
  Future<Object> getCalendarList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(calendarListKey) ?? '';
  }

  Future<String> getSelectedCal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedCalKey) ?? '';
  }

}
