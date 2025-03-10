import 'dart:convert';
import 'package:http/http.dart' as http;

class PlayerModel {
  final String pseudo;
  late int totalexp;
  late int level;
  late List augments;
  late int coins;
  int id;
  int attack;
  int progress;

  static const String apiUrl = "http://54.38.181.30/CLICKERGAMES-BACKEND";

  PlayerModel({
    required this.pseudo,
    required this.totalexp,
    required this.level,
    required this.augments,
    required this.coins,
    required this.id,
    required this.attack,
    required this.progress
  });

  bool get canBuyAugment => totalexp >= 100*level;

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    final playerData = json['data'][0];
    return PlayerModel(
        pseudo: playerData['pseudo'] ?? "Pseudo unknown",
        totalexp: playerData['total_experience'] ?? 0,
        level: playerData['level'] ?? 0,
        augments: json['augments'] ?? [],
        coins: playerData['coins'] ?? 0,
        id: playerData['id_player'],
        attack: playerData['attack'],
        progress: playerData['progress']
    );
  }

  Future<bool> updateLevel(int playerId, int newLevel) async {
    return await _updatePlayer(playerId, {"level": newLevel});
  }

  Future<bool> updateCoins(int playerId, int newCoins) async {
    return await _updatePlayer(playerId, {"coins": newCoins});
  }

  Future<bool> updateTotalExp(int playerId, int newTotalExp) async {
    return await _updatePlayer(playerId, {"total_experience": newTotalExp});
  }

  Future<bool> updateAttack(int playerId, int newAttack) async {
    return await _updatePlayer(playerId, {"attack": newAttack});
  }

  Future<bool> updateProgress(int playerId, int newProgress) async {
    return await _updatePlayer(playerId, {"progress": newProgress});
  }

  Future<bool> _updatePlayer(int playerId, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('$apiUrl/player/$playerId');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print("Mise à jour réussie : $updatedData");
        return true;
      } else {
        print("Erreur serveur : ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Erreur lors de la mise à jour du joueur : $e");
      return false;
    }
  }

  void gainExp(int exp) {
    totalexp += exp;
    updateTotalExp(id, totalexp);
  }

  void _levelUp() {
    level += 1;
    updateLevel(id, level);
  }

  bool buyAugment() {
    if (totalexp >= 100) {
      totalexp -= 100;

      attack = (attack * 1.3).toInt();

      _levelUp();
      updateTotalExp(id, totalexp);
      updateAttack(id, attack);

      return true;
    }
    return false;
  }




  int getDamages() {
    int damages = 1;
    for (int i = 0; i < augments.length; i++) {
      damages += augments[i] as int;
    }
    return damages;
  }

  void gainCoin() {
    coins += 1;
    updateCoins(id, coins);
  }

  void increaseAttack(int value) {
    attack += value;
    updateAttack(id, attack);
  }

  void increaseProgress(int value) {
    progress += value;
    updateProgress(id, progress);
  }
}
