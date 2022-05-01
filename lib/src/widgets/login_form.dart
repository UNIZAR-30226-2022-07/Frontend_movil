import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'usuario123',
              label: 'Nombre de usuario',
              keyboard: TextInputType.emailAddress,
              icono: const Icon(Icons.verified_user),
              onChanged: (data) {
                _name = data;
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "Usuario inválido";
                }
                return null;
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
                    LoginUser();
                  }
                },
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FredokaOne',
                      fontSize: 25.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '¿Tu primera vez aquí?',
                  style: TextStyle(fontFamily: 'FredokaOne'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'sign_up');
                  },
                  child: const Text(
                    '¡Regístrate!',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'forgot_password');
                  },
                  child: const Text(
                    'Recuperar contraseña',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'El nombre de usuario o la contraseña son incorrectos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future LoginUser() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signin');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': _name, 'password': _password};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      print(respuesta['accessToken']);
      final route = MaterialPageRoute(
                          builder: (context) => HomePage(autorization: respuesta['accessToken'],));
                      Navigator.push(context, route);
      // Navigator.pushReplacementNamed(context, 'home_page');
      print(response);
    } else {
      print('Contraseña incorrecta');
      if (response.statusCode != 200) {
        popUpError(context);
      }
    }
  }
}
