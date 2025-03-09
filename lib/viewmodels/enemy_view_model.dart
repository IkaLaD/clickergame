import 'package:flutter/material.dart';
import 'package:untitled1/viewmodels/player_view_model.dart';
import '../core/services/enemy_service.dart';
import '../models/enemy_model.dart';

class EnemyViewModel extends ChangeNotifier {
  final EnemyService _enemyRequest = EnemyService();
  late EnemyModel _enemy;
  bool fetchNewEnemy = false;
  int _level = 0;
  int get level => _enemy.level;
  int get totalLife => _enemy.totalLife;
  int get currentLife => _enemy.currentLife;

  attackEnemy(int damages, PlayerViewModel playerViewModel) {
    print(currentLife);
    _enemy.reduceLife(damages);
    if (currentLife == 0) {
      nextEnemy(playerViewModel);
    }
    notifyListeners();
  }


  nextEnemy(PlayerViewModel playerViewModel) {
    _level += 1;
    fetchNewEnemy = true;
    playerViewModel.player.gainCoin();
    playerViewModel.notifyListeners();
  }


  Future<bool> fetchEnemy() async {
    try {
      final enemy = await _enemyRequest.getEnemyById(_level);
      _enemy = enemy!;
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception("Erreur lors de la récupération de l'ennemi (Level: $_level): $e");
    }
  }

  get enemy => _enemy;
}