import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../models/enemy_model.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class EnemyService {

  final API_URL = "http://localhost/CLICKERGAMES-BACKEND";

  Future<EnemyModel?> getEnemyById(int enemyId) async {
    final url = Uri.parse('$API_URL/ennemie/$enemyId');
    final response = await http.get(url);

    print('Réponse de l\'API: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> enemyData = json.decode(response.body);
        if (enemyData.isEmpty) {
          throw Exception("La réponse de l'API est vide.");
        }
        return EnemyModel.fromJson(enemyData);
      } catch (e) {
        throw Exception('Erreur lors du décodage des données: $e');
      }
    } else {
      throw Exception('Erreur serveur: ${response.statusCode}');
    }
  }


  Future<EnemyModel> createEnemy(int level, String name, int life) async {
    final url = Uri.parse('$API_URL/ennemie');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({
          "name": name,
          "level": level,
          "total_life": life
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> enemyData = json.decode(response.body);
      return EnemyModel.fromJson(enemyData);
    } else {
      throw Exception('Erreur lors de la création de l\'ennemi: ${response.statusCode}');
    }
  }
}
