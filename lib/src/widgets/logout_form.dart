import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/home_page.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class LogoutForm extends StatefulWidget {
  const LogoutForm({ Key? key }) : super(key: key);

  @override
  _LogoutFormState createState() => _LogoutFormState();
}

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
        children: <Widget> [
          InputText(
            hint: 'Nombre de usuario',
            label: 'Nombre de usuario',
            keyboard: TextInputType.name,
            icono: Icon(Icons.supervised_user_circle),
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
          Divider(
            height: 25.0,
          ),
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
                return "Email incorrecto";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
          InputText(
            hint: 'Contraseña',
            label: 'Contraseña',
            obsecure: true,
            icono: Icon(Icons.lock_outline),
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
          Divider(
            height: 25.0,
          ),
                    InputText(
            hint: 'País',
            label: 'País',
            icono: Icon(Icons.flag),
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
                if (_formKey.currentState!.validate()) {
                  RegistrationUser();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                }
              },
              child: Text('Regístrate',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FredokaOne',
                  fontSize: 25.0
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              Text(
                '¿Ya tienes cuenta?',
                style: TextStyle(
                  fontFamily: 'FredokaOne'
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'sign_in');
                }, 
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.teal,
                    fontFamily: 'FredokaOne'
                  ),
                ),
              )
            ],
          )
        ],
      )
    );
  }


  Future RegistrationUser() async{
    var uri = Uri.parse("https://onep1.herokuapp.com/auth/api/signup");

    Map mapeddate ={
      'username':_name,
      'email':_email,
      'pais':_country,
      'password': _password
    };
    print("JSON DATA: ${mapeddate}");

    final response = await http.post(uri,headers: {"Accept":"application/json"},body:mapeddate);
    if (response.statusCode == 200) {
      print(json.decode(response.body));
    } else {
      print(response.statusCode);
    }

    
    // print(response);
    var data = jsonDecode(response.body);

    print("DATA: ${data}");

  }

//   Future<http.Response> createAlbum(String title) {
//   return http.post(
//     Uri.parse('https://jsonplaceholder.typicode.com/albums'),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'title': title,
//     }),
//   );
// }
}