import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/pages/loginPage.dart';

class CompanyDetailsProvider extends ChangeNotifier {
  int _id = 0;
  int get id => _id;

  String _socialReason = '';
  String get socialReason => _socialReason;

  String _address = '';
  String get address => _address;

  String _postalCode = '';
  String get postalCode => _postalCode;

  String _city = '';
  String get city => _city;

  String _mobilePhone = '';
  String get mobilePhone => _mobilePhone;

  String _phone = '';
  String get phone => _phone;

  String _website = '';
  String get website => _website;

  String _apeCode = '';
  String get apeCode => _apeCode;

  String _shareCapital = '';
  String get shareCapital => _shareCapital;

  String _siren = '';
  String get siren => _siren;

  String _siret = '';
  String get siret => _siret;

  String _intracommunityVAT = '';
  String get intracommunityVAT => _intracommunityVAT;

  String _uuid = '';
  String get uuid => _uuid;

  String _image = '';
  String get image => _image;

  List<dynamic> _salesMethods = [];
  List<dynamic> get salesMethods => _salesMethods;

  Map<String, dynamic> _companySettings = {};
  Map<String, dynamic> get companySettings => _companySettings;

  Future<void> fetchCompanyDetails() async {
    await dotenv.load();
    var urlApi = dotenv.env['API_URL'];

    try {
      var token = await session.get("_csrf");
      var headers = {
        'Authorization': 'Bearer $token',
      };
      final response = await http.get(
        Uri.parse('$urlApi/api/get-company-details'),
        headers: headers,
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _id = responseData['id'];
        _socialReason = responseData['socialReason'];
        _address = responseData['address'];
        _postalCode = responseData['postal_code'];
        _city = responseData['city'];
        _mobilePhone = responseData['mobilePhone'];
        _phone = responseData['phone'];
        _website = responseData['website'];
        _apeCode = responseData['apeCode'];
        _shareCapital = responseData['shareCapital'];
        _siren = responseData['siren'];
        _siret = responseData['siret'];
        _intracommunityVAT = responseData['intracommunity_vat'];
        _uuid = responseData['uuid'];
        _image = responseData['image'];
        _salesMethods = responseData['salesMethods'];
        _companySettings = responseData['companySettings'];
      } else {
        print('Erreur lors de la requête : ${response.statusCode}');
        _id = 0;
        _socialReason = 'Erreur lors de la requête';
        _address = '';
        _postalCode = '';
        _city = '';
        _mobilePhone = '';
        _phone = '';
        _website = '';
        _apeCode = '';
        _shareCapital = '';
        _siren = '';
        _siret = '';
        _intracommunityVAT = '';
        _uuid = '';
        _image = '';
        _salesMethods = [];
        _companySettings = {};
      }
    } catch (error) {
      print('Erreur lors de la requête : $error');
      _id = 0;
      _socialReason = 'Erreur lors de la requête';
      _address = '';
      _postalCode = '';
      _city = '';
      _mobilePhone = '';
      _phone = '';
      _website = '';
      _apeCode = '';
      _shareCapital = '';
      _siren = '';
      _siret = '';
      _intracommunityVAT = '';
      _uuid = '';
      _image = '';
      _salesMethods = [];
      _companySettings = {};
      throw Exception('Failed to fetch company details');
    }
    notifyListeners();
  }
}
