import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modelWidgets/getProducts.dart';
import 'package:mobile/pages/categories.dart';
import 'package:mobile/pages/productDetails.dart';
import 'package:provider/provider.dart';

import '../cartWidget/cart.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import 'HomePage.dart';
import 'cartPage.dart';

class ProductsPage extends StatefulWidget {
  final int categoryId;
  final String saleMethod;

  const ProductsPage(
      {Key? key, required this.categoryId, required this.saleMethod})
      : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  bool showProductDetails = false;
  int selectedProductId = 0;
  bool showCategories = false;
  bool showCart = false;

  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: widget.saleMethod);
    } else {
      if (showProductDetails) {
        return ProductDetails(
            productId: selectedProductId,
            categoryId: widget.categoryId,
            saleMethod: widget.saleMethod);
      } else if (showCategories) {
        return Categories(saleMethod: widget.saleMethod);
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
                      showProductDetails = false;
                      showCategories = true;
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
          body: Consumer<ProductsProvider>(
              builder: (context, productsProvider, _) {
            List allProducts = productsProvider.productsList;
            List selectedCategoryProducts = allProducts
                .where((product) => product.category["id"] == widget.categoryId)
                .toList();

            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns in the grid
                  mainAxisSpacing: 0, // Space between columns
                  crossAxisSpacing: 0, // Space between rows
                ),
                itemCount: selectedCategoryProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        showProductDetails = true;
                        selectedProductId = selectedCategoryProducts[index].id;
                      });
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl: selectedCategoryProducts[index].image,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(width: 20),
                          Text(
                            selectedCategoryProducts[index].libelle,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            selectedCategoryProducts[index].priceTtc + " €",
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  );
                });
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
  }
}
