import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../appBarWidget/CustomAppBar.dart';
import '../cartWidget/cart.dart';
import '../modelWidgets/getSaleMethod.dart';
import 'cartPage.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool showCart = false;
  String saleMethod = '';
  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      return Scaffold(
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mon compte',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mes informations',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mes commandes',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mes moyens de paiement',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mes adresses',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'gestion des notifications',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'gestion des données personnelles',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                )),
          ],
        )),
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
