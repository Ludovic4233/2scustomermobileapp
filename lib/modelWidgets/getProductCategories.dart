import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../pages/loginPage.dart';

class CategoriesProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _productCategoriesList = [];
  List<Map<String, dynamic>> get productCategoriesList =>
      _productCategoriesList;

  Future<void> fetchProductCategories() async {
    await dotenv.load();
    var urlApi = dotenv.env['API_URL'];
    try {
      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('$urlApi/api/get-product-categories'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _productCategoriesList = List<Map<String, dynamic>>.from(responseData);
        for (var productCategorie in _productCategoriesList) {
          int rank = productCategorie["rank"];
          int id = productCategorie["id"];
          String libelle = productCategorie["libelle"];
          String abbreviatedClassification =
              productCategorie["abbreviatedClassification"];
          String image = productCategorie["image"];

          print('rank: $rank');
          print('id: $id');
          print('libelle: $libelle');
          print('abbreviatedClassification: $abbreviatedClassification');
          print('Image URL: $image');
          print('-----------------------');
        }

        notifyListeners();
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
      throw Exception('Failed to fetch product categories details');
    }
  }
}
