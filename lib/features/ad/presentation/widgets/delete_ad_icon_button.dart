import 'package:actonica/features/ad/domain/entities/ad.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_bloc.dart';
import 'package:actonica/features/ad/presentation/bloc/ad_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAdIconButton extends StatefulWidget {
  final Ad ad;

  const DeleteAdIconButton({
    super.key,
    required this.ad,
  });

  @override
  State<DeleteAdIconButton> createState() => _DeleteAdIconButtonState();
}

class _DeleteAdIconButtonState extends State<DeleteAdIconButton> {
  late final AdBloc adBloc;

  @override
  void initState() {
    adBloc = context.read<AdBloc>();
    super.initState();
  }

  // подтвердить удаление объявления
  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Удалить объявление?"),
        actions: [
          TextButton(
              onPressed: () {
                adBloc.add(DeleteAd(adId: widget.ad.id));
                Navigator.of(context).pop();
              },
              child: const Text("Удалить")),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Отменить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: showDeleteDialog,
      icon: const Icon(Icons.delete),
    );
  }
}
