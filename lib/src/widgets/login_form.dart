import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

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
              hint: 'usuario123',
              label: 'Nombre de usuario',
              keyboard: TextInputType.emailAddress,
              icono: const Icon(Icons.verified_user),
              onChanged: (data) {
                _name = data;
              },
              validator: (data) {
                // String pattern =
                //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                // RegExp regExp = RegExp(pattern);

                // return regExp.hasMatch(data ?? '') ? null : 'Correo inválido';
                if (data!.trim().isEmpty) {
                  return "Usuario inválido";
                }
                return null;
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
                if (data!.trim().isEmpty) {
                  return "Contraseña inválida";
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
                // onPressed: this._submit,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HomePage(),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Inicia sesión',
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
                    'Iniciar sesión',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Text(
                // //   'Forgot password?',
                // //   style: TextStyle(
                // //     fontFamily: 'FredokaOne'
                // //   ),
                // // ),
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


    Future LoginUser() async{
    var uri = Uri.http("localhost:2000","");

    Map mapeddate ={
      'service':'credentials',
      'login':_name,
      'passwd':_password
    };
    print("JSON DATA: ${mapeddate}");

    http.Response response = await http.post(uri,body:mapeddate);
    // print(response);
    var data = jsonDecode(response.body);

    print("DATA: ${data}");

  }




}
