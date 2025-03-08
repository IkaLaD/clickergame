import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';

class EnemyWidget extends StatelessWidget {
  final GameViewModel gameViewModel;
  const EnemyWidget({
    required this.gameViewModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    EnemyViewModel viewModel = gameViewModel.enemyViewModel;
    PlayerViewModel playerViewModel = gameViewModel.playerViewModel;

    Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {});

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
                  timer.cancel();

                  timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                    if (timer.tick == 10 && viewModel.isPreviousEnemy == false && viewModel.level != 0) {
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
                      onTap: () => {
                        playerViewModel.gainExp(viewModel.enemy!.level+1),
                        viewModel.attackEnemy(playerViewModel.damages)
                      },
                      child: Image.asset(
                        'assets/enemies/enemy_${viewModel.enemy!.level%7}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "Ennemi : ${viewModel.enemy!.name}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Niveau : ${viewModel.enemy!.level+1}"),
                    Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
                    _backToEnemy(viewModel),
                  ],
                );
              }
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
