import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/login_form.dart';
import 'package:flutter_unogame/src/widgets/logout_form.dart';



class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);

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
              vertical: 90
            ),
            children: <Widget>  [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  IconContainer(
                    url: 'images/uno.jpg',
                  ),
                  Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 38.0
                    ),
                  ),
                  Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 15.0
                    )
                  ),
                  Divider(
                    height: 10.0,
                  ),
                  // Formulario 
                  LogoutForm(),
                  Divider(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>  [
                      FloatingActionButton(
                        backgroundColor: Colors.red[900],
                        child: Icon(Icons.settings_backup_restore),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
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