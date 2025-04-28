import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  //user values
  String displayNameKey = 'displayName';
  String emailKey = 'email';
  String idKey = 'id';
  String photoUrlKey = 'photoUrl';
  String serverAuthCodeKey = 'serverAuthCode';
  String calendarNameKey = 'calendarList';
  String calendarIDKey = 'calendarID';
  String selectedCalKey = 'selectedCal';

  //WRITE TO PREFERENCES

  // sets user values in SharedPreferences
  Future<void> setUser(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(displayNameKey, data.displayName ?? '');
    prefs.setString(emailKey, data.email ?? '');
    prefs.setString(idKey, data.id ?? '');
    prefs.setString(photoUrlKey, data.photoUrl ?? '');
    prefs.setString(serverAuthCodeKey, data.serverAuthCode ?? '');
  }

  // clears user values from SharedPreferences
  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(displayNameKey);
    prefs.remove(emailKey);
    prefs.remove(idKey);
    prefs.remove(photoUrlKey);
    prefs.remove(serverAuthCodeKey);
    prefs.remove(calendarNameKey);
    prefs.remove(calendarIDKey);
    prefs.remove(selectedCalKey);
  }

  // returns user values from SharedPreferences
  Future<Map<String, String>> getUserValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'displayName': prefs.getString(displayNameKey) ?? '',
      'email': prefs.getString(emailKey) ?? '',
      'id': prefs.getString(idKey) ?? '',
      'photoUrl': prefs.getString(photoUrlKey) ?? '',
      'serverAuthCode': prefs.getString(serverAuthCodeKey) ?? '',
    };
  }

  // updates calendar list and ID's in SharedPreferences
  Future<void> setUserCalendarSets(ids, title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setStringList(calendarIDKey, ids);
    prefs.setStringList(calendarNameKey, title);
  }

  // set selected calendar by the user
  Future<void> setSelectedCal(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(selectedCalKey, data);
  }

  //READ FROM PREFERENCES

  Future<String> getEmailKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey) ?? '';
  }

  //returns plaintext calendar list
  Future<List<String>> getCalendarListKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(calendarNameKey) ?? [];
  }

  //returns calendar ID list
  Future<List<String>> getCalendarIDList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(calendarIDKey) ?? [];
  }

  //returns calendar ID for a given calendar name
  Future<String> getCalendarID(String calendarName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> calendarNames = prefs.getStringList(calendarNameKey) ?? [];
    List<String> calendarIDs = prefs.getStringList(calendarIDKey) ?? [];

    int index = calendarNames.indexOf(calendarName);
    if (index != -1 && index < calendarIDs.length) {
      return calendarIDs[index];
    } else {
      throw Exception('Calendar ID not found for the given calendar name.');
    }
  }

  // returns calendar name selected by the user
  Future<String> getSelectedCal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedCalKey) ?? '';
  }

  // adds a new calendar to the list of calendars in SharedPreferences
  addCalendarSetToList(String calendarName, String calendarID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> currentCalList = prefs.getStringList(calendarNameKey) ?? [];
    // Add the new calendar to the list
    currentCalList.add(calendarName);

    List<String> currentCalIDList = prefs.getStringList(calendarIDKey) ?? [];
    // Add the new calendar ID to the list
    currentCalIDList.add(calendarID);

    // Save the updated list back to SharedPreferences
    await prefs.setStringList(calendarNameKey, currentCalList);
    await prefs.setStringList(calendarIDKey, currentCalIDList);
  }

}
