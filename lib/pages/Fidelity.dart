import 'package:flutter/material.dart';
import 'package:mobile/appBarWidget/CustomAppBar.dart';

import '../cartWidget/cart.dart';
import '../modelWidgets/getSaleMethod.dart';
import 'cartPage.dart';
import 'package:provider/provider.dart';

class Fidelity extends StatefulWidget {
  const Fidelity({super.key});

  @override
  State<Fidelity> createState() => _FidelityState();
}

class _FidelityState extends State<Fidelity> {
  var showCart = false;
  String saleMethod = '';
  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Column(
          children: [
            Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Mon programme fidélité",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )),
            Container(
                height: 200,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vous avez: _ points'),
                  ],
                )),
          ],
        ),
        persistentFooterButtons: [
          GestureDetector(
            onTap: () {
              setState(() {
                showCart = true;
                saleMethod =
                    Provider.of<SaleMethodProvider>(context, listen: false)
                        .saleMethodChoice;
              });
            },
            child: CartContain(),
          )
        ],
      );
    }
  }
}
