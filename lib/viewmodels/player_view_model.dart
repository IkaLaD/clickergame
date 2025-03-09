import 'package:flutter/material.dart';
import '../core/services/player_service.dart';
import '../models/player_model.dart';

class PlayerViewModel extends ChangeNotifier {
  final PlayerService _playerRequest = PlayerService();
  late PlayerModel _player;

  int get level => _player.level;
  String get pseudo => _player.pseudo;
  int get coins => _player.coins;

  void gainExp(int exp) {
    _player.gainExp(exp);
    notifyListeners();
  }

  void buyAugment() {
    if (_player.buyAugment()) {
      notifyListeners();
    }
  }

  Future<bool> fetchPlayer(int id) async {
    try {
      final player = (await _playerRequest.getPlayerById(id))!;
      _player = player;
      notifyListeners();
      return true;
    } catch (e) {
      throw Exception("Erreur lors de la récupération du joueur: $e");
    }
  }

  PlayerModel get player => _player;
  int get damages => _player.getDamages();

  void gainCoin() {
    _player.gainCoin();
    notifyListeners();
  }
}
