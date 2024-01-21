import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/validateOrder.dart';
import 'package:provider/provider.dart';
import '../cartWidget/cart.dart';
import '../modelWidgets/getCart.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import '../modelWidgets/getSaleMethod.dart';
import 'HomePage.dart';
import 'categories.dart';

class Cart extends StatefulWidget {
  final String saleMethod;
  const Cart({Key? key, required this.saleMethod}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  bool showCategories = false;
  bool validateOrder = false;
  List cartUnique = [];

  @override
  Widget build(BuildContext context) {
    if (validateOrder) {
      return ValidateOrder(cartUnique: cartUnique);
    } else if (showCategories) {
      return Categories(saleMethod: widget.saleMethod);
    } else {
      return Scaffold(
        appBar: AppBar(
          leadingWidth: double.infinity,
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            ],
          ),
        ),
        body: Consumer<CartProvider>(builder: (context, cartProvider, _) {
          List cartItems = cartProvider.cartItems;
          List uniqueCartItems = [];
          for (var product in cartItems) {
            // Vérifie si le produit existe déjà dans la liste unique
            if (!uniqueCartItems.contains(product)) {
              uniqueCartItems.add(product);
              // Ajoute le produit unique
            }
          }
          //pour envoyer le panier dans ValidateOrder()
          cartUnique = uniqueCartItems;
          return Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      "PANIER ",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Consumer<SaleMethodProvider>(
                      builder: (context, saleMethodProvider, _) {
                    String saleMethod = saleMethodProvider.saleMethodChoice;
                    if (saleMethod == 'locally') {
                      saleMethod = 'Sur place';
                    } else if (saleMethod == 'takeaway') {
                      saleMethod = "À emporter";
                    } else if (saleMethod == 'inDelivery') {
                      saleMethod = 'En livraison';
                    }
                    return Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        saleMethod,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: uniqueCartItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      var product = uniqueCartItems[index];
                      int productCount =
                          cartItems.where((item) => item == product).length;
                      product.quantity = productCount;

                      return ListTile(
                          title: Text(product.libelle),
                          leading: CachedNetworkImage(
                            imageUrl: product.image,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          subtitle: Text('Prix: ${product.priceTtc} €'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeProductCart(product);
                                },
                                icon: Icon(Icons.remove_circle_outline),
                              ),
                              Text("${productCount}"),
                              IconButton(
                                onPressed: () {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .addToCart(product);
                                },
                                icon: Icon(Icons.add_circle_outline),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  Provider.of<CartProvider>(context,
                                          listen: false)
                                      .removeSameProdust(product, cartItems);
                                },
                              )
                            ],
                          ));
                    }),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showCategories = true;
                          });
                        },
                        child: Text(
                          "continuer mes achats",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            validateOrder = true;
                          });
                        },
                        child: Text(
                          "valider mon panier",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Provider.of<CartProvider>(context, listen: false)
                                .cleanCart(cartItems);
                          });
                        },
                        child: Text(
                          "Vider le panier",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),
              ),
            ],
          );
        }),
        persistentFooterButtons: [
          CartContain(),
        ],
      );
    }
  }
}
