import 'package:flutter/material.dart';

import '../widgets/card.dart';
import '../widgets/icon_container.dart';

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
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomStart,
            children: const [
              MyCard(),
              Positioned(
                left: 50,
                bottom: 0,
                child: MyCard(),
              ),
              Positioned(
                left: 100,
                bottom: 0,
                child: MyCard(),
              ),
              Positioned(
                left: 150,
                bottom: 0,
                child: MyCard(),
              ),
            ],
          )
        ),
      ),
    );
  }
}