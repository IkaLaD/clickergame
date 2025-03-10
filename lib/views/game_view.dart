import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/widgets/background/moving_background.dart';
import 'package:untitled1/viewmodels/shop_view_model.dart';
import 'package:untitled1/widgets/shop_widget.dart';

import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';
import '../widgets/enemy_widget.dart';
import '../widgets/player_widget.dart';

class GameView extends StatelessWidget {
  final int playerId;
  const GameView({super.key, required this.playerId});

  @override
  Widget build(BuildContext context) {
    GameViewModel gameViewModel = GameViewModel(
      enemyViewModel: context.read<EnemyViewModel>(),
      playerViewModel: context.read<PlayerViewModel>(),
    );

    return Scaffold(
      body: Stack(
        children: [
          const MovingBackground(),
          Center(
            child: Column(
              children: [
                PlayerWidget(viewModel: gameViewModel.playerViewModel, playerId: playerId),
                EnemyWidget(gameViewModel: gameViewModel),
                Expanded(
                  child: SizedBox(
                    height: 250,
                    child: ShopWidget(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
