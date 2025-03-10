import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/widgets/particules/particule_effect.dart';

import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';

class EnemyWidget extends StatefulWidget {
  final GameViewModel gameViewModel;
  const EnemyWidget({
    required this.gameViewModel,
    super.key
  });

  @override
  createState() => _EnemyWidgetState();
}

class _EnemyWidgetState extends State<EnemyWidget> {
  final List<OverlayEntry> _overlayEntries = [];
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {});
  }

  void _showParticules(details) {
    final overlay = Overlay.of(context);
    final position = details.globalPosition;

    final overlayEntry = OverlayEntry(
      builder: (context) => ParticuleEffect(position: position),
    );

    _overlayEntries.add(overlayEntry);
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 120), () {
      overlayEntry.remove();
      _overlayEntries.remove(overlayEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    EnemyViewModel viewModel = widget.gameViewModel.enemyViewModel;
    PlayerViewModel playerViewModel = widget.gameViewModel.playerViewModel;

    return FutureBuilder<bool>(
      future: viewModel.fetchEnemy(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur : ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data == true && viewModel.enemy != null) {


          return Consumer<EnemyViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.fetchNewEnemy) {
                _timer.cancel();
                _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  if (timer.tick == 100 && !viewModel.isPreviousEnemy && viewModel.level != 0) {
                    viewModel.previousEnemy();
                  }
                });

                viewModel.fetchEnemy();
                viewModel.fetchNewEnemy = false;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (details) {
                      playerViewModel.gainExp(viewModel.enemy!.level + 1);
                      if (viewModel.attackEnemy(playerViewModel.damages)) playerViewModel.gainCoin();
                      _showParticules(details);
                    },
                    child: Image.asset(
                      'assets/enemies/enemy_${viewModel.enemy!.level % 7}.png',
                      width: 450*0.75,
                      height: 400*0.75,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "${viewModel.enemy!.name}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 200,
                          child: Column(
                              children: [
                                LinearProgressIndicator(
                                  value: viewModel.currentLife / viewModel.totalLife,
                                  backgroundColor: Colors.red.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                ),
                                Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}")
                              ]
                          ),
                        ),
                        if (viewModel.isPreviousEnemy) _backToEnemy(viewModel)
                        else const TextButton(onPressed: null, child: Text("")),
                      ]
                    )
                  ),
                ],
              );
            },
          );
        } else {
          return const Text("Aucun ennemi trouvé.");
        }
      },
    );
  }

  _backToEnemy(EnemyViewModel viewModel) {
    return TextButton(
        onPressed: () {
          viewModel.backToEnemy();
        },
        child: const Text("Revenir à l'Ennemi")
    );
  }
}
