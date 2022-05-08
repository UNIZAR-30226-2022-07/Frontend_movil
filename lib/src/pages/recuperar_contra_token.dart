import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/form_token_recuperar.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/login_form.dart';

class RecuperarContra extends StatefulWidget {
  const RecuperarContra({Key? key}) : super(key: key);

  @override
  State<RecuperarContra> createState() => _RecuperarContraState();
}

class _RecuperarContraState extends State<RecuperarContra> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text(
                    'Recuperar contraseña',
                    style: TextStyle(
                        fontFamily: 'PermanentMarker', fontSize: 32.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  // Formulario
                  TokenForm(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}