import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/shop_model.dart';

class ShopService {
  final API_URL = "http://localhost/CLICKERGAMES-BACKEND";


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

  Future<List<ShopItem>> getShopItems() async {
    final url = Uri.parse('${API_URL}/items');

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


}
