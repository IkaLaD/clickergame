import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/shop_model.dart';

class ShopService {
  final String API_URL = "http://54.38.181.30/CLICKERGAMES-BACKEND";

  Future<ShopItem> getShopById(int shopId) async {
    final url = Uri.parse('$API_URL/items/$shopId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> shopData = json.decode(response.body);
      return ShopItem.fromJson(shopData);
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<List<ShopItem>> getShopItems(int id) async {
    final url = Uri.parse('$API_URL/items/${id}/player');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Réponse de l'API: $data");

      if (data is Map<String, dynamic> && data.containsKey('data')) {
        return (data['data'] as List).map((item) => ShopItem.fromJson(item)).toList();
      } else {
        throw Exception("Format de réponse invalide: $data");
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> buyItem(int userId, int shopItemId, int level) async {
    final url = Uri.parse('$API_URL/buy');
    final Map<String, dynamic> purchaseData = {
      'id_player': userId,
      'id_enhancement': shopItemId,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(purchaseData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 409) {
      return await _updatePurchase(userId, shopItemId, level);
    } else {
      throw Exception('Erreur lors de l\'achat: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> _updatePurchase(int userId, int shopItemId, int level) async {
    final url = Uri.parse('$API_URL/items');
    final Map<String, dynamic> updateData = {
      'id_player': userId,
      'id_enhancement': shopItemId,
      'new_level': level+=1
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updateData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur lors de la mise à jour de l\'achat: ${response.statusCode}');
    }
  }
}
