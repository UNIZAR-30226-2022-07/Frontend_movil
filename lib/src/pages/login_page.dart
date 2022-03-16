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
      [DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown]
    );
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
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 38.0
                    ),
                  ),
                  Divider(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
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
                        final route = MaterialPageRoute(
                          builder: (context) => SignIn());
                        Navigator.push(context, route);
                      },
                      child: Text('Sign in',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 20.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
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
                        final route = MaterialPageRoute(
                          builder: (context) => SignUp());
                        Navigator.push(context, route);
                      },
                      child: Text('Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}