import 'package:ananasik_nails/constants/styles/icons.dart';
import 'package:ananasik_nails/domain/logic/application_logic.dart';
import 'package:ananasik_nails/presentation/mainScreen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import '../../constants/strings.dart';
import '../../infrastructure/navigation_service.dart';
import '../../presentation/auth_and_registration/registrationScreen/registration_screen.dart';

// General:

String? validatorForEmail(String? val) {
  if (val!.isEmpty) {
    return 'Пожалуйста, заполните это поле';
  } else if (!emailRexExp.hasMatch(val)) {
    return 'Пожалуйста, введите действительный адрес электронной почты';
  } else {
    return null;
  }
}

String? validatorForPassword(String? val) {
  if (val!.isEmpty) {
    return 'Пожалуйста, заполните это поле';
  } else if (!passwordRexExp.hasMatch(val)) {
    return 'Пожалуйста, введите действительный пароль';
  } else {
    return null;
  }
}

bool obscurePassword = true;
IconData iconPassword = eysIcon;

dynamic passwordDisplay() {
  obscurePassword = !obscurePassword;
  if (obscurePassword) {
    iconPassword = eysIcon;
  } else {
    iconPassword = eysOffIcon;
  }
}

// registration_logic:

String? validatorForName(String? val, {TextEditingController? nameController}) {
  List<String?>? words = val!.trim().split(' ');
  if (val.isEmpty) {
    return 'Пожалуйста, заполните это поле';
  } else if (words.length != 3) {
    return 'Пожалуйста, введите полное имя';
  } else {
    return null;
  }
}

bool containsUpperCase = false;
bool containsLowerCase = false;
bool containsNumber = false;
bool containsSpecialChar = false;
bool contains8Length = false;

dynamic passwordVerification(String? val) {
  if (val!.contains(RegExp(r'[A-Z]'))) {
    containsUpperCase = true;
  } else {
    containsUpperCase = false;
  }
  if (val.contains(RegExp(r'[a-z]'))) {
    containsLowerCase = true;
  } else {
    containsLowerCase = false;
  }
  if (val.contains(RegExp(r'[0-9]'))) {
    containsNumber = true;
  } else {
    containsNumber = false;
  }
  if (val.contains(specialCharRexExp)) {
    containsSpecialChar = true;
  } else {
    containsSpecialChar = false;
  }
  if (val.length >= 8) {
    contains8Length = true;
  } else {
    contains8Length = false;
  }
}

// Навигация:
final navigationService = AppInitializer.getIt<NavigationService>();

void navigationToRegistrationScreen() {
  navigationService.navigateTo(RegistrationWidget.routeName);
}

void navigationToMainScreen() {
  navigationService.navigateToNotBack(MainScreen.routeName);
}

void navigationBack() {
  navigationService.goBack();
}
