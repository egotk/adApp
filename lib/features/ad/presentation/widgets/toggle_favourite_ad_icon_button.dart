import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_events.dart';
import 'package:actonica/features/auth/domain/entities/app_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleFavouriteAdIconButton extends StatefulWidget {
  final Ad ad;
  final AppUser currentUser;

  const ToggleFavouriteAdIconButton({
    super.key,
    required this.ad,
    required this.currentUser,
  });

  @override
  State<ToggleFavouriteAdIconButton> createState() =>
      _ToggleFavouriteAdIconButtonState();
}

class _ToggleFavouriteAdIconButtonState
    extends State<ToggleFavouriteAdIconButton> {
  late final AdBloc adBloc;

  // вынести чтобы код смотрелся лучше
  late List<String> favouritedBy;
  late final String currentUserPhone;

  @override
  void initState() {
    adBloc = context.read<AdBloc>();
    favouritedBy = widget.ad.favouritedByPhoneNumbers;
    currentUserPhone = widget.currentUser.phoneNumber;
    super.initState();
  }

  void toggleFavouriteAd() {
    // узнать, находится ли объявление в избранном
    bool isFavourite = favouritedBy.contains(currentUserPhone);

    // обновить UI до обновления firebase
    setState(() {
      if (isFavourite) {
        favouritedBy.remove(currentUserPhone);
      } else {
        favouritedBy.add(currentUserPhone);
      }
    });

    // обновить firebase
    adBloc.add(
      ToggleFavouriteAd(
        adId: widget.ad.id,
        phoneNumber: currentUserPhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: toggleFavouriteAd,
      icon: Icon(
        favouritedBy.contains(currentUserPhone)
            ? Icons.favorite
            : Icons.favorite_border,
        color: (favouritedBy.contains(currentUserPhone)
            ? Colors.red[300]
            : Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
