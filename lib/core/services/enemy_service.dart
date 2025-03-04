import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../../models/enemy_model.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';

class EnemyService {

  final API_URL = "http://54.38.181.30/CLICKERGAMES-BACKEND";

  Future<EnemyModel?> getEnemyById(int enemyId) async {
      final url = Uri.parse('$API_URL/ennemie/${enemyId%7}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> enemyData = json.decode(response.body);

        return EnemyModel.fromJson(enemyData);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }

  }

}
