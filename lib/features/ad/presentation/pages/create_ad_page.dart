import 'dart:io';

import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_events.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:actonica/features/auth/presentation/widgets/my_button.dart';
import 'package:actonica/features/auth/presentation/widgets/my_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:actonica/constants/constants.dart';

class CreateAdPage extends StatefulWidget {
  const CreateAdPage({super.key});

  @override
  State<CreateAdPage> createState() => _CreateAdPageState();
}

class _CreateAdPageState extends State<CreateAdPage> {
  late final authCubit = context.read<AuthCubit>();
  late final adBloc = context.read<AdBloc>();

  // мобильный файл
  PlatformFile? imagePickedFile;
  // категория
  String category = categories.first;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        imagePickedFile = result.files.first;
      });
    }
  }

  void createAd() {
    // обязательные поля не заполнены
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Заполните обязательные поля.")));
      return;
    }

    double? price = double.tryParse(priceController.text);

    /*
      в поле с ценой введена строка либо некорректное число,
      но поле заполнено (пустое поле это корректное значение)
    */
    if (priceController.text.isNotEmpty && (price == null || price < 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Введите корректное значение цены.")));
      return;
    }

    // descriptionController.text по умолчанию "", но для пустой строки нужен null
    String? description = descriptionController.text.isNotEmpty
        ? descriptionController.text
        : null;

    final ad = Ad(
      name: nameController.text,
      description: description,
      category: category,
      appUser: authCubit.currentUser!,
      price: price,
    );

    adBloc.add(CreateAd(ad: ad, imagePath: imagePickedFile?.path));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Заполните поля")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // name
              const SizedBox(height: 12),
              const Text("Название объявления (обязательно):"),
              const SizedBox(height: 8),
              MyTextField(
                controller: nameController,
                hintText: "Название объявления",
              ),

              // description
              const SizedBox(height: 12),
              const Text("Описание объявления (опционально):"),
              const SizedBox(height: 8),
              MyTextField(
                controller: descriptionController,
                hintText: "Описание отсутствует...",
              ),

              // categories
              const SizedBox(height: 12),
              const Text("Категория объявления (обязательно):"),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: category,
                items: categories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              // price
              const SizedBox(height: 12),
              const Text("Цена:"),
              const SizedBox(height: 8),

              MyTextField(
                controller: priceController,
                hintText: "Бесплатно",
              ),

              const SizedBox(height: 12),
              (imagePickedFile != null)
                  ? Image.file(
                      File(imagePickedFile!.path!),
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(
                      height: 200,
                      child: Icon(
                        Icons.photo_camera,
                        size: 120,
                      ),
                    ),

              // image
              const SizedBox(height: 12),
              const Text("Добавить изображение (опционально):"),
              const SizedBox(height: 8),
              MyButton(text: "Загрузить изображение", onTap: pickImage),

              // submit
              const SizedBox(height: 12),
              MyButton(text: "Создать объявление", onTap: createAd),
            ],
          ),
        ),
      ),
    );
  }
}
