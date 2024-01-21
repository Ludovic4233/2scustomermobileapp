import 'package:flutter/material.dart';

class SaleMethodProvider with ChangeNotifier {
  String _saleMethodChoice = '';
  String get saleMethodChoice => _saleMethodChoice;

  set saleMethodChoice(String newValue) {
    _saleMethodChoice = newValue;
    notifyListeners();
  }
}
