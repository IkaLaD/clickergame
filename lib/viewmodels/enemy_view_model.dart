import 'package:flutter/material.dart';
import 'package:untitled1/viewmodels/player_view_model.dart';
import '../core/services/enemy_service.dart';
import '../models/enemy_model.dart';

class EnemyViewModel extends ChangeNotifier {
  final EnemyService _enemyRequest = EnemyService();
  late EnemyModel _enemy;
  bool fetchNewEnemy = false;
  bool isPreviousEnemy = false;
  int _level = 0;
  int get level => _enemy.level;
  int get totalLife => _enemy.totalLife;
  int get currentLife => _enemy.currentLife;

  attackEnemy(PlayerViewModel playerViewModel) {
    _enemy.reduceLife(playerViewModel.damages);
    if (currentLife == 0) {
      if (isPreviousEnemy){
        fetchNewEnemy = true;
      }
      else {
        nextEnemy(playerViewModel);
      }

    }
    notifyListeners();
  }

  backToEnemy(PlayerViewModel playerViewModel) {
    nextEnemy(playerViewModel);
    notifyListeners();
  }

  previousEnemy() {
    _level -= 1;
    fetchNewEnemy = true;
    isPreviousEnemy = true;
    notifyListeners();
  }


  void nextEnemy(PlayerViewModel playerViewModel) {
    _level += 1;
    fetchNewEnemy = true;
    playerViewModel.player.gainCoin();
    playerViewModel.notifyListeners();
    isPreviousEnemy = false;

    fetchEnemy();
  }



  Future<bool> fetchEnemy() async {
    try {
      final enemyId = _level;
      final response = await _enemyRequest.getEnemyById(enemyId);

      if (response == null) {
        throw Exception("Aucun ennemi trouvé pour le niveau $_level");
      }

      final int baseLife = response.totalLife;

      _enemy = EnemyModel(
        name: '${response.name}  ${_level.toString()}',
        totalLife: baseLife,
        level: _level,
      );

      notifyListeners();
      return true;
    } catch (e) {
      fetchEnemy();
      print("Erreur avec la récupération de l'ennemi via GET, création d'un nouvel ennemi via POST...");

      try {
        final newEnnemy = await _enemyRequest.getEnemyById(_level % 7);

        if (newEnnemy == null) {
          throw Exception("Impossible de créer l'ennemi, les données sont invalides.");
        }

        final previousEnemyLife = _enemy.totalLife;

        final createdEnemy = await _enemyRequest.createEnemy(
            _level,
            newEnnemy.name,
            (previousEnemyLife * 1.5).toInt()
        );

        final int baseLife = createdEnemy.totalLife;

        _enemy = EnemyModel(
          name: '${createdEnemy.name}  ${_level.toString()}',
          totalLife: baseLife,
          level: _level,
        );

        notifyListeners();
        return true;
      } catch (e) {
        throw Exception("Erreur lors de la génération de l'ennemi (Level: $_level): $e");
      }
    }
  }



  get enemy => _enemy;
}