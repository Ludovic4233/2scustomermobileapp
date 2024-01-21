// ignore_for_file: prefer_const_constructors

import 'package:mobile/modelWidgets/getCart.dart';
import 'package:mobile/modelWidgets/getCompagnyDetails.dart';
import 'package:mobile/modelWidgets/getSaleMethod.dart';
import 'package:mobile/modelWidgets/getUserInfo.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modelWidgets/getActivatedSalesMethod.dart';
import 'modelWidgets/getBillingAndShippingAdresse.dart';
import 'modelWidgets/getProductCategories.dart';
import 'modelWidgets/getProducts.dart';
import 'modelWidgets/sendOrder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //ChangeNotifierProvider<UserInfo>(create: (context) => UserInfo()),
          ChangeNotifierProvider<UserInfoProvider>(
              create: (context) => UserInfoProvider()),
          ChangeNotifierProvider<Auth>(create: (context) => Auth()),
          ChangeNotifierProvider<CompanyDetailsProvider>(
              create: (context) => CompanyDetailsProvider()),
          ChangeNotifierProvider<CategoriesProvider>(
              create: (context) => CategoriesProvider()),
          ChangeNotifierProvider<ActivatedSalesMethods>(
              create: (context) => ActivatedSalesMethods()),
          ChangeNotifierProvider<ProductsProvider>(
              create: (context) => ProductsProvider()),
          ChangeNotifierProvider<CartProvider>(
              create: (context) => CartProvider()),
          ChangeNotifierProvider<SaleMethodProvider>(
              create: (context) => SaleMethodProvider()),
          ChangeNotifierProvider<SendOrderProvider>(
              create: (context) => SendOrderProvider()),
          ChangeNotifierProvider<BillingAndShippingAdresse>(
              create: (context) => BillingAndShippingAdresse()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => Home(),
          },
          home: Login(),
        ));
  }
}
