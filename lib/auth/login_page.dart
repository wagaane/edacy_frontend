import 'package:flutter/material.dart';
import 'package:task_app/auth/register_page.dart';
import 'package:task_app/helpers/color_helper.dart';
import 'package:task_app/helpers/notification_helper.dart';
import 'package:task_app/models/enums/ResponseStatus.dart';
import 'package:task_app/services/auth_service.dart';
import 'package:task_app/widgets/asset_image_widget.dart';
import 'package:task_app/widgets/register_and_connexion_button_widget.dart';
import '../back_office/list_task_page.dart';
import '../widgets/login_container_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: ColorHelper.gradiant),
          child:
          Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const AssetImageWidget(
                        image: 'logo.png', width: 150, height: 150),
                    _isLoading ? const SpinKitFadingCircle(
                      color: Colors.black,
                      size: 50.0,
                    ): Container(),
                    !_isLoading ? Text(
                      "Authentification".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ): Center(),
                    !_isLoading ? const SizedBox(
                      height: 15,
                    ): Center(),
                    !_isLoading ? LoginContainerWidget(
                      controller: _username,
                      labelText: 'Email',
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.person),
                    ): Center(),
                    !_isLoading ? const SizedBox(
                      height: 10,
                    ): Center(),
                    !_isLoading ? LoginContainerWidget(
                      obscureText: true,
                      controller: _password,
                      labelText: 'Mot de passe',
                      hintText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock),
                    ): Center(),
                    !_isLoading ? const SizedBox(
                      height: 10,
                    ): Center(),
                    !_isLoading ? GestureDetector(
                      onTap: () async {
                        if (_username.text.isEmpty || _password.text.isEmpty) {
                          NotificationHelper.showNotification(
                              "Veuillez renseigner tous les champs svp.",
                              );
                        } else {
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(_username.text)) {
                            NotificationHelper.showNotification(
                                "Veuillez renseigner un email valide svp.",
                                );
                          } else {
                            setState(() {
                              _isLoading = true;
                            });

                            var data = {
                              "login": _username.text.trim(),
                              "password": _password.text.trim()
                            };

                            var response = await AuthService.login(data);
                            print(response);
                            if (response['data']['status'] ==
                                ResponseStatus.OK.name) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString("token",
                                  response['data']['payload']['token']);
                              prefs.setString("username",
                                  response['data']['payload']['username']);
                              setState(() {
                                _isLoading = false;
                              });
                              NotificationHelper.showNotification(
                                  response['data']['message'],
                                  );
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ListTaskPage(),
                                ),
                              );
                            } else {
                              NotificationHelper.showNotification(
                                  status: ResponseStatus.EXCEPTION.name,
                                  response['data']['message'],
                                  );
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                        }
                      },
                      child: const RegisterAndConnexionButtonWidget(
                        backgroundButton: Colors.black,
                        textButton: "se connecter",
                        textColor: Colors.white,
                      ),
                    ): Center(),
                    !_isLoading ? const SizedBox(
                      height: 5,
                    ): Center(),
                    !_isLoading ?
                    GestureDetector(
                      onTap: () async {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                            const RegisterPage(),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(5.0))),
                        child: const Center(
                          child: Text("S'inscrire"),
                        ),
                      ),
                    ): Center()
                  ],
                )

                  ),
    ),);
  }
}
