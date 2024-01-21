import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../pages/loginPage.dart';

class ActivatedSalesMethods extends ChangeNotifier {
  List<Map<String, dynamic>> _salesMethodsList = [];
  List<Map<String, dynamic>> get salesMethodsList => _salesMethodsList;

  Future<void> fetchActivatedSalesMethods() async {
    await dotenv.load();
    var urlApi = dotenv.env['API_URL'];
    try {
      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('$urlApi/api/get-activated-sales-methods'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _salesMethodsList = List<Map<String, dynamic>>.from(responseData);
        for (var salesMethod in _salesMethodsList) {
          int id = salesMethod["id"];
          String libelle = salesMethod["libelle"];
          String value = salesMethod["value"];
          String description = salesMethod["description"];
          String image = salesMethod["image"];

          print('Sales Method ID: $id');
          print('Libelle: $libelle');
          print('Value: $value');
          print('Description: $description');
          print('Image URL: $image');
          print('-----------------------');
        }

        notifyListeners();
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
      throw Exception('Failed to fetch ActivatedSalesMethods details');
    }
  }
}
