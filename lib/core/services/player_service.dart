

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/player_model.dart';

class PlayerService {

  Future<PlayerModel?> getPlayerById(int playerId) async {
    try {
      final String response = await rootBundle.loadString('assets/json/players.json');
      final List data = json.decode(response);

      final enemyData = data[playerId];

      if (enemyData != null) {
        return PlayerModel.fromJson(enemyData);
      }
      return null;
    } catch (e) {
      print("Erreur lors de la récupération du joueur: $e");
      return null;
    }
  }
}