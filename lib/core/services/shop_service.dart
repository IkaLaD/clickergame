import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/shop_model.dart';

class ShopService {
  final String API_URL = "http://54.38.181.30/CLICKERGAMES-BACKEND";

  Future<ShopItem> getShopById(int shopId) async {
    final url = Uri.parse('$API_URL/shop/$shopId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> shopData = json.decode(response.body);
      return ShopItem.fromJson(shopData);
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<List<ShopItem>> getShopItems() async {
    final url = Uri.parse('$API_URL/shop/items');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> itemsData = json.decode(response.body);
      return itemsData.map((item) => ShopItem.fromJson(item)).toList();
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }
}
