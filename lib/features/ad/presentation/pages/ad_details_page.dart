import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/widgets/toggle_favourite_ad_icon_button.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsPage extends StatefulWidget {
  final Ad ad;
  const AdDetailsPage({super.key, required this.ad});

  @override
  State<AdDetailsPage> createState() => _AdDetailsPageState();
}

class _AdDetailsPageState extends State<AdDetailsPage> {
  late final AuthCubit authCubit;
  late final AdBloc adBloc;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    adBloc = context.read<AdBloc>();
    super.initState();
  }

  void makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(
      scheme: "tel",
      path: phoneNumber,
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Что-то пошло не так при совершении звонка..."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали объявления"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // название объявления
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    widget.ad.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // верхняя строка
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // цена
                      Text(
                        (widget.ad.price == null)
                            ? "Бесплатно"
                            : "${widget.ad.price} руб.",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // категория
                      Text(
                        widget.ad.category,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                // фото
                if (widget.ad.imageUrl != null)
                  Image.network(widget.ad.imageUrl!),

                // описание
                if (widget.ad.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.ad.description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),

                // имя автора + телефон
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // имя автора
                      Text(
                        widget.ad.appUser.name,
                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(width: 12),

                      // номер телефона
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                makePhoneCall(widget.ad.appUser.phoneNumber),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Colors.green[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                widget.ad.appUser.phoneNumber,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // нижняя строка: избранное - категория - дата
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // избранное
                    if (GetIt.I<SharedPreferences>().getBool("firstLaunch") !=
                        null)
                      ToggleFavouriteAdIconButton(
                        ad: widget.ad,
                        currentUser: authCubit.currentUser!,
                      ),

                    const Spacer(),

                    // дата
                    Row(
                      children: [
                        Text(
                          widget.ad.dateFormatter.format(widget.ad.timestamp),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8.0),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
