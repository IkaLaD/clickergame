import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/enemy_view_model.dart';

class EnemyWidget extends StatelessWidget {
  const EnemyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    EnemyViewModel viewModel = context.read<EnemyViewModel>();

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
                    Text(
                      "Ennemi : ${viewModel.enemy!.name}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Niveau : ${viewModel.enemy!.level}"),
                    Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
                    ElevatedButton(
                      onPressed: () => viewModel.attackEnemy(1),
                      child: const Text("Attaquer (-1 PV)"),
                    ),
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
