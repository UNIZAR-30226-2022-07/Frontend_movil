import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/sign_in.dart';
import 'package:flutter_unogame/src/pages/sign_up.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 60),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const IconContainer(
                  url: 'images/one-red.png',
                ),
                const Text(
                  '¬°Bienvenido!',
                  style:
                      TextStyle(fontFamily: 'PermanentMarker', fontSize: 38.0),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xE6CC0E08)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                          builder: (context) => const SignIn());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Iniciar sesi√≥n',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xE6CC0E08)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                          builder: (context) => const SignUp());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Reg√≠strate',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
