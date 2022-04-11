import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/login_form.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

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
                    url: 'images/one-red.png',
                  ),
                  Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        fontFamily: 'PermanentMarker', fontSize: 32.0),
                  ),
                  Text('!Hola! ¡Qué bien verte de nuevo!',
                      style: TextStyle(
                          fontFamily: 'PermanentMarker', fontSize: 14.0)),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Formulario
                  LoginForm(),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     FloatingActionButton(
              //       backgroundColor: Colors.red[900],
              //       child: const Icon(Icons.settings_backup_restore),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
