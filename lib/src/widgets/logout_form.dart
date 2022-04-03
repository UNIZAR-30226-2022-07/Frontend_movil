import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class LogoutForm extends StatefulWidget {
  const LogoutForm({Key? key}) : super(key: key);

  @override
  _LogoutFormState createState() => _LogoutFormState();
}

bool _valido = false;

class _LogoutFormState extends State<LogoutForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name = '';
  String _email = '';
  String _password = '';
  String _country = '';
  // _submit(){
  //   final isLogin = _formKey.currentState?.validate();
  //   print('IsLogin Form $isLogin');
  // }
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'Nombre de usuario',
              label: 'Nombre de usuario',
              keyboard: TextInputType.name,
              icono: const Icon(Icons.supervised_user_circle),
              onChanged: (data) {
                _name = data;
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "Nombre de usuario incorrecto";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
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
              height: 25.0,
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
                if (data!.trim().isEmpty || data.length < 6) {
                  return "Contraseña inválida";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
            ),
            InputText(
              hint: 'País',
              label: 'País',
              icono: const Icon(Icons.flag),
              onChanged: (data) {
                _country = (data);
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "No ha introducido ningún país";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25.0,
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
                    _valido = false;
                    RegistrationUser();
                    if (!_valido) {}
                  }
                },
                child: const Text(
                  'Regístrate',
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
                  '¿Ya tienes cuenta?',
                  style: const TextStyle(fontFamily: 'FredokaOne'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'sign_in');
                  },
                  child: const Text(
                    'Iniciar sesión',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  backgroundColor: Colors.red[900],
                  child: const Icon(Icons.settings_backup_restore),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ));
  }

//   Future RegistrationUser() async {
//     Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signup');

//     final client = HttpClient();
//     final request = await client.postUrl(url);
//     request.headers
//         .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
//     request.write(
//         '{"username": "Hello2", "email": "hola@gmail.com", "pais": "espama", "password": "haaaaaaaaaaaaola"}');
//     print(request);
//     final response = await request.close();
//     response.transform(utf8.decoder).listen((contents) {
//       print(contents);
//     });
//     return response;
//   }
// }

  Future RegistrationUser() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signup');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map<String, String> mapeddate = {
      'username': _name,
      'email': _email,
      'pais': _country,
      'password': _password
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));

    if (response.statusCode == 200) {
      _valido = true;
      Navigator.pushReplacementNamed(context, 'home_page');
    } else {
      _valido = false;
      var respuesta = json.decode(response.body);
      print(respuesta['message']);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(respuesta['message']),
      //   backgroundColor: Colors.red,
      //   width: 30,
      // ));
    }
  }
}
