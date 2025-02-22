
import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/enemy_model.dart';

class EnemyService {

  Future<EnemyModel?> getEnemyById(int enemyId) async {
    try {
      final String response = await rootBundle.loadString('assets/json/enemies.json');
      final List data = json.decode(response);

      final enemyData = data[enemyId%7];

      if (enemyData != null) {
        return EnemyModel.fromJson(enemyData);
      }
      return null;
    } catch (e) {
      print("Erreur lors de la récupération de l'ennemi: $e");
      return null;
    }
  }

}