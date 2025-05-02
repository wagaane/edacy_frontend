import 'package:flutter/material.dart';
import 'package:task_app/auth/login_page.dart';
import 'back_office/list_task_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {

  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isConnected();
  }

  bool _isConnectedOk = false;
  _isConnected() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = '';
    token = prefs.get("token") as String?;

    if(token != null){
      setState(() {
        _isConnectedOk = true;
      });
    }else{
      setState(() {
        _isConnectedOk = false;
      });
    }

    return false;
  }
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _isConnectedOk ? const ListTaskPage() : const LoginPage()
    );
  }
}

