import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../pages/loginPage.dart';

class Addon {
  final int id;
  final String libelle;
  final String priceTtc;
  final String image;
  int? quantity = 1;

  Addon({
    required this.id,
    required this.libelle,
    required this.priceTtc,
    required this.image,
    int? quantity,
  });
}

class Products {
  final bool menu;
  final int id;
  final String libelle;
  final String priceTtc;
  int? stock;
  final Map category;
  int? quantity = 0;
  final List<Map<String, dynamic>?> options;
  List<Addon>? addons;
  final String image;
  final List<Map<String, dynamic>>? steps;
  final String? description;

  Products({
    required this.menu,
    required this.id,
    required this.libelle,
    required this.priceTtc,
    this.stock,
    required this.category,
    int? quantity,
    required this.options,
    this.addons,
    required this.image,
    this.steps,
    this.description,
  });
}

class ProductsProvider extends ChangeNotifier {
  List<Products> _productsList = [];
  List<Products> get productsList => _productsList;

  Future<void> fetchProduct() async {
    await dotenv.load();
    var urlApi = dotenv.env['API_URL'];
    try {
      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('$urlApi/api/get-products'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<Products> fetchProductsList = [];
        for (var productData in responseData) {
          Products product = Products(
            menu: productData["menu"],
            id: productData["id"],
            libelle: productData["libelle"],
            priceTtc: productData["priceTtc"],
            stock: productData["stock"] ?? 0,
            category: productData["category"],
            options:
                List<Map<String, dynamic>>.from(productData["options"] ?? []),
            addons: (productData["addons"] as List<dynamic>?)
                ?.map((addonData) => Addon(
                      id: addonData["id"] ?? 0,
                      libelle: addonData["libelle"] ?? '',
                      priceTtc: addonData["price"] ?? '',
                      image: addonData["image"] ?? '',
                    ))
                .toList(),
            image: productData["image"],
            steps: List<Map<String, dynamic>>.from(productData["steps"] ?? []),
            description: productData["description"] ?? '',
          );
          fetchProductsList.add(product);
          print("menu: ${productData["menu"]}");
          print("id: ${productData["id"]}");
          print("libelle: ${productData["libelle"]}");
          print("priceTtc: ${productData["priceTtc"]}");
          print("stock: ${productData["stock"]}");
          print("category: ${productData["category"]}");
          print("option: ${productData["option"]}");
          if (productData["options"] != null) {
            for (var dataOption in productData["options"]) {
              print("idOption: ${dataOption["id"]}");
              print("libelleOption: ${dataOption["libelle"]}");
              print("supplementPriceTtc: ${dataOption["supplementPriceTtc"]}");
              print("imageOption: ${dataOption["image"]}");
            }
          }
          print("addon: ${productData["addons"]}");
          if (productData["addons"] != null) {
            for (var i; i < productData["addons"].length; i++) {
              print("idAddon: ${productData["addons"][i]["id"]}");
              print("libelleAddon: ${productData["addons"][i]["libelle"]}");
              print("priceAddon: ${productData["addons"][i]["price"]}");
              print("imageAddon: ${productData["addons"][i]["image"]}");
            }
          }
          print("image: ${productData["image"]}");
          print("description: ${productData["description"]}");
          print("----------------------");
        }

        _productsList = fetchProductsList;

        notifyListeners();
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
      throw Exception('Failed to fetch product');
    }
  }
}
