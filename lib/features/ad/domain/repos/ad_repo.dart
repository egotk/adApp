import 'package:actonica/features/ad/domain/entities/ad.dart';

abstract interface class AdRepo {
  // загрузить все объявления
  Future<List<Ad>> fetchAllAds();
  // загрузить объявление по uid
  Future<List<Ad>> fetchAdsByCategory(String category);
  // создать объявление
  Future<void> createAd(Ad ad);
  // удалить объявление
  Future<void> deleteAd(String adId);
  // добавить/удалить из избранных
  Future<void> toggleFavouriteAd(String adId, String phoneNumber);
}
