import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../pages/LoginPage.dart';

class BillingAndShippingAdresse with ChangeNotifier {
  Map<String, dynamic> adresses = {};

  Future<void> fetchAdresse() async {
    await dotenv.load();
    var urlApi = dotenv.env['API_URL'];
    try {
      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('$urlApi/api/get-customer-addresses'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("---adresses---");
        adresses = responseData;
        adresses.forEach((key, value) {
          print("$key: $value");
        });

        notifyListeners();
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
      throw Exception('Failed to fetch Adresse details');
    }
  }
}
