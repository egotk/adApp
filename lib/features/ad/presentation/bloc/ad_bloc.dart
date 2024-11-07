import 'package:actonica/features/ad/domain/repos/ad_repo.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_events.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_states.dart';
import 'package:actonica/features/image_storage/domain/repos/image_storage_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final AdRepo adRepo;
  final ImageStorageRepo imageStorageRepo;

  AdBloc({required this.adRepo, required this.imageStorageRepo})
      : super(AdsInitial()) {
    on<CreateAd>(_onCreateAd);
    on<DeleteAd>(_onDeleteAd);
    on<FetchAllAds>(_onFetchAllAds);
    on<FetchAdsByCategory>(_onFetchAdsByCategory);
    on<ToggleFavouriteAd>(_onToggleFavouriteAd);
  }

  void _onCreateAd(CreateAd event, Emitter<AdState> emit) async {
    String? imageUrl;

    try {
      emit(AdsLoading());

      // загрузить картинку в firebase, извлечь downloadUrl
      if (event.imagePath != null) {
        imageUrl = await imageStorageRepo.uploadAdImageMobile(
            event.imagePath!, event.ad.id);
      }

      // обновить поле imageUrl у ad
      final ad = event.ad;
      final newAd = ad.copyWith(imageUrl: imageUrl);

      // создать новое объявление
      await adRepo.createAd(newAd);
      // обновить список объявлений
      add(FetchAllAds());
    } catch (e) {
      emit(AdsError(message: "Ошибка при добавлении объявления: $e"));
    }
  }

  void _onDeleteAd(DeleteAd event, Emitter<AdState> emit) async {
    try {
      await adRepo.deleteAd(event.adId);
      add(FetchAllAds());
    } catch (e) {
      emit(AdsError(message: "Ошибка при удалении объявления: $e"));
    }
  }

  // обновить UI
  void _onFetchAllAds(FetchAllAds event, Emitter<AdState> emit) async {
    try {
      emit(AdsLoading());
      final ads = await adRepo.fetchAllAds();
      emit(AdsLoaded(ads));
    } catch (e) {
      emit(AdsError(message: "Ошибка при загрузке объявлений: $e"));
    }
  }

  void _onFetchAdsByCategory(
      FetchAdsByCategory event, Emitter<AdState> emit) async {
    try {
      emit(AdsLoading());
      final ads = await adRepo.fetchAdsByCategory(event.category);
      emit(AdsLoaded(ads));
    } catch (e) {
      emit(AdsError(message: "Ошибка при загрузке объявлений: $e"));
    }
  }

  // добавить/удалить из избранного
  void _onToggleFavouriteAd(
      ToggleFavouriteAd event, Emitter<AdState> emit) async {
    try {
      await adRepo.toggleFavouriteAd(event.adId, event.phoneNumber);
    } catch (e) {
      emit(AdsError(
          message: "Ошибка при добавлении объявления в избранные: $e"));
    }
  }
}
