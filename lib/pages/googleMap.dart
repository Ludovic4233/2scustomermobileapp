import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../appBarWidget/CustomAppBar.dart';
import '../cartWidget/cart.dart';
import '../modelWidgets/getActivatedSalesMethod.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../modelWidgets/getSaleMethod.dart';
import 'CommandPage.dart';
import 'cartPage.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => MapGoogleState();
}

class MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  bool showCart = false;
  String saleMethod = '';
  bool order = false;

  static const CameraPosition _mcdoCom = CameraPosition(
    target: LatLng(43.60888143878582, 3.8793118381492073),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    if (order) {
      return Command();
    } else if (showCart) {
      return Cart(saleMethod: saleMethod);
    } else {
      return Scaffold(
        appBar: CustomAppBar(),
        body: Consumer<CompanyDetailsProvider>(
            builder: (context, companyDetailsProvider, _) {
          final String targetAddress = companyDetailsProvider.address;

          Future<void> _goToTargetLocation() async {
            final coordinates = await GeocodingPlatform.instance
                .locationFromAddress(targetAddress);
            final LatLng targetLocation =
                LatLng(coordinates[0].latitude, coordinates[0].longitude);
            _mapController.moveCamera(CameraUpdate.newLatLng(targetLocation));
            //print(targetLocation);
            http.Response imageResponse =
                await http.get(Uri.parse(companyDetailsProvider.image));
            if (imageResponse.statusCode == 200) {
              final Uint8List bytes = imageResponse.bodyBytes;
              BitmapDescriptor imageBitmap = BitmapDescriptor.fromBytes(bytes);
              setState(() {
                _markers.add(Marker(
                  markerId: MarkerId(companyDetailsProvider.socialReason),
                  infoWindow:
                      InfoWindow(title: companyDetailsProvider.socialReason),
                  //icon: BitmapDescriptor.defaultMarker,
                  icon: imageBitmap,
                  position: targetLocation,
                  //LatLng(43.60884259690306, 3.8792796516431767),
                ));
              });
            } else {
              // Gestion des erreurs lors du téléchargement de l'image
              print(
                  'Échec du téléchargement de l\'image. Code d\'erreur: ${imageResponse.statusCode}');
            }
          }

          return Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _mcdoCom,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    setState(() {
                      _mapController = controller;
                      _goToTargetLocation();
                    });
                  },
                  markers: _markers,
                  zoomControlsEnabled: false,
                ),
              ),
              Positioned(
                left: 320,
                right: 20,
                bottom: 0,
                top: 160,
                child: FloatingActionButton(
                  onPressed: () {
                    _goToTargetLocation();
                  },
                  child: FaIcon(FontAwesomeIcons.locationCrosshairs),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Text(companyDetailsProvider.socialReason),
                      Text(companyDetailsProvider.address),
                      Consumer<ActivatedSalesMethods>(
                        builder: (context, activatedSalesMethods, _) {
                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: activatedSalesMethods
                                    .salesMethodsList.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    activatedSalesMethods
                                        .salesMethodsList[index]["libelle"],
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    order = true;
                                  });
                                },
                                child: Text(
                                  "Commander !",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Colors
                                          .grey), // Changez la couleur ici
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
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

  // Future<void> _goToThemcdoComedie() async {
  //   final GoogleMapController controller = await _controller.future;
  //   await controller.animateCamera(CameraUpdate.newCameraPosition(_mcdoCom));
  // }
}
