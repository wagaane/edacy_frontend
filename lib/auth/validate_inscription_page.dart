import 'package:flutter/material.dart';
import 'package:task_app/auth/login_page.dart';
import 'package:task_app/helpers/notification_helper.dart';
import 'package:task_app/models/enums/ResponseStatus.dart';
import 'package:task_app/services/auth_service.dart';
import 'package:task_app/services/otpService.dart';

import '../helpers/color_helper.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ValidateInscriptionPage extends StatefulWidget {
  final String email;

  const ValidateInscriptionPage({super.key, required this.email});

  @override
  State<ValidateInscriptionPage> createState() =>
      _ValidateInscriptionPageState();
}

class _ValidateInscriptionPageState extends State<ValidateInscriptionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(gradient: ColorHelper.gradiant),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Code de vérification".toUpperCase(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: OtpTextField(
                  cursorColor: Colors.black,
                  borderWidth: 3,
                  focusedBorderColor: Colors.black,
                  numberOfFields: 5,
                  borderColor: Colors.black,
                  fillColor: Colors.black,
                  disabledBorderColor: Colors.black,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Validation code OTP"),
                            content: Text('Code saisie : $verificationCode'),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorHelper.blackWithOpacity06,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Annuler",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      padding: const EdgeInsets.all(10),
                                      child: const Text(
                                        "Valider",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ),
                                    onTap: () async {
                                      var data = {
                                        'email': widget.email,
                                        'otp': verificationCode
                                      };
                                      var response =
                                      await OtpService.validateOtp(data);
                                      print(response);
                                      if (response['status'] ==
                                          ResponseStatus.OK.name) {
                                        NotificationHelper.showNotification(
                                          response['message'],
                                        );
                                        Navigator.push<void>(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                            const LoginPage(),
                                          ),
                                        );
                                      } else {
                                        NotificationHelper.showNotification(
                                          status: ResponseStatus.EXCEPTION,
                                          response['message'],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                  }, // end onSubmit
                ),
              ),

            ],
          )),
    );
  }
}
