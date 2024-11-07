import 'package:actonica/features/ad/domain/entities/ad.dart';

abstract class AdEvent {}

class CreateAd extends AdEvent {
  final Ad ad;
  String? imagePath;

  CreateAd({required this.ad, this.imagePath});
}

class DeleteAd extends AdEvent {
  final String adId;

  DeleteAd({required this.adId});
}

class FetchAllAds extends AdEvent {}

class FetchAdsByCategory extends AdEvent {
  final String category;

  FetchAdsByCategory({required this.category});
}

class ToggleFavouriteAd extends AdEvent {
  final String adId;
  final String phoneNumber;

  ToggleFavouriteAd({
    required this.adId,
    required this.phoneNumber,
  });
}
