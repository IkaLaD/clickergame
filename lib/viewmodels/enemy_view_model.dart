import 'package:flutter/material.dart';
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

  attackEnemy(int damages) {
    _enemy.reduceLife(damages);
    if (currentLife == 0) {
      nextEnemy();
    }
    notifyListeners();
  }

  nextEnemy() {
    _level += 1;
    fetchNewEnemy = true;
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