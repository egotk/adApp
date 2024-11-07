import 'package:actonica/features/auth/domain/entities/app_user.dart';
import 'package:actonica/features/auth/domain/repos/auth_repo.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  // в shared_preferences есть номер телефона -> авторизован
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // текущий пользователь
  AppUser? get currentUser => _currentUser;

  // войти по номеру
  Future<void> login(String phoneNumber) async {
    try {
      emit(AuthLoading());
      final AppUser? user = await authRepo.loginWithPhoneNumber(phoneNumber);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // зарегистрироваться (имя, номер)
  Future<void> register(String name, String phoneNumber) async {
    try {
      emit(AuthLoading());
      final AppUser? user =
          await authRepo.registerWithPhoneNumber(name, phoneNumber);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        // emit(AuthError("Номер телефона занят"));
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }

  // выйти
  Future<void> logout() async {
    await authRepo.logout();
    emit(Unauthenticated());
  }
}
