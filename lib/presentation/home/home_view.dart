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
  final gameWidget = AppGame(
    onAssetsLoad: () async {
      log('message');
    },
  );

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, child) {
        return IndexedStack(
          index: model.page.index,
          children: [
            Stack(
              children: [
                Center(
                  child: TextButton(
                      onPressed: () {
                        model.changePage(Pages.game);
                      },
                      child: Text('game')),
                )
              ],
            ),
            Column(
              children: [
                Expanded(
                    child: AppGameView(
                  game: gameWidget,
                )),
                TextButton(
                    onPressed: () {
                      model.changePage(Pages.menu);
                    },
                    child: Text('menu'))
              ],
            ),
          ],
        );
      },
    );
  }
}
