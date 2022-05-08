import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/pages/recuperar_contra_token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({ Key? key }) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  // String _name = '';
  String _email = '';
  // String _password = '';
  _submit(){
    final forgotPassword = _formKey.currentState?.validate();
    print('ForgotPassword Form $forgotPassword');
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          InputText(
            hint: 'Email',
            label: 'Email',
            keyboard: TextInputType.emailAddress,
            icono: Icon(Icons.verified_user),
            onChanged: (data) {
              _email = (data);
            },
            validator: (data) {
              if (!data!.contains('@')) {
                return "Email inválido";
              }
              else if (data.trim().isEmpty){
                return "Email inválido";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xE6CC0E08)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
              onPressed: () {
                EnviarEmail(_email);
                // final route = MaterialPageRoute(
                //     builder: (context) => RecuperarContra());
                // Navigator.push(context, route);
              }, 
              child: Text('Enviar email de recuperación',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FredokaOne',
                  fontSize: 25.0
                ),
              ),
            ),
          ),
          Divider(
            height: 25.0,
          ),
        ],
      )
    );
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

  Future EnviarEmail(String _email) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/forgot_password');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'email': _email};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      final route = MaterialPageRoute(
                    builder: (context) => RecuperarContra());
                Navigator.push(context, route);
      // Navigator.pushReplacementNamed(context, 'home_page');
      print(response);
    } else {
      print('Email erróneo');
      if (response.statusCode != 200) {
        popUpError(context);
      }
    }
  }
}
