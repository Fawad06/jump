import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  static late SharedPreferences pref;
  Future initialize() async {
    pref = await SharedPreferences.getInstance();
  }
}
