import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/cartPage.dart';
import 'package:mobile/pages/products.dart';
import 'package:provider/provider.dart';

import '../cartWidget/cart.dart';
import '../modelWidgets/getCart.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import '../modelWidgets/getProducts.dart';
import 'HomePage.dart';

class ProductDetails extends StatefulWidget {
  final int productId;
  final int categoryId;
  final String saleMethod;
  const ProductDetails(
      {Key? key,
      required this.productId,
      required this.categoryId,
      required this.saleMethod})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool showProducts = false;
  late int categoryId = widget.categoryId;
  bool showCart = false;

  @override
  Widget build(BuildContext context) {
    if (showProducts) {
      return ProductsPage(
          categoryId: categoryId, saleMethod: widget.saleMethod);
    } else if (showCart) {
      return Cart(saleMethod: widget.saleMethod);
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
                    showProducts = true;
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
        body:
            Consumer<ProductsProvider>(builder: (context, productsProvider, _) {
          List allProducts = productsProvider.productsList;
          List selectedProduct = allProducts
              .where((product) =>
                  product.category["id"] == widget.categoryId &&
                  product.id == widget.productId)
              .toList();
          if (selectedProduct[0].addons != null) {
            _showAddonDialog(selectedProduct[0]);
          }
          return Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(width: 500),
                CachedNetworkImage(
                  width: 150,
                  height: 150,
                  imageUrl: selectedProduct[0].image,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(width: 20),
                Text(
                  selectedProduct[0].libelle,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  selectedProduct[0].priceTtc + " €",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 100),
                Container(
                  margin: EdgeInsets.all(50),
                  child: Text(
                    selectedProduct[0].description,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(width: 100),
                GestureDetector(
                  onTap: () {
                    CartProvider cartProvider =
                        Provider.of<CartProvider>(context, listen: false);
                    cartProvider.addToCart(selectedProduct[0]);
                    setState(() {
                      showCart = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(60),
                    padding: EdgeInsets.all(60),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "ajouter",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
        persistentFooterButtons: [
          GestureDetector(
            onTap: () {
              setState(() {
                showCart = true;
              });
            },
            child: CartContain(),
          )
        ],
      );
    }
  }

  void _showAddonDialog(Products product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Addons pour ${product.libelle}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Prix du produit : ${product.priceTtc} €'),
                const Text('Addons disponibles :'),
                for (var addon in product.addons!)
                  ListTile(
                    title: Text(addon.libelle),
                    subtitle: Text('Prix: ${addon.priceTtc} €'),
                    leading: Image.network(
                      addon.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCartAddon(product, addon);

                        setState(() {
                          showCart = true;
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                ListTile(
                  title: const Text('Ajouter au panier sans addon'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(product);

                      setState(() {
                        showCart = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
