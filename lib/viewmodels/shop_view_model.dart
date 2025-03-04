import 'package:flutter/material.dart';
import 'package:untitled1/models/player_model.dart';
import 'package:untitled1/viewmodels/player_view_model.dart';
import '../models/shop_model.dart';

class ShopViewModel extends ChangeNotifier {
  final List<ShopItem> _items = [
    ShopItem(name: 'Épée en bois', price: 100, attack: 5),
    ShopItem(name: 'Épée en pierre', price: 80, attack: 10),
    ShopItem(name: 'Potion de force', price: 50, attack: 15),
    ShopItem(name: 'Arc en argent', price: 150, attack: 25),
  ];

  final PlayerViewModel _player;

  ShopViewModel(this._player);

  List<ShopItem> get items => _items;
  int get xp => _player.player.totalexp;

  bool canAfford(int price) {
    return _player.player.totalexp >= price;
  }

  void purchaseItem(int price, int attack) {
    if (canAfford(price)) {
      _player.player.totalexp -= price;
      _player.player.augments.add(attack);
      notifyListeners();
    }
  }
}

