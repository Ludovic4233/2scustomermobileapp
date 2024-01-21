import 'dart:convert';

import 'package:flutter/material.dart';

import '../pages/loginPage.dart';

class UserInfoProvider extends ChangeNotifier {
  UserData? userData;

  Future<void> getUserInfo() async {
    try {
      var token = await session.get("_csrf");
      Map<String, dynamic> tokenDecoded = parseJwt(token);
      getUserData(tokenDecoded);
    } catch (error) {
      throw Exception('Failed to userInfo');
    }
  }

  void getUserData(Map<String, dynamic> decodedToken) {
    userData = UserData(
        decodedToken['username'],
        decodedToken['firstName'],
        decodedToken['lastName'],
        decodedToken['phone'],
        decodedToken['birthday'],
        decodedToken['uuid'],
        decodedToken['qrCode']);
    print(userData?.username);
    print(userData?.firstName);
    print(userData?.lastName);
    print(userData?.phone);
    print(userData?.birthday);
    print(userData?.uuid);
    print(userData?.qrCode);

    notifyListeners();
  }
}

class UserData {
  final String? username;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? birthday;
  final String? uuid;
  final String? qrCode;

  UserData(this.username, this.firstName, this.lastName, this.phone,
      this.birthday, this.uuid, this.qrCode);
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('Invalid token');
  }
  final payload = parts[1];
  final decoded =
      json.decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
  if (decoded is! Map<String, dynamic>) {
    throw Exception('Invalid payload');
  }
  print(decoded);
  return decoded;
}
