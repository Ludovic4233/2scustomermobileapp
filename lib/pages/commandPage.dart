import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modelWidgets/getSaleMethod.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../appBarWidget/CustomAppBar.dart';
import '../cartWidget/cart.dart';
import '../modelWidgets/getActivatedSalesMethod.dart';
import 'cartPage.dart';
import 'categories.dart';

class Command extends StatefulWidget {
  const Command({Key? key}) : super(key: key);

  @override
  State<Command> createState() => _CommandState();
}

class _CommandState extends State<Command> {
  bool showCategories = false;
  bool showCart = false;

  String saleMethod = '';
  String error = "";

  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      if (showCategories) {
        return Categories(saleMethod: saleMethod);
      } else {
        return Scaffold(
          appBar: CustomAppBar(),
          body: Consumer<ActivatedSalesMethods>(
              builder: (context, activatedSalesMethods, _) {
            return ListView.builder(
                itemCount: activatedSalesMethods.salesMethodsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        showCategories = true;
                        saleMethod = activatedSalesMethods
                            .salesMethodsList[index]["value"];
                        Provider.of<SaleMethodProvider>(context, listen: false)
                            .saleMethodChoice = saleMethod;
                      });
                    },
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            width: 40,
                            height: 40,
                            imageUrl: activatedSalesMethods
                                .salesMethodsList[index]["image"],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(width: 10),
                          Text(activatedSalesMethods.salesMethodsList[index]
                              ["libelle"]),
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
