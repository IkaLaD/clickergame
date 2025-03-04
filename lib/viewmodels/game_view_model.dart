
import 'package:flutter/cupertino.dart';
import 'package:untitled1/viewmodels/player_view_model.dart';

import 'enemy_view_model.dart';

class GameViewModel extends ChangeNotifier {
  final EnemyViewModel enemyViewModel;
  final PlayerViewModel playerViewModel;

  GameViewModel({
    required this.enemyViewModel,
    required this.playerViewModel,
  });
}