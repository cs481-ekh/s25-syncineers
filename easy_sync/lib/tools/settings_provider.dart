import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {

  //user values
  String displayNameKey = 'displayName';
  String emailKey = 'email';
  String idKey = 'id';
  String photoUrlKey = 'photoUrl';
  String serverAuthCodeKey = 'serverAuthCode';

  //late List<String> calendarListKey;

  String calendarNameKey = 'calendarList';
  String calendarIDKey = 'calendarID';

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
    prefs.remove(calendarNameKey);
    prefs.remove(calendarIDKey);
    prefs.remove(selectedCalKey);
  }

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

  //maybe change to a map? for claendar set summary and id
  Future<void> setUserCalendarSets(ids, title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // print("DATA: $data");
    // print("TYPE: ${data.runtimeType}");

    prefs.setStringList(calendarIDKey, ids);
    prefs.setStringList(calendarNameKey, title);

   // print("KEY PRINT: $calendarListKey");
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

  //returns plaintext calendar list
  Future<List<String>> getCalendarListKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(calendarNameKey) ?? [];
   // return prefs.getStringList(calendarNameKey) ?? '';
  }

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

  Future<String> getSelectedCal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(selectedCalKey) ?? '';
  }

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
