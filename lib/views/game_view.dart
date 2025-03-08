
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';
import '../widgets/background/moving_background.dart';
import '../widgets/enemy_widget.dart';
import '../widgets/player_widget.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    GameViewModel gameViewModel = GameViewModel(
        enemyViewModel: context.read<EnemyViewModel>(),
        playerViewModel: context.read<PlayerViewModel>()
    );
    return Scaffold(
      body: Stack(
        children: [
          const MovingBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PlayerWidget(viewModel: gameViewModel.playerViewModel),
                EnemyWidget(gameViewModel: gameViewModel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}