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
    EnemyViewModel viewModel = gameViewModel.enemyViewModel;
    PlayerViewModel playerViewModel = gameViewModel.playerViewModel;
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
                  viewModel.fetchEnemy();
                  viewModel.fetchNewEnemy = false;
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        playerViewModel.gainExp(viewModel.enemy!.level+1),
                        viewModel.attackEnemy(playerViewModel.damages, playerViewModel)
                      },
                      child: Image.asset(
                        'assets/enemies/enemy_${viewModel.enemy!.level%7}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "${viewModel.enemy!.name}, niveau : ${viewModel.enemy!.level}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Niveau : ${viewModel.enemy!.level+1}"),
                    Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
                  ],
                );
              }
            builder: (context, viewModel, child) {
              if (viewModel.fetchNewEnemy) {
                _timer.cancel();

                _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  if (timer.tick == 100 &&
                      viewModel.isPreviousEnemy == false &&
                      viewModel.level != 0) {
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
                      viewModel.attackEnemy(playerViewModel.damages);
                      _showParticules(details);
                    },
                    child: Image.asset(
                      'assets/enemies/enemy_${viewModel.enemy!.level % 7}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "Ennemi : ${viewModel.enemy!.name}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Niveau : ${viewModel.enemy!.level + 1}"),
                  Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
                  _backToEnemy(viewModel)
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
    if (!viewModel.isPreviousEnemy) {
      return const TextButton(
          onPressed: null,
          child: Text("Revenir à l'Ennemi")
      );
    }
    return TextButton(
        onPressed: () {
            viewModel.backToEnemy();
          },
        child: const Text("Revenir à l'Ennemi")
    );
  }
}
