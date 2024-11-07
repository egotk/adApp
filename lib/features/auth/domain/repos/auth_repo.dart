import 'package:actonica/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepo {
  Future<AppUser?> loginWithPhoneNumber(String phoneNumber);
  Future<AppUser?> registerWithPhoneNumber(String name, String phoneNumber);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
