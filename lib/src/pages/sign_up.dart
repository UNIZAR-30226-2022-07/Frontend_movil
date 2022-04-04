import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/login_form.dart';
import 'package:flutter_unogame/src/widgets/logout_form.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              Color.fromARGB(255, 252, 125, 125),
              Color.fromARGB(0, 255, 123, 123)
            ], begin: Alignment.topCenter),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  IconContainer(
                    url: 'images/uno.jpg',
                  ),
                  Text(
                    'Regístrate',
                    style: TextStyle(
                        fontFamily: 'PermanentMarker', fontSize: 32.0),
                  ),
                  Text('¡Bienvenido!',
                      style: TextStyle(
                          fontFamily: 'PermanentMarker', fontSize: 14.0)),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Formulario
                  LogoutForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
