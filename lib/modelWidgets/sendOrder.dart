import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../pages/loginPage.dart';

class SendOrderProvider with ChangeNotifier {
  String _saleMethodChoice = '';
  String get saleMethodChoice => _saleMethodChoice;

  set saleMethodChoice(String newValue) {
    _saleMethodChoice = newValue;
    notifyListeners();
  }

  List _billingAddresses = [];
  List get billingAddresses => _billingAddresses;

  set setBilling(List billing) {
    _billingAddresses = billing;
    notifyListeners();
  }

  List _shippingAddresses = [];
  List get shippingAddresses => _shippingAddresses;

  set setShipping(List shipping) {
    _shippingAddresses = shipping;
    notifyListeners();
  }

  Future<int> sendOrder(List products) async {
    try {
      await dotenv.load();
      final apiUrl = dotenv.env['API_URL']!;
      List<Map<String, dynamic>> orderItems = [];
      for (var product in products) {
        orderItems.add({
          'product': product.id,
          'quantity': product.quantity,
        });
      }

      print('Articles de commande : $orderItems');

      Map<String, dynamic> orderData = {
        'device': 'mobileApp',
        'saleMethod': saleMethodChoice,
        'orderStatus': 'pending',
        'orderItems': orderItems,
        'billingAddress': billingAddresses,
        'shippingAddress': shippingAddresses,
      };

      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };

      print('Données de commande : $orderData');

      final response = await http.post(
        Uri.parse('$apiUrl/api/add-order'),
        headers: headers,
        body: jsonEncode(orderData),
      );

      print(response.body);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        int number = json['number'];
        String orderDateStr = json['date'];
        String orderHourStr = json['hour'];
        String saleMethodValue = json['saleMethod']['libelle'];
        String qrCode = json['qrCode'];
        String customerName = json["customerName"];

        DateTime orderDateTime = DateFormat('dd/MM/yyyy HH:mm:ss')
            .parse('$orderDateStr $orderHourStr');

        print("number: ${number}");
        print("orderDateTime: ${orderDateTime}");
        print("saleMethodValue: ${saleMethodValue}");
        print("qrCode: ${qrCode}");
        print("customerName: ${customerName}");

        print('Commande envoyée avec succès');
        return number;
      } else {
        print('Échec de l\'envoi de la commande');
        return 0;
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la commande : $e');
      return 0;
    }
  }
}
