import 'package:actonica/features/auth/domain/entities/app_user.dart';
import 'package:actonica/features/auth/domain/repos/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepoImpl implements AuthRepo {
  final SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");

  /*
    -- проверить, существует ли номер
    -- номер существует --> ошибка
    -- номер не существует --> добавить аккаунт в firebase + занести в локальное хранилище
  */
  @override
  Future<AppUser?> registerWithPhoneNumber(
      String name, String phoneNumber) async {
    try {
      // достать userDoc из firebase
      DocumentSnapshot userDoc = await usersCollection.doc(phoneNumber).get();

      // номер телефона зарегистрирован
      if (userDoc.exists) {
        throw (Exception("Номер телефона уже зарегистрирован"));
      }

      AppUser user = AppUser(
        name: name,
        phoneNumber: phoneNumber,
      );

      // сохранить в firebase
      await usersCollection.doc(phoneNumber).set(user.toJson());

      // сохранить в локальное хранилище
      await sharedPreferences.setString("phone", phoneNumber);

      return user;
    } catch (e) {
      throw Exception("Ошибка при регистрации: $e");
    }
  }

  /*
    -- использовать данные аккаунта, с которым связан номер в firebase, для дальнейшей работы
  */
  @override
  Future<AppUser?> loginWithPhoneNumber(String phoneNumber) async {
    try {
      // достать userDoc из firebase
      DocumentSnapshot userDoc = await usersCollection.doc(phoneNumber).get();

      // номер телефона не зарегистрирован
      if (!userDoc.exists) {
        throw (Exception("Номер телефона не зарегистрирован"));
      }

      AppUser user = AppUser.fromJson(userDoc.data() as Map<String, dynamic>);

      // сохранить в локальное хранилище
      await sharedPreferences.setString("phone", phoneNumber);

      return user;
    } catch (e) {
      throw Exception("Ошибка при регистрации: $e");
    }
  }

  /*
    -- удалить номер из shared preferences
    -- выйти на экран входа
  */
  @override
  Future<void> logout() async {
    try {
      sharedPreferences.remove("phone");
    } catch (e) {
      throw Exception("Ошибка при выходе: $e");
    }
  }

  /*
    -- получить текущего пользователя
    -- номер телефона извлекается из shared_preferences
  */
  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // извлечь номер из локального хранилища
      String? phoneNumber = sharedPreferences.getString("phone");

      // в локальном хранилище по ключу "phone" пусто
      if (phoneNumber == null) {
        return null;
      }

      // достать userDoc из firebase
      DocumentSnapshot userDoc = await usersCollection.doc(phoneNumber).get();

      AppUser user = AppUser.fromJson(userDoc.data() as Map<String, dynamic>);

      return user;
    } catch (e) {
      throw Exception("Ошибка при получении текущего пользователя: $e");
    }
  }
}
