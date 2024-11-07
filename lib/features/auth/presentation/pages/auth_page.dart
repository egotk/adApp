import 'package:actonica/features/auth/presentation/pages/login_page.dart';
import 'package:actonica/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // изначально страница логина
  bool showLoginPage = true;

  // простая валидация
  bool validatePhoneNumber(String phoneNumber) {
    return RegExp(
            r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)')
        .hasMatch(phoneNumber);
  }

  // переключить страницу
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        togglePage: togglePage,
        validatePhoneNumber: validatePhoneNumber,
      );
    } else {
      return RegisterPage(
        togglePage: togglePage,
        validatePhoneNumber: validatePhoneNumber,
      );
    }
  }
}
