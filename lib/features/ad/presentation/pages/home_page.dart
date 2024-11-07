import 'package:actonica/constants/constants.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_events.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_states.dart';
import 'package:actonica/features/ad/presentation/pages/create_ad_page.dart';
import 'package:actonica/features/ad/presentation/widgets/ad_tile.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final adBloc = context.read<AdBloc>();
  late final authCubit = context.read<AuthCubit>();
  bool? firstLaunch;
  String? selectedCategory;

  @override
  void initState() {
    firstLaunch = GetIt.I<SharedPreferences>().getBool("firstLaunch");
    adBloc.add(FetchAllAds());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              print(authCubit.currentUser);
            },
            icon: const Icon(Icons.search)),
        actions: [
          IconButton(
            onPressed: authCubit.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateAdPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary),
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategory == categories[index]) {
                          selectedCategory = null;
                          adBloc.add(FetchAllAds());
                          return;
                        }
                        selectedCategory = categories[index];
                        adBloc.add(
                          FetchAdsByCategory(category: selectedCategory!),
                        );
                      });
                    },
                    child: Text(
                      categories[index],
                      style: TextStyle(
                          fontWeight: (selectedCategory == categories[index])
                              ? FontWeight.bold
                              : FontWeight.w100),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: BlocBuilder<AdBloc, AdState>(builder: (context, state) {
                // loading
                if (state is AdsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // loaded
                else if (state is AdsLoaded) {
                  final allAds = state.ads;

                  // объявления отсутствуют
                  if (allAds.isEmpty) {
                    return const Center(
                      child: Text("Объявлений не найдено"),
                    );
                  }

                  // список AdTile
                  return ListView.builder(
                    itemCount: allAds.length,
                    itemBuilder: (context, index) {
                      final ad = allAds[index];

                      return AdTile(ad: ad);
                    },
                  );
                }

                // error
                else if (state is AdsError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
