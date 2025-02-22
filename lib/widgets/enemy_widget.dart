import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/enemy_view_model.dart';

class EnemyWidget extends StatelessWidget {
  final EnemyViewModel viewModel;
  const EnemyWidget({
    required this.viewModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
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
                      onTap: () => viewModel.attackEnemy(1), // Image tapped
                      child: Image.asset(
                        'assets/enemies/enemy_${viewModel.enemy!.level%7}.png',
                        fit: BoxFit.cover, // Fixes border issues
                      ),
                    ),
                    Text(
                      "Ennemi : ${viewModel.enemy!.name}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Niveau : ${viewModel.enemy!.level+1}"),
                    Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
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
}
