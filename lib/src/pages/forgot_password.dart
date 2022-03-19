import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/icon_container.dart';
import 'package:flutter_unogame/src/widgets/forgotpassword_form.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({ Key? key }) : super(key: key);

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
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
              vertical: 100
            ),
            children: <Widget>  [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  IconContainer(
                    url: 'images/uno.jpg',
                  ),
                  Text(
                    'Get a new password',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 25.0
                    ),
                  ),
                  Text(
                    'Type in your email so we can do this!',
                    style: TextStyle(
                      fontFamily: 'PermanentMarker',
                      fontSize: 15.0
                    )
                  ),
                  Divider(
                    height: 10.0,
                  ),
                  // Formulario 
                  ForgotPasswordForm()
                ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}