import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/widgets/searchfriend_form.dart';

import '../widgets/icon_container.dart';



class AnadirAmigos extends StatefulWidget {
  const AnadirAmigos({ Key? key }) : super(key: key);

  @override
  State<AnadirAmigos> createState() => _AnadirAmigosState();
}

class _AnadirAmigosState extends State<AnadirAmigos> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  SearchFriendForm(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}