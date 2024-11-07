import 'dart:io';

import 'package:actonica/features/image_storage/domain/repos/image_storage_repo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorageRepoImpl implements ImageStorageRepo {
  final firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String?> uploadAdImageMobile(String imagePath, String fileName) async {
    try {
      // выбрать файл
      final file = File(imagePath);

      // firebase
      final storageRef = firebaseStorage.ref().child("ad_images/$fileName");

      // загрузить
      final uploadTask = await storageRef.putFile(file);

      // вернуть ссылку для скачивания
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Ошибка при загрузке изображения: $e");
    }
  }
}
