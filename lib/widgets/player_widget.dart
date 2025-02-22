import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/player_view_model.dart';

class PlayerWidget extends StatelessWidget {
  final PlayerViewModel viewModel;
  const PlayerWidget({
    required this.viewModel,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: viewModel.fetchPlayer(0),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur : ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data == true && viewModel.player != null) {
          return Consumer<PlayerViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => viewModel.buyAugment(),
                      child: const Text("Augment")
                    ),
                    Text(
                      "Player : ${viewModel.player!.pseudo}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text("Niveau joueur : ${viewModel.player!.level+1}"),
                  ],
                );
              }
          );
        } else {
          return const Text("Aucun joueur trouvé.");
        }
      },
    );
  }
}
