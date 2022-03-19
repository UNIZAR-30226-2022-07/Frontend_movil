import 'package:flutter/material.dart';

import 'card.dart';

class Partida extends StatefulWidget {
  const Partida({ Key? key }) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 107, 22),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                MyCard(),
            ],
          ),
        ),
      ),
    );
  }
}