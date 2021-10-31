import 'dart:developer';

import 'package:example/gen/assets.gen.dart';
import 'package:example/presentation/game/game_view.dart';
import 'package:example/presentation/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
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
        if (model.page == Pages.menu) {
          return Stack(
            children: [
              Opacity(
                opacity: .4,
                child: Image.asset(
                  'assets/images/bg.png',
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Center(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Image.asset(
                          'assets/images/menu.png',
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Center(
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: SizedBox(
                            width: 1000,
                            height: 500,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    'assets/images/button.png',
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 170),
                                    child: Image.asset(
                                      'assets/images/play_button.png',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            model.changePage(Pages.game);
                          }),
                    )
                  ],
                ),
              )
            ],
          );
        } else {
          return AppGameView(
            game: gameWidget,
          );
        }
      },
    );
  }
}
