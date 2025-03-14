class ShopItem {
  final String name;
  final int price;
  final int attack;
  final int level;

  ShopItem({
    required this.name,
    required this.price,
    required this.attack,
    this.level = 1,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      name: json['name'] ?? 'Unknown Item',
      price: json['coin_cost'] ?? 0,
      attack: json['boost_value'] ?? 0,
      level: json['level'] ?? 1,
    );
  }

  upgrade() {
    return ShopItem(
      name: "$name +${level + 1}",
      price: (price * 1.5).toInt(),
      attack: (attack * 1.5).toInt(),
      level: level + 1,
    );
  }
}
