import 'package:flutter/material.dart';

import 'getProducts.dart';

class CartProvider with ChangeNotifier {
  List _cartItems = [];

  List get cartItems => _cartItems;

  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  void addToCart(product) {
    _cartItems.add(product);
    _totalPrice = _calculateTotalPrice();
    notifyListeners();
  }

  void removeProductCart(product) {
    _cartItems.remove(product);
    _totalPrice = _calculateTotalPrice();
    notifyListeners();
  }

  void removeSameProdust(product, cart) {
    cart.removeWhere((item) => item == product);
    _totalPrice = _calculateTotalPrice();
    notifyListeners();
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var product in _cartItems) {
      double price = double.tryParse(product.priceTtc) ?? 0.0;
      totalPrice += price;
    }
    return totalPrice;
  }

  void addToCartAddon(Products product, Addon addon) {
    _cartItems.add(product);
    _cartItems.add(addon);
    _totalPrice = _calculateTotalPrice();
    notifyListeners();
  }

  void cleanCart(List cart) {
    cart.clear();
    notifyListeners();
  }
}
