import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_app/auth/login_page.dart';
import 'package:task_app/auth/validate_inscription_page.dart';
import 'package:task_app/models/enums/ResponseStatus.dart';
import 'package:task_app/widgets/register_and_connexion_button_widget.dart';
import '../back_office/list_task_page.dart';
import '../helpers/color_helper.dart';
import '../helpers/notification_helper.dart';
import '../models/api_response_model.dart';
import '../services/auth_service.dart';
import '../widgets/asset_image_widget.dart';
import '../widgets/login_container_widget.dart';

class RegisterPage extends StatefulWidget {

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _prenom = TextEditingController();
  final _nom = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //
        body: SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(gradient: ColorHelper.gradiant),
          child: !_isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                    ),
                    const AssetImageWidget(
                        image: 'logo.png', width: 150, height: 150),
                    Text(
                      "inscription".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    LoginContainerWidget(
                      controller: _prenom,
                      labelText: 'Prénom',
                      hintText: 'Prénom',
                      prefixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LoginContainerWidget(
                      controller: _nom,
                      labelText: 'Nom',
                      hintText: 'Nom',
                      prefixIcon: const Icon(Icons.person_2_outlined),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LoginContainerWidget(
                      controller: _username,
                      labelText: 'Email',
                      hintText: 'Email',
                      prefixIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    LoginContainerWidget(
                      controller: _password,
                      labelText: 'Mot de passe',
                      hintText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          if (_username.text.isEmpty ||
                              _password.text.isEmpty ||
                              _prenom.text.isEmpty ||
                              _nom.text.isEmpty) {
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
                                "prenom": _prenom.text,
                                "nom": _nom.text,
                                "email": _username.text.trim(),
                                "password": _password.text.trim()
                              };

                              var response = await AuthService.register(data);
                              if(response['data']['status'] == ResponseStatus.OK.name){
                                NotificationHelper.showNotification(
                                    response['data']['message'],
                                    );
                                Navigator. push<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>  ValidateInscriptionPage(email: _username.text,),
                                  ),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }else{
                                NotificationHelper.showNotification(
                                    response['data']['message'],status: ResponseStatus.EXCEPTION.name,
                                    );
                                setState(() {
                                  _isLoading = false;
                                });
                              }

                            }
                          }
                        },
                        child: const RegisterAndConnexionButtonWidget(
                          textColor: Colors.white,
                          backgroundButton: Colors.black,
                          textButton: "S'inscrire",
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                        onTap: () async {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const LoginPage(),
                            ),
                          );
                        },
                        child: const RegisterAndConnexionButtonWidget(
                          fontSize: 12.0,
                          textColor: Colors.black,
                          backgroundButton: Colors.black12,
                          textButton: "vous avez déjà un compte, se connecter",
                        ))
                  ],
                )
              : const SpinKitFadingCircle(
                  color: Colors.black,
                  size: 50.0,
                )),
    )

        // : SpinKitFadingCircle(color: Colors.white, size: 50.0)
        );
  }
}
