import 'dart:io';

import 'package:flutter_unogame/src/pages/activar_cuenta.dart';
import 'package:flutter_unogame/src/pages/login_page.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';

class ActivateForm extends StatefulWidget {
  const ActivateForm({Key? key}) : super(key: key);

  @override
  State<ActivateForm> createState() => _ActivateFormState();
}

class _ActivateFormState extends State<ActivateForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name = '';
  String _token = '';
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
              hint: 'Introduce el token enviado a tu correo de registro',
              label: 'Token',
              // obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _token = (data);
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "Token inválido";
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
                    ActivateToken();
                  }
                },
                child: const Text(
                  'Activar cuenta',
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

  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Algo ha ido mal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future<dynamic> popUpCorrecto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Tu cuenta se ha activado correctamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 48, 205, 21),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future ActivateToken() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/activarCuenta');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': _name, 'token': _token};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      // popUpCorrecto(context);
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      print(respuesta['message']);
      final route = MaterialPageRoute(
          builder: (context) => LoginPage());
      Navigator.push(context, route);
      popUpCorrecto(context);
      // Navigator.pushReplacementNamed(context, 'home_page');
      print(response);
    } else {
      // Map<String, dynamic> respuesta = json.decode(response
      //     .body);
      // print(respuesta['message']);
      print('Token incorrecto');
      if (response.statusCode != 200) {
        popUpError(context);
      }
    }
  }
}
