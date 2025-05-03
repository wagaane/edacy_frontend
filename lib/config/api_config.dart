import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig{
  static String API_URL = "http://localhost:8000/api/v1/";
  // static String API_URL = "http://192.168.100.38:8000/api/v1/";
  // static String API_URL = "http://192.168.1.147:8000/api/v1/";

  static getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.get('token');
  }
}