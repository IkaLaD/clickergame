import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../models/shop_model.dart';
import '../core/services/shop_service.dart';
import '../viewmodels/player_view_model.dart';

class ShopViewModel extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  PlayerViewModel _player;

  List<ShopItem> _items = [];

  ShopViewModel(this._player) {
    fetchShopItems();
  }

  List<ShopItem> get items => _items;

  Future<void> fetchShopItems() async {
    print("actualisé");
    try {
      _items = await _shopService.getShopItems(_player.player.id);
      print(_items);
      notifyListeners();
    } catch (e) {
      throw Exception("Erreur lors de la récupération des objets de la boutique: $e");
    }
  }

  bool canAfford(int price) {
    return _player.coins >= price;
  }

  void purchaseItem(ShopItem item) {
    if (canAfford(item.price)) {
      _player.player.coins -= item.price;
      _player.player.updateCoins(_player.player.id, _player.player.coins);
      _player.player.attack += item.attack;
      _player.player.updateAttack(_player.player.id, _player.player.attack);
      _player.notifyListeners();
      
      
      _shopService.buyItem(_player.player.id, item.id, item.level);

      String baseName = _getBaseName(item.name);

      ShopItem upgradedItem = ShopItem(
        name: "$baseName ${item.level + 1}",
        price: (item.price * 1.5).toInt(),
        attack: (item.attack * 1.5).toInt(),
        level: item.level + 1,
          id: item.id
      );

      int index = _items.indexWhere((i) => _getBaseName(i.name) == baseName);
      if (index != -1) {
        _items[index] = upgradedItem;
      }

      notifyListeners();
    }
  }

  String _getBaseName(String name) {
    return name.replaceAll(RegExp(r' \d+$'), '');
  }



  void updateData() {
    notifyListeners();
  }
}
