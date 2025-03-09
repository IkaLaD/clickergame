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
      future: viewModel.fetchPlayer(2),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur : \${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data == true &&
            viewModel.player != null) {
          return Consumer<PlayerViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.player!.canBuyAugment)
                    TextButton(
                      onPressed: () {
                        bool success = viewModel.player.buyAugment();
                        if (success) {
                          viewModel.notifyListeners();
                        }
                      },
                      child: const Text("Passer au niveau supérieur"),
                    ),
                  Text(
                    "Player : ${viewModel.player!.pseudo}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Niveau joueur : ${viewModel.player!.level} -  DPS : ${viewModel.player.getDamages()}"),
                  Text("Exp du joueur : ${viewModel.player!.totalexp}"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/coin.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Coins : ${viewModel.player!.coins}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else {
          return const Text("Aucun joueur trouvé.");
        }
      },
    );
  }
}