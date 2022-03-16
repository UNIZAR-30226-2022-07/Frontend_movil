import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/login_form.dart';


class SignIn extends StatefulWidget {
  const SignIn({ Key? key }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          width: double.infinity, 
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 252, 125, 125),
                Color.fromARGB(0, 255, 123, 123)
              ],
              begin: Alignment.topCenter
            ),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 200
            ),
            children: <Widget>  [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  IconContainer(
                    url: 'images/uno.jpg',
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 38.0
                    ),
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 35.0
                    )
                  ),
                  Divider(
                    height: 10.0,
                  ),
                  // Formulario 
                  LoginForm()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}