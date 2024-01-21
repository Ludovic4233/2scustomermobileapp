import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mobile/modelWidgets/getUserInfo.dart';
import 'package:provider/provider.dart';

import '../appBarWidget/CustomAppBar.dart';
import '../cartWidget/cart.dart';
import '../modelWidgets/getSaleMethod.dart';
import 'cartPage.dart';

class BodyHome extends StatefulWidget {
  const BodyHome({Key? key, required this.showQrPopup}) : super(key: key);

  final VoidCallback showQrPopup;

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  bool showCart = false;
  String saleMethod = '';

  @override
  Widget build(BuildContext context) {
    if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      return Scaffold(
        appBar: CustomAppBar(),
        body:
            Consumer<UserInfoProvider>(builder: (context, userInfoProvider, _) {
          String capitalizeFirstLetter(String input) {
            if (input.isEmpty) {
              return input;
            }
            return input[0].toUpperCase() + input.substring(1).toLowerCase();
          }

          String firstnameUser = "${userInfoProvider.userData?.firstName}";
          firstnameUser = capitalizeFirstLetter(firstnameUser);

          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Bonjour ${firstnameUser}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 30),
                    IconButton(
                      onPressed: widget.showQrPopup,
                      icon: Icon(Icons.qr_code_2, size: 50),
                    ),
                  ],
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 300.0,
                  autoPlay: true,
                  // autoPlayInterval: Duration(seconds: 1),
                  // autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.6,
                ),
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        // decoration: BoxDecoration(color: Colors.blue),
                        child: Center(
                          child: Image(
                              image: AssetImage("asset/images/promo$i.png")),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              Container(
                padding: const EdgeInsets.all(50),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: Offset(4.0, 4.0),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Vos Commandes préférés !",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                    ),
                    Text("Menu Big Tasty"),
                    Container(
                      padding: const EdgeInsets.all(8),
                    ),
                    Text("Nuggets boite de 6"),
                    Container(
                      padding: const EdgeInsets.all(8),
                    ),
                    Text("eau cristaline"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(50),
              ),
              Container(
                height: 150,
                width: double.infinity,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dernières commandes'),
                  ],
                ),
              ),
            ],
          ));
        }),
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
