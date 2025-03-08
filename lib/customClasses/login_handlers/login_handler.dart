import 'package:domotica_mimmo/models/login_provider/login_provider.dart';
import 'package:domotica_mimmo/screens/SpaziScreen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_android/local_auth_android.dart';
// ignore: depend_on_referenced_packages
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHandler {
  Future<bool> initLoginPage(BuildContext context) async {
    await initPin(context);
    if (context.mounted) {
      //richiedo subito autenticazione biometrica se è possibile
      await autoAuthentication(context);
    }
    return true;
  }

  initPin(BuildContext context) async {
    var loginProvider = Provider.of<LoginProvider>(context, listen: false);

    String pinSalvato = await getCredentials(loginProvider, 'pin');
    if (pinSalvato == '') {
      loginProvider.updatePinSalvato(loginProvider.defaultPin);
    } else {
      loginProvider.updatePinSalvato(pinSalvato);
    }
  }

  autoAuthentication(BuildContext context) async {
    var loginProvider = Provider.of<LoginProvider>(context, listen: false);

    bool canLogin = await canLoginWithBiometrics();
    if (canLogin && context.mounted) {
      await authenticate(context, loginProvider);
    }
  }

  /// pin salvato in locale
  void setCredentials(String pin) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pin', pin);
  }

  Future<String> getCredentials(LoginProvider provider, String tag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(tag) ?? provider.defaultPin;
  }

  ///autenticazione biometrica
  void setFirstLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_login', "1");
  }

  Future<String?> getFirstLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('first_login');
  }

  Future<bool> canLoginWithBiometrics() async {
    //posso fare login biometrico se ho già eseguito l'accesso una volta all'app e ho il sensore
    bool firstLoginDone = await getFirstLogin() != null;
    bool hasBio = await hasBiometrics();

    return firstLoginDone && hasBio;
  }

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> hasBiometrics() async {
    final isAvailable = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  Future<bool> authenticate(
      BuildContext context, LoginProvider provider) async {
    final isAuthAvailable = await canLoginWithBiometrics();
    if (!isAuthAvailable) return false;
    try {
      bool success = await _auth.authenticate(
        localizedReason: 'Autenticazione biometrica',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Accesso',
            biometricHint: "",
            cancelButton: 'Annulla',
          ),
          IOSAuthMessages(
            cancelButton: 'Annulla',
          ),
        ],
        options: AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      //accesso
      if (success && context.mounted) {
        loginSuccess(context, provider);
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  clearPin(LoginProvider provider) {
    if (provider.pinIndex == 0) {
      provider.updatePinIndex(0);
    } else if (provider.pinIndex == 4) {
      setPin(provider, provider.pinIndex, "");
      provider.updateCurrentPinAtIndex(provider.pinIndex - 1, "");
      provider.updatePinIndex(provider.pinIndex - 1);
    } else {
      setPin(provider, provider.pinIndex, "");
      provider.updateCurrentPinAtIndex(provider.pinIndex - 1, "");
      provider.updatePinIndex(provider.pinIndex - 1);
    }
  }

  clearPad(LoginProvider provider) {
    for (int num = 1; num <= 4; num++) {
      setPin(provider, num, "");
      provider.updateCurrentPinAtIndex(num - 1, "");
    }
    provider.updatePinIndex(0);
  }

  loginSuccess(BuildContext context, LoginProvider provider) {
    provider.updateAvvisoAccesso('Benvenuto');
    clearPad(provider);
    //accesso eseguito con successo
    setFirstLogin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SpaziScreen();
        },
      ),
    );
  }

  pinIndexSetup(
      BuildContext context, LoginProvider provider, String text) async {
    if (provider.pinIndex == 0) {
      provider.updatePinIndex(1);
    } else if (provider.pinIndex < 4) {
      provider.updatePinIndex((provider.pinIndex) + 1);
    }

    setPin(provider, provider.pinIndex, text);
    provider.updateCurrentPinAtIndex(provider.pinIndex - 1, text);
    String strPin = "";
    for (var e in provider.currentPin) {
      strPin += e;
    }
    if (provider.pinIndex == 4) {
      //verificare pin
      if (provider.modalitaCorrente == Modalita.accesso) {
        if (strPin == provider.pinSalvato) {
          loginSuccess(context, provider);
        } else {
          provider.updateAvvisoAccesso('Il pin inserito non è corretto');
          clearPad(provider);
        }
        print('pin salvato ${provider.pinSalvato}');
        print('il pin è: $strPin');
      } else if (provider.modalitaCorrente == Modalita.insertOldPin) {
        if (strPin == provider.pinSalvato) {
          provider.updateAvvisoAccesso('Inserisci il nuovo pin');
          clearPad(provider);
          provider.updateModalitaPin(Modalita.insertNewPin);
        } else {
          provider.updateAvvisoAccesso('Il pin inserito non è corretto');
          clearPad(provider);
        }
      } else if (provider.modalitaCorrente == Modalita.insertNewPin) {
        setCredentials(strPin);
        initPin(context);

        clearPad(provider);
        provider.updateModalitaPin(Modalita.accesso);
        provider.updateAvvisoAccesso('Pin di accesso');
      }
    }
  }

  setPin(LoginProvider provider, int n, String text) {
    switch (n) {
      case 1:
        provider.pinOneController.text = text;
        break;
      case 2:
        provider.pinTwoController.text = text;
        break;
      case 3:
        provider.pinThreeController.text = text;
        break;
      case 4:
        provider.pinFourController.text = text;
        break;
    }
  }
}
