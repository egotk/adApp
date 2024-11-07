import 'package:actonica/constants/constants.dart';
import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/domain/repos/ad_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdRepoImpl implements AdRepo {
  final SharedPreferences sharedPreferences = GetIt.I<SharedPreferences>();
  final CollectionReference adsCollection =
      FirebaseFirestore.instance.collection("ads");

  // загрузить все объявления (для главной)
  @override
  Future<List<Ad>> fetchAllAds() async {
    try {
      List<Ad> allAds;
      // флаг firstLaunch становится равным false при создании объявления
      // то, что он равен null, означает первый запуск
      if (sharedPreferences.getBool("firstLaunch") == null) {
        allAds = initialAds;
        return allAds;
      }
      // достать объявления с сортировкой по новизне
      final adsSnapshot =
          await adsCollection.orderBy('timestamp', descending: true).get();

      // doc json -> ad list
      allAds = adsSnapshot.docs
          .map((doc) => Ad.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return allAds;
    } catch (e) {
      throw Exception("Ошибка при загрузке объявлений: $e");
    }
  }

  // загрузить объявления по категории
  @override
  Future<List<Ad>> fetchAdsByCategory(String category) async {
    try {
      // достать по категории
      final adsByCategorySnapshot =
          await adsCollection.where("category", isEqualTo: category).get();

      // doc json -> ad
      final List<Ad> adsByCategory = adsByCategorySnapshot.docs
          .map((doc) => Ad.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return adsByCategory;
    } catch (e) {
      throw Exception("Ошибка при загрузке объявления: $e");
    }
  }

  // создать объявление (path нужен для того, чтобы загрузить картинку в firebase, после чего добавить imageUrl в Ad)
  @override
  Future<void> createAd(Ad ad) async {
    try {
      // флаг первого запуска
      await sharedPreferences.setBool("firstLaunch", false);

      await adsCollection.doc(ad.id).set(ad.toJson());
    } catch (e) {
      throw Exception("Ошибка при создании объявления $e");
    }
  }

  // удалить объявление
  @override
  Future<void> deleteAd(String adId) async {
    try {
      await adsCollection.doc(adId).delete();
    } catch (e) {
      throw Exception("Ошибка при удалении объявления $e");
    }
  }

  // добавить/удалить из избранного
  @override
  Future<void> toggleFavouriteAd(String adId, String phoneNumber) async {
    try {
      // достать объявление из firebase
      final adDoc = await adsCollection.doc(adId).get();

      if (adDoc.exists) {
        final ad = Ad.fromJson(adDoc.data() as Map<String, dynamic>);
        // узнать, есть ли это объявление у пользователя в избранных
        final hasFavourited = ad.favouritedByPhoneNumbers.contains(phoneNumber);

        // обновить поле
        if (hasFavourited) {
          ad.favouritedByPhoneNumbers.remove(phoneNumber);
        } else {
          ad.favouritedByPhoneNumbers.add(phoneNumber);
        }

        // обновить firebase
        await adsCollection.doc(adId).update({
          'favouritedByPhoneNumbers': ad.favouritedByPhoneNumbers,
        });
      } else {
        throw Exception("Объявление не найдено");
      }
    } catch (e) {
      throw ("Ошибка при добавлении в избранное: $e");
    }
  }
}
