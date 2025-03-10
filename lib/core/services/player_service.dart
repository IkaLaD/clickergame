import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/player_model.dart';

class PlayerService {
  final String API_URL = "http://54.38.181.30/CLICKERGAMES-BACKEND";

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

  Future<bool> updatePlayer(int playerId, {int? level, int? coins, int? totalExperience}) async {
    final url = Uri.parse('$API_URL/player/$playerId');

    final Map<String, dynamic> data = {};
    if (level != null) data["level"] = level;
    if (coins != null) data["coins"] = coins;
    if (totalExperience != null) data["total_experience"] = totalExperience;

    if (data.isEmpty) {
      throw Exception("Aucune donnée à mettre à jour.");
    }

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Échec de la mise à jour du joueur: ${response.statusCode}");
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
