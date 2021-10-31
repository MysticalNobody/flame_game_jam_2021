import 'dart:developer';

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
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 140),
                                    child: Image.asset(
                                      'assets/images/play_button.png',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            model.changePage(Pages.hint);
                          }),
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
                              children: const [
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
        } else if (model.page == Pages.gameOver) {
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
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.asset(
                              'assets/images/game_over1.png',
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height,
                            ).image,
                          ),
                        ),
                        child: Center(
                          child: Stack(
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.asset(
                                      'assets/images/game_over3.png',
                                      fit: BoxFit.cover,
                                    ).image,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/game_over5.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.asset(
                                      'assets/images/game_over2.png',
                                      fit: BoxFit.cover,
                                    ).image,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/images/game_over2.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Positioned.fill(
                                child: Align(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: SizedBox(
                                      width: 100,
                                      child: Text(
                                        'You won in ${model.seconds} seconds',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return AppGameView(
            game: AppGame(
              onAssetsLoad: () async {
                log('message');
              },
              onGameOver: model.showGameOver,
            ),
          );
        }
      },
    );
  }
}
