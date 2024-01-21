import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modelWidgets/getCompagnyDetails.dart';
import '../pages/HomePage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: double.infinity,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
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
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                );
              }),
            ),
          )),
          //SizedBox(width: 45),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
