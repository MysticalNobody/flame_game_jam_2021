import 'dart:developer';

import 'package:example/presentation/game/game_view.dart';
import 'package:example/presentation/home/home_view_model.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AppGame gameWidget;

  @override
  void initState() {
    super.initState();
    gameWidget = AppGame(
      onAssetsLoad: () async {
        log('message');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return AppGameView(
          game: gameWidget,
        );
      },
    );
  }
}
