import 'package:actonica/config/firebase_options.dart';
import 'package:actonica/features/ad/data/repos/ad_repo_impl.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/pages/home_page.dart';
import 'package:actonica/features/auth/data/repos/auth_repo_impl.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_states.dart';
import 'package:actonica/features/auth/presentation/pages/auth_page.dart';
import 'package:actonica/features/image_storage/data/repos/image_storage_repo_impl.dart';
import 'package:actonica/themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(sharedPreferences);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  final authRepoImpl = AuthRepoImpl();
  final adRepoImpl = AdRepoImpl();
  final imageStorageRepoImpl = ImageStorageRepoImpl();

  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepo: authRepoImpl)..checkAuth(),
        ),
        BlocProvider(
            create: (context) => AdBloc(
                adRepo: adRepoImpl, imageStorageRepo: imageStorageRepoImpl)),
      ],
      child: SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              // Authenticated -> HomePage
              if (authState is Authenticated) {
                return const HomePage();
              }
              // Unauthenticated -> LoginPage
              if (authState is Unauthenticated) {
                return const AuthPage();
              } else {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            listener: (context, state) {
              // AuthError -> показать ошибку
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
