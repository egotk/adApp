import 'package:actonica/features/ad/domain/entities/ad.dart';

abstract class AdState {}

// initial
class AdsInitial extends AdState {}

// loading
class AdsLoading extends AdState {}

// loaded
class AdsLoaded extends AdState {
  final List<Ad> ads;

  AdsLoaded(this.ads);
}

// error
class AdsError extends AdState {
  final String message;

  AdsError({required this.message});
}
