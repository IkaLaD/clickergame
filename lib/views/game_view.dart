

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/enemy_widget.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clicker Game")),
      body: const Center(
        child: EnemyWidget(),
      ),
    );
  }
}