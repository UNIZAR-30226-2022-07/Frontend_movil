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
            hint: 'User Name',
            label: 'User Name',
            keyboard: TextInputType.name,
            icono: Icon(Icons.supervised_user_circle),
            onChanged: (data) {
              _name = data;
            },
            validator: (data) {
              if (data!.trim().isEmpty) {
                return "Invalid user name";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
          InputText(
            hint: 'Email address',
            label: 'Email address',
            keyboard: TextInputType.emailAddress,
            icono: Icon(Icons.verified_user),
            onChanged: (data) {
              _email = (data);
            },
            validator: (data) {
              if (!data!.contains('@')) {
                return "Invalid email";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
          InputText(
            hint: 'Password',
            label: 'Password',
            obsecure: true,
            icono: Icon(Icons.lock_outline),
            onChanged: (data) {
              _password = (data);
            },
            validator: (data) {
              if (data!.trim().isEmpty) {
                return "Invalid password";
              }
              return null;
            },
          ),
          Divider(
            height: 25.0,
          ),
                    InputText(
            hint: 'Country',
            label: 'Country',
            icono: Icon(Icons.flag),
            onChanged: (data) {
              _country = (data);
            },
            validator: (data) {
              if (data!.trim().isEmpty) {
                return "Country field is empty";
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
              child: Text('Register',
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
                'Already have an account?',
                style: TextStyle(
                  fontFamily: 'FredokaOne'
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'sign_in');
                }, 
                child: Text(
                  'Sign In',
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

//   Future<http.Response> createAlbum(String title) {
//     return http.post(
//       Uri.parse('https://jsonplaceholder.typicode.com/albums'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'title': title,
//       }),
//     );
//   }
// }

  Future RegistrationUser() async{
    var uri = Uri.http("localhost:2000","");

    Map mapeddate ={
      'service':'credentials',
      'login':_email,
      'passwd':_password
    };
    print("JSON DATA: ${mapeddate}");

    http.Response response = await http.post(uri,body:mapeddate);
    // print(response);
    var data = jsonDecode(response.body);

    print("DATA: ${data}");

  }
}