import 'package:flutter/material.dart';
import 'package:untitled1/models/player_model.dart';
import 'package:untitled1/viewmodels/player_view_model.dart';
import '../models/shop_model.dart';

class ShopViewModel extends ChangeNotifier {
  final List<ShopItem> _items = [
    ShopItem(name: 'Épée en bois', price: 10, attack: 5),
    ShopItem(name: 'Épée en pierre', price: 20, attack: 10),
    ShopItem(name: 'Potion de force', price: 25, attack: 15),
    ShopItem(name: 'Arc en argent', price: 30, attack: 25),
  ];

  final PlayerViewModel _player;

  ShopViewModel(this._player);

  List<ShopItem> get items => _items;

  bool canAfford(int price) {
    return _player.player.coins >= price;
  }

  void purchaseItem(int price, int attack) {
    if (canAfford(price)) {
      _player.player.coins -= price;
      _player.player.augments.add(attack);
      _player.notifyListeners();
      notifyListeners();
    }
  }
}

