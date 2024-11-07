import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:actonica/features/auth/presentation/widgets/my_button.dart';
import 'package:actonica/features/auth/presentation/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final void Function() togglePage;
  final bool Function(String) validatePhoneNumber;
  const LoginPage({
    super.key,
    required this.togglePage,
    required this.validatePhoneNumber,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // контроллеры
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void login() {
    final String phoneNumber = phoneNumberController.text;

    if (widget.validatePhoneNumber(phoneNumber)) {
      final AuthCubit authCubit = context.read<AuthCubit>();
      authCubit.login(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Некорректный формат номера телефона"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Добро пожаловать"),
          const SizedBox(height: 25),
          MyTextField(
            controller: phoneNumberController,
            hintText: "Номер телефона",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 15),
          MyButton(text: "Продолжить", onTap: login),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Впервые? "),
              GestureDetector(
                  onTap: widget.togglePage,
                  child: const Text(
                    "Зарегистрируйтесь",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
