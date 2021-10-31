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
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
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
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              model.changePage(Pages.hint);
                            }),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        } else if (model.page == Pages.hint) {
          return Material(
            color: Colors.black,
            child: GestureDetector(
              onTap: () {
                model.changePage(Pages.game);
              },
              child: Stack(
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
                      child: Opacity(
                    opacity: .8,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width - 64,
                      height: MediaQuery.of(context).size.height - 64,
                      decoration: BoxDecoration(
                          color: Color(0xffeb9062),
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'How to play',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Divider(),
                                Text(
                                  'The goal of the game is to deliver the most candy to the box. If the candy touches a monster or the ground, it disappears.\n\nGood luck!\n\n',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'tap to start',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          );
        } else if (model.page == Pages.finish) {
          return Material(
            color: Colors.black,
            child: GestureDetector(
              onTap: () {
                model.changePage(Pages.menu);
              },
              child: Stack(
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
                      child: Opacity(
                    opacity: .8,
                    child: Container(
                      padding: EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width - 64,
                      height: MediaQuery.of(context).size.height - 64,
                      decoration: BoxDecoration(
                          color: Color(0xffeb9062),
                          borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Congratulations',
                                  style: TextStyle(fontSize: 24),
                                ),
                                Divider(),
                                Text(
                                  'Congratulations, you\'ve completed our super super cool game! We tried very hard to make you like it!\nAuthors:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'tap to go to menu',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
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
