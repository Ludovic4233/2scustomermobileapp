import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelWidgets/getCart.dart';

class CartContain extends StatefulWidget {
  const CartContain({super.key});

  @override
  State<CartContain> createState() => _CartContainState();
}

class _CartContainState extends State<CartContain> {
  bool showCart = false;

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CartProvider>(context, listen: false).cartItems.length >
        0) {
      return Consumer<CartProvider>(builder: (context, cartProvider, _) {
        return Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Colors.black,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Center(
                          child: Text(
                            "${cartProvider.cartItems.length}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Afficher le panier",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${cartProvider.totalPrice.toStringAsFixed(2)} €",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ));
      });
    } else {
      return SizedBox.shrink();
    }
  }
}
