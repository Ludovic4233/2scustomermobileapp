import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:mobile/modelWidgets/getCompagnyDetails.dart';

import 'package:mobile/pages/MyAccount.dart';
import 'package:mobile/pages/CommandPage.dart';

import 'package:mobile/pages/fidelity.dart';
import 'package:mobile/pages/googleMap.dart';

import 'package:provider/provider.dart';

import '../modelWidgets/getUserInfo.dart';
import 'bodyHomePage.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyDetailsProvider>(
        builder: (context, companyDetailsProvider, _) {
      bool _fidelity =
          companyDetailsProvider.companySettings["isFidelityActive"] ?? false;
      if (_fidelity == true) {
        return Scaffold(
          body: [
            BodyHome(showQrPopup: _showQrPopup),
            MapGoogle(),
            Command(),
            Fidelity(),
            MyAccount(),
          ][_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            iconSize: 40,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_location),
                label: 'Ma boutique',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: 'commander',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.star),
                label: 'fidélité',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'mon compte',
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          body: [
            BodyHome(showQrPopup: _showQrPopup),
            MapGoogle(),
            Command(),
            MyAccount(),
          ][_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.blue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            iconSize: 40,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_location),
                label: 'Ma boutique',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: 'commander',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.user),
                label: 'mon compte',
              ),
            ],
          ),
        );
      }
    });
  }

  void _showQrPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<UserInfoProvider>(
            builder: (context, userInfoProvider, _) {
          return AlertDialog(
            title: Text("QR Code"),
            content: PrettyQr(
              size: 200,
              data: '${userInfoProvider.userData?.qrCode}',
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Close"),
              ),
            ],
          );
        });
      },
    );
  }
}
