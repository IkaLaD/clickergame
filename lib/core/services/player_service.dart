

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/player_model.dart';
import 'package:http/http.dart' as http;

class PlayerService {

  final API_URL = "http://54.38.181.30/CLICKERGAMES-BACKEND";

  Future<PlayerModel?> getPlayerById(int playerId) async {
    final url = Uri.parse('$API_URL/player/$playerId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> playerData = json.decode(response.body);

      return PlayerModel.fromJson(playerData);
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchLeaderBoard() async {
    final url = Uri.parse('$API_URL/player/leaderboard');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }
}