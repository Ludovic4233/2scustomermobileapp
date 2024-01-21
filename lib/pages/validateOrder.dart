import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/categories.dart';
import 'package:provider/provider.dart';

import '../modelWidgets/getBillingAndShippingAdresse.dart';
import '../modelWidgets/getCart.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import '../modelWidgets/getSaleMethod.dart';
import '../modelWidgets/sendOrder.dart';
import 'HomePage.dart';
import 'cartPage.dart';

class ValidateOrder extends StatefulWidget {
  final List cartUnique;
  const ValidateOrder({Key? key, required this.cartUnique}) : super(key: key);

  @override
  State<ValidateOrder> createState() => _ValidateOrderState();
}

class _ValidateOrderState extends State<ValidateOrder> {
  var showCart = false;
  var showCategories = false;
  String saleMethod = '';

  @override
  Widget build(BuildContext context) {
    if (showCategories) {
      return Categories(saleMethod: saleMethod);
    } else if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: double.infinity,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 30,
                onPressed: () {
                  setState(() {
                    showCart = true;
                    saleMethod =
                        Provider.of<SaleMethodProvider>(context, listen: false)
                            .saleMethodChoice;
                  });
                },
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
                child: Center(
                  child: Consumer<CompanyDetailsProvider>(
                      builder: (context, companyDetailsProvider, _) {
                    return CachedNetworkImage(
                      imageUrl: companyDetailsProvider.image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  }),
                ),
              )),
              SizedBox(width: 45),
            ],
          ),
        ),
        body: Consumer<BillingAndShippingAdresse>(
            builder: (context, billingAndShippingAdresse, _) {
          String address = billingAndShippingAdresse
              .adresses["billingAddresses"][0]["address"];
          String postaleCode = billingAndShippingAdresse
              .adresses["billingAddresses"][0]["postalCode"];
          String city =
              billingAndShippingAdresse.adresses["billingAddresses"][0]["city"];
          var totalPrice =
              Provider.of<CartProvider>(context, listen: false).totalPrice;
          saleMethod = Provider.of<SaleMethodProvider>(context, listen: false)
              .saleMethodChoice;
          if (saleMethod == 'locally') {
            saleMethod = 'Sur place';
          } else if (saleMethod == 'takeaway') {
            saleMethod = "À emporter";
          } else if (saleMethod == 'inDelivery') {
            saleMethod = 'En livraison';
          }
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "RÉCAPITULATIF",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.cartUnique.length,
                    itemBuilder: (BuildContext context, int index) {
                      var product = widget.cartUnique[index];

                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(product.quantity.toString()),
                            Text(product.libelle),
                          ],
                        ),
                      );
                    }),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Totale: $totalPrice €",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  saleMethod,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Adresse de facturation",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Column(
                children: [
                  Text("$address"),
                  Text("$postaleCode"),
                  Text("$city"),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Provider.of<SendOrderProvider>(context, listen: false)
                            .saleMethodChoice =
                        Provider.of<SaleMethodProvider>(context, listen: false)
                            .saleMethodChoice;

                    var responseOrder =
                        Provider.of<SendOrderProvider>(context, listen: false)
                            .sendOrder(widget.cartUnique);
                    _showSendOrderPopup(responseOrder);

                    Provider.of<SendOrderProvider>(context, listen: false)
                            .setBilling =
                        billingAndShippingAdresse.adresses["billingAddresses"];

                    Provider.of<SendOrderProvider>(context, listen: false)
                            .setShipping =
                        billingAndShippingAdresse.adresses["shippingAddresses"];
                  });
                },
                child: Text(
                  "envoyer la commande !",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
              )
            ],
          );
        }),
      );
    }
  }

  void _showSendOrderPopup(responseOrder) {
    String response = responseOrder == 0
        ? "Échec de la commande"
        : "Commande réussie avec succès";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CartProvider>(builder: (context, cartProvider, _) {
          return AlertDialog(
            title: Text("Commande"),
            content: Text(response),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    Provider.of<CartProvider>(context, listen: false)
                        .cleanCart(cartProvider.cartItems);
                    showCategories = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.close),
              ),
            ],
          );
        });
      },
    );
  }
}
