
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';
import '../widgets/enemy_widget.dart';
import '../widgets/player_widget.dart';

class GameView extends StatelessWidget {
  final int playerId;
  const GameView({Key? key, required this.playerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameViewModel gameViewModel = GameViewModel(
        enemyViewModel: context.read<EnemyViewModel>(),
        playerViewModel: context.read<PlayerViewModel>()
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Clicker Game")),
      body: Center(
        child: Column(
          children: [
            PlayerWidget(viewModel: gameViewModel.playerViewModel, playerId: playerId),
            EnemyWidget(gameViewModel: gameViewModel),
          ],
        )
      ),
    );
  }
}