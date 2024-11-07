import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/auth/domain/entities/app_user.dart';

const List<String> categories = [
  "Электроника",
  "Животные",
  "Работа",
  "Недвижимость",
  "Услуги",
  "Транспорт",
];

List<Ad> initialAds = [
  Ad(
    name: "Тестовое объявление 1",
    description: "Тестовое описание 1",
    category: categories[0],
    appUser: AppUser(
      name: "Первый",
      phoneNumber: "111111",
    ),
  ),
  Ad(
    name: "Тестовое объявление 2",
    description: "Тестовое описание 2",
    category: categories[1],
    appUser: AppUser(
      name: "Второй",
      phoneNumber: "222222",
    ),
  ),
  Ad(
    name: "Тестовое объявление 3",
    description: "Тестовое описание 3",
    category: categories[2],
    appUser: AppUser(
      name: "Третий",
      phoneNumber: "333333",
    ),
  ),
  Ad(
    name: "Тестовое объявление 4",
    description: "Тестовое описание 4",
    category: categories[3],
    appUser: AppUser(
      name: "Четверный",
      phoneNumber: "444444",
    ),
  ),
  Ad(
    name: "Тестовое объявление 5",
    description: "Тестовое описание 5",
    category: categories[4],
    appUser: AppUser(
      name: "Пятый",
      phoneNumber: "555555",
    ),
  ),
  Ad(
    name: "Тестовое объявление 6",
    description: "Тестовое описание 6",
    category: categories[5],
    appUser: AppUser(
      name: "Шестой",
      phoneNumber: "666666",
    ),
  ),
];
