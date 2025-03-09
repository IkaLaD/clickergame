class ShopItem {
  final String name;
  final int price;
  final int attack;

  ShopItem({required this.name, required this.price, required this.attack});

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      name: json['name'] ?? 'Unknown Item',
      price: json['price'] ?? 0,
      attack: json['attack'] ?? 0,
    );
  }
}