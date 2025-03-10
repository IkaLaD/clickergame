import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/widgets/particules/particule_effect.dart';

import '../viewmodels/enemy_view_model.dart';
import '../viewmodels/game_view_model.dart';
import '../viewmodels/player_view_model.dart';

class EnemyWidget extends StatefulWidget {
  final GameViewModel gameViewModel;
  const EnemyWidget({
    required this.gameViewModel,
    super.key
  });

  @override
  createState() => _EnemyWidgetState(gameViewModel: gameViewModel);
}

class _EnemyWidgetState extends State<EnemyWidget> {
  final List<OverlayEntry> _overlayEntries = [];
  late Timer _timer;
  final GameViewModel gameViewModel;

  _EnemyWidgetState({
    required this.gameViewModel
  });

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {});
  }

  void _showParticules(details) {
    final overlay = Overlay.of(context);
    final position = details.globalPosition;

    final overlayEntry = OverlayEntry(
      builder: (context) => ParticuleEffect(position: position),
    );

    _overlayEntries.add(overlayEntry);
    overlay.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 120), () {
      overlayEntry.remove();
      _overlayEntries.remove(overlayEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    EnemyViewModel viewModel = widget.gameViewModel.enemyViewModel;
    PlayerViewModel playerViewModel = widget.gameViewModel.playerViewModel;

    return FutureBuilder<bool>(
      future: viewModel.fetchEnemy(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Erreur : ${snapshot.error}");
        } else if (snapshot.hasData && snapshot.data == true && viewModel.enemy != null) {
          if (viewModel.fetchNewEnemy) {
            viewModel.fetchEnemy();
            viewModel.fetchNewEnemy = false;
          }

          return Consumer<EnemyViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.fetchNewEnemy) {
                _timer.cancel();
                _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
                  if (timer.tick == 100 && !viewModel.isPreviousEnemy && viewModel.level != 0) {
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
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (details) {
                      playerViewModel.gainExp(viewModel.enemy!.level + 1);
                      viewModel.attackEnemy(playerViewModel);
                      _showParticules(details);
                    },
                    child: Image.asset(
                      'assets/enemies/enemy_${viewModel.enemy!.level % 7}.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "${viewModel.enemy!.name}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text("Vie : ${viewModel.currentLife} / ${viewModel.totalLife}"),
                  if (viewModel.isPreviousEnemy) _backToEnemy(viewModel, gameViewModel.playerViewModel)
                ],
              );
            },
          );
        } else {
          return const Text("Aucun ennemi trouvé.");
        }
      },
    );
  }

  _backToEnemy(EnemyViewModel viewModel, PlayerViewModel playerViewModel) {
    return TextButton(
        onPressed: () {
          viewModel.backToEnemy(playerViewModel);
        },
        child: const Text("Revenir à l'Ennemi")
    );
  }
}
