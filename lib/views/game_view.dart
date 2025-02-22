
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../viewmodels/player_view_model.dart';
import '../viewmodels/enemy_view_model.dart';
import '../widgets/enemy_widget.dart';
import '../widgets/player_widget.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clicker Game")),
      body: Center(
        child: Column(
          children: [
            PlayerWidget(viewModel: context.read<PlayerViewModel>()),
            EnemyWidget(viewModel: context.read<EnemyViewModel>()),
          ],
        )
      ),
    );
  }
}