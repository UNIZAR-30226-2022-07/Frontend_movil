import 'dart:io';

import 'package:flutter_unogame/src/pages/login_page.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';

class TokenForm extends StatefulWidget {
  const TokenForm({Key? key}) : super(key: key);

  @override
  State<TokenForm> createState() => _TokenFormState();
}

class _TokenFormState extends State<TokenForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  String _password = '';
  String _token = '';

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'Email',
              label: 'Email',
              keyboard: TextInputType.emailAddress,
              icono: const Icon(Icons.verified_user),
              onChanged: (data) {
                _email = (data);
              },
              validator: (data) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(data ?? '') ? null : 'Correo inválido';
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            InputText(
              hint: 'Contraseña',
              label: 'Contraseña',
              obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _password = (data);
              },
              validator: (data) {
                if (data!.length < 6) {
                  return "Contraseña inválida";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            InputText(
              hint: 'Token',
              label: 'Token enviado a tu correo',
              obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _token = (data);
              },
              validator: (data) {
                if (data!.length < 1) {
                  return "Token inválido";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xE6CC0E08)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ChangePassword(_email, _password, _token);
                  }
                },
                child: const Text(
                  'Recuperar',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FredokaOne',
                      fontSize: 25.0),
                ),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     const Text(
            //       '¿Tu primera vez aquí?',
            //       style: TextStyle(fontFamily: 'FredokaOne'),
            //     ),
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, 'sign_up');
            //       },
            //       child: const Text(
            //         '¡Regístrate!',
            //         style:
            //             TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
            //       ),
            //     )
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, 'forgot_password');
            //       },
            //       child: const Text(
            //         'Recuperar contraseña',
            //         style:
            //             TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
            //       ),
            //     )
            //   ],
            // )
          ],
        ));
  }
    
  Future<dynamic> popUpCorrecto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Se ha reestablecido su contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 23, 206, 16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }


  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'No se ha podido recuperar la contraseña',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  } 
    
  Future ChangePassword(String email, String password, String token) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/reset_password');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = { 'email': email, 'token': token, 'password': password};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      final route = MaterialPageRoute(
          builder: (context) => LoginPage());
      Navigator.push(context, route);
      popUpCorrecto(context);
      print(response);
    } else {
      print('Contraseña incorrecta');
      if (response.statusCode != 200) {
        popUpError(context);
      }
    }
  }
}