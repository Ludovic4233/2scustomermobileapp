import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/loginWidgets/CustonInputText.dart';
import 'package:mobile/loginWidgets/Custombutton.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:logger/logger.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mobile/modelWidgets/getUserInfo.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../modelWidgets/getActivatedSalesMethod.dart';
import '../modelWidgets/getBillingAndShippingAdresse.dart';
import '../modelWidgets/getCompagnyDetails.dart';
import '../modelWidgets/getProductCategories.dart';
import '../modelWidgets/getProducts.dart';

var session = SessionManager();

var logger = Logger(
  printer: PrettyPrinter(),
);

autoComplet() async {
  String? username = await session.get("username");
  String? password = await session.get("password");
  // dynamic token = await session.get("_csrf");
  if (username != null && password != null) {
    return {
      "username": username,
      "password": password,
    };
  }
  return false;
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool emailBool = false;
  bool passwordBool = false;
  bool remember = false;

  String error = "";

  @override
  void initState() {
    super.initState();
    autoComplet().then((i) {
      if (i == false) return;
      setState(() {
        email.text = i["username"];
        password.text = i["password"];
        emailBool = true;
        passwordBool = true;
        remember = true;
      });
    });
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SizedBox(
            width: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 111,
                  width: 333,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/images/2s_pos_long.jpg"),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                SizedBox(
                  width: 500.0,
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomInputText(
                          controller: email,
                          labelText: 'E-mail',
                          hintText: 'Ex: john.doe@mail.com',
                          suffix: const Icon(Icons.mail_rounded),
                          onChange: (val) {
                            setState(() {
                              emailBool = EmailValidator.validate(val);
                            });
                          },
                        ),
                        const SizedBox(height: 30.0),
                        CustomInputText(
                          controller: password,
                          labelText: 'Mot de passe',
                          hintText: 'Ex: F7klm13',
                          obscureText: _passwordVisible ? false : true,

                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: _passwordVisible
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            // icon: const Icon(Icons.visibility)
                          ),
                          onChange: (val) {
                            setState(() {
                              passwordBool = validatePassword(val);
                            });
                          },
                          // obscureText: true,
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            const Text("Se souvenir de moi"),
                            Checkbox(
                              checkColor: Colors.white,
                              value: remember,
                              onChanged: (bool? value) {
                                setState(() => remember = value!);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: CustomButton(
                                text: "connexion".toUpperCase(),
                                bgColor: emailBool && passwordBool
                                    ? Colors.redAccent
                                    : Colors.grey,
                                textColor: emailBool && passwordBool
                                    ? Colors.white
                                    : Colors.white54,
                                onPress: emailBool && passwordBool
                                    ? () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => AlertDialog(
                                            title: Text("Veuillez patienter"),
                                            content: Row(
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(width: 20),
                                                Text(
                                                    "Chargement des données..."),
                                              ],
                                            ),
                                          ),
                                        );
                                        connect(
                                            context,
                                            {
                                              "username": email.text,
                                              "password": password.text,
                                              "remember": remember,
                                            },
                                            () =>
                                                Navigator.pushReplacementNamed(
                                                    context, "/home"), (msg) {
                                          setState(() => error = msg);
                                          Navigator.pop(context);
                                        });

                                        Provider.of<CompanyDetailsProvider>(
                                                context,
                                                listen: false)
                                            .fetchCompanyDetails();

                                        Provider.of<ActivatedSalesMethods>(
                                                context,
                                                listen: false)
                                            .fetchActivatedSalesMethods();

                                        Provider.of<CategoriesProvider>(context,
                                                listen: false)
                                            .fetchProductCategories();

                                        Provider.of<ProductsProvider>(context,
                                                listen: false)
                                            .fetchProduct();

                                        Provider.of<UserInfoProvider>(context,
                                                listen: false)
                                            .getUserInfo();

                                        Provider.of<BillingAndShippingAdresse>(
                                                context,
                                                listen: false)
                                            .fetchAdresse();
                                      }
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 100),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

bool validatePassword(String value) {
  return true;
  // RegExp regex = RegExp(
  //     r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#:\/\\\$&*~]).{8,}$');
  // return regex.hasMatch(value) ? true : false;
}

Future connect(context, obj, resolve, reject) async {
  await dotenv.load();
  var urlApi = dotenv.env['API_URL'];

  try {
    final auth = Provider.of<Auth>(context, listen: false);
    //final userInfo = Provider.of<UserInfo>(context, listen: false);

    final url = Uri.parse('$urlApi/login-as-customer');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "username": obj["username"],
      "password": obj["password"],
      "company": dotenv.env['COMPANY_ID'],
    });

    final response = await http.post(url, headers: headers, body: body);

    logger.d(response.statusCode);
    if (response.statusCode == 401) {
      return reject('E-mail ou mot de passe invalide.');
    }

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      logger.i(res);

      if (!res.containsKey('token')) return reject('Une erreur est survenue.');
      auth.setToken(res['token']);
      //auth.setTokenAndUserData(res['token'], parseJwt(res['token']));

      if (obj["remember"]) {
        await session.set("username", obj["username"]);
        await session.set("password", obj["password"]);
        await session.set("company", dotenv.env['COMPANY_ID']);
      }

      resolve();
    }
  } catch (error) {
    logger.i(error);
    return reject('Une erreur est survenue.$error');
  }
}

class Auth extends ChangeNotifier {
  String? token;
  // UserData? userData;

  String user = 'kévin';
  notifyListeners();

  void setToken(String val) {
    token = val;
    session.set("_csrf", val);
    notifyListeners();
  }

  void delToken() {
    session.remove("_csrf");
    if (token != null) {
      token = null;
      notifyListeners();
    }
  }

  bool isAuth() {
    return token != null ? true : false;
  }
}

// ignore_for_file: file_names

class UserInfo extends ChangeNotifier {
  String? username;
  String? password;

  // int? customerProfile;

  void setUsername(String val) {
    username = val;
    notifyListeners();
  }

  void setPassword(String val) {
    password = val;
    notifyListeners();
  }

  Map get() {
    return {
      "username": username,
      "password": password,
    };
  }
}
