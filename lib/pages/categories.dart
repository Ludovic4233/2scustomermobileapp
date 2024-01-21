import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/pages/commandPage.dart';
import 'package:mobile/pages/products.dart';
import 'package:provider/provider.dart';

import '../cartWidget/cart.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import '../modelWidgets/getProductCategories.dart';
import 'HomePage.dart';
import 'cartPage.dart';

class Categories extends StatefulWidget {
  final String saleMethod;
  const Categories({Key? key, required this.saleMethod}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  bool showProducts = false;
  int selectedCategoryId = 0;
  bool showCategories = true;
  bool showCart = false;

  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: widget.saleMethod);
    } else {
      if (showProducts) {
        return ProductsPage(
          categoryId: selectedCategoryId,
          saleMethod: widget.saleMethod,
        );
      } else if (showCategories == false) {
        return Command();
      } else {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: double.infinity,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onPressed: () {
                    setState(() {
                      showProducts = false;
                      showCategories = false;
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
          body: Consumer<CategoriesProvider>(
              builder: (context, categoriesProvider, _) {
            return ListView.builder(
                itemCount: categoriesProvider.productCategoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        showProducts = true;
                        selectedCategoryId = categoriesProvider
                            .productCategoriesList[index]["id"];
                      });
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            width: 80,
                            height: 80,
                            imageUrl: categoriesProvider
                                .productCategoriesList[index]["image"],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(width: 10),
                          Text(
                            categoriesProvider.productCategoriesList[index]
                                ["libelle"],
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios)
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
