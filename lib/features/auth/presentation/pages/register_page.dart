import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:actonica/features/auth/presentation/widgets/my_button.dart';
import 'package:actonica/features/auth/presentation/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  final void Function() togglePage;
  final bool Function(String) validatePhoneNumber;

  const RegisterPage({
    super.key,
    required this.togglePage,
    required this.validatePhoneNumber,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // контроллеры
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String phoneNumber = phoneNumberController.text;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Введите ваше имя"),
        ),
      );
    } else if (!widget.validatePhoneNumber(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Номер телефона некорректен"),
        ),
      );
    } else {
      final AuthCubit authCubit = context.read<AuthCubit>();
      authCubit.register(name, phoneNumber);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Создайте аккаунт"),
          const SizedBox(height: 15),
          MyTextField(
            controller: nameController,
            hintText: "Имя",
          ),
          const SizedBox(height: 15),
          MyTextField(
            controller: phoneNumberController,
            hintText: "Номер телефона",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 15),
          MyButton(text: "Зарегистрироваться", onTap: register),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Уже зарегистрированы? "),
              GestureDetector(
                  onTap: widget.togglePage,
                  child: const Text(
                    "Войти",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
