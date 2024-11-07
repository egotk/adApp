import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/presentation/pages/ad_details_page.dart';
import 'package:actonica/features/ad/presentation/widgets/delete_ad_icon_button.dart';
import 'package:actonica/features/ad/presentation/widgets/toggle_favourite_ad_icon_button.dart';
import 'package:actonica/features/auth/domain/entities/app_user.dart';
import 'package:actonica/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdTile extends StatefulWidget {
  final Ad ad;
  const AdTile({super.key, required this.ad});

  @override
  State<AdTile> createState() => _AdTileState();
}

class _AdTileState extends State<AdTile> {
  late final AuthCubit authCubit;

  bool isAdOwner = false;
  AppUser? currentUser;

  @override
  void initState() {
    authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isAdOwner = (widget.ad.appUser.phoneNumber == currentUser!.phoneNumber);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdDetailsPage(ad: widget.ad),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isAdOwner
                ? Theme.of(context).colorScheme.inversePrimary
                : Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // название
                Center(
                  child: Text(
                    widget.ad.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                // верхняя строка
                Row(
                  children: [
                    const SizedBox(width: 12),
                    Text(
                      (widget.ad.price == null)
                          ? "Бесплатно"
                          : widget.ad.price.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    if (isAdOwner) DeleteAdIconButton(ad: widget.ad),
                  ],
                ),

                // image
                if (widget.ad.imageUrl != null)
                  Image.network(
                      height: 430, fit: BoxFit.cover, widget.ad.imageUrl!),

                // lower row
                Row(
                  children: [
                    // favourite
                    if (GetIt.I<SharedPreferences>().getBool("firstLaunch") !=
                        null)
                      ToggleFavouriteAdIconButton(
                          ad: widget.ad, currentUser: currentUser!),

                    // отступ
                    const Spacer(),

                    // category
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.secondary),
                      child: Text(widget.ad.category),
                    ),

                    // отступ
                    const Spacer(),

                    // date
                    Text((widget.ad.dateFormatter.format(widget.ad.timestamp))),
                    const SizedBox(width: 12),
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
