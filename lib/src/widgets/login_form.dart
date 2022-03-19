

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/home_page.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'package:flutter_unogame/src/pages/partida.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({ Key? key }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _email = '';
  String _password = '';
  _submit(){
    final isLogin = _formKey.currentState?.validate();
    print('IsLogin Form $isLogin');
    
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget> [
          InputText(
            hint: 'Email Address',
            label: 'Email Adress',
            keyboard: TextInputType.emailAddress,
            icono: Icon(Icons.verified_user),
            onChanged: (data) {
              _email = data;
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
              onPressed: (){
                this._submit;
                final route = MaterialPageRoute(
                  builder: (context) => HomePage());
                Navigator.push(context, route);
              },
              child: Text('Sign In',
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
                'New here?',
                style: TextStyle(
                  fontFamily: 'FredokaOne'
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'sign_up');
                  
                }, 
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.teal,
                    fontFamily: 'FredokaOne'
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget> [
              FlatButton(
                onPressed: (){
                  Navigator.pushNamed(context, 'forgot_password');
                }, 
                child: Text(
                  'Forgot password',
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
}