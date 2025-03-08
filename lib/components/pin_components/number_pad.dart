import 'package:domotica_mimmo/customClasses/login_handlers/login_handler.dart';
import 'package:domotica_mimmo/models/login_provider/login_provider.dart';
import 'package:domotica_mimmo/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'keyboard_number.dart';

class NumberPad extends StatelessWidget {
  NumberPad({key});

  final LoginHandler loginHandler = LoginHandler();

  @override
  Widget build(BuildContext context) {
    var loginProvider = Provider.of<LoginProvider>(context, listen: true);
    final LoginHandler loginHandler = LoginHandler();

    return Expanded(
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 1,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '1');
                      }),
                  KeyboardNumber(
                      n: 2,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '2');
                      }),
                  KeyboardNumber(
                      n: 3,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '3');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 4,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '4');
                      }),
                  KeyboardNumber(
                      n: 5,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '5');
                      }),
                  KeyboardNumber(
                      n: 6,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '6');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                      n: 7,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '7');
                      }),
                  KeyboardNumber(
                      n: 8,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '8');
                      }),
                  KeyboardNumber(
                      n: 9,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '9');
                      }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: transparent,
                    width: 60.0,
                    child: FutureBuilder(
                        future: loginHandler.canLoginWithBiometrics(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return MaterialButton(
                              onPressed: () async {
                                await loginHandler.authenticate(
                                    context, loginProvider);
                              },
                              child: Icon(
                                Icons.fingerprint,
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }),
                  ),
                  KeyboardNumber(
                      n: 0,
                      onPressed: () {
                        loginHandler.pinIndexSetup(context, loginProvider, '0');
                      }),
                  Container(
                    color: transparent,
                    width: 60.0,
                    child: MaterialButton(
                      height: 60.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      onPressed: () {
                        loginHandler.clearPin(loginProvider);
                      },
                      child: Icon(
                        Icons.cancel,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
