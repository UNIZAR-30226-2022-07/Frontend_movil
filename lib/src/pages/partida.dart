import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/card.dart';
import '../widgets/icon_container.dart';

class Partida extends StatefulWidget {
  const Partida({ Key? key }) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  
  @override
  Widget buildCard(int index) => Container(
    margin: const EdgeInsets.symmetric(
      horizontal: 1, vertical: 10
    ),
    width: 70,
    height: 130,
    decoration: BoxDecoration(
      image: DecorationImage(
            image: AssetImage('images/uno.jpg'),
            fit: BoxFit.fill
      ),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Center(child: Text('$index')),
  );
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
     return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 10, 151, 24),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: Column (
            children: <Widget>[
              SizedBox(
                height:80,
                width: 20,
              ), 
              Row(
                children: [
                  Column(

                  )
                ],
              ),
              SizedBox(
                height:140,
                width: 20,
              ), 
              Row(
                children: [
                  buildCard(1),
                  const SizedBox(width: 12),
                  buildCard(2),
                  const SizedBox(width: 12),
                  buildCard(3),
                  const SizedBox(width: 12),
                  buildCard(4),
                  const SizedBox(width: 12),
                  buildCard(5),
                  const SizedBox(width: 12),
                  buildCard(6),
                  const SizedBox(width: 12),
                  buildCard(7),
                  const SizedBox(width: 12),
                  buildCard(8),
                  const SizedBox(width: 12),
                  buildCard(9),
                  const SizedBox(width: 12),
                  buildCard(10),
                  const SizedBox(width: 12),
                  buildCard(11),
                  const SizedBox(width: 12),
                  buildCard(12),
                  const SizedBox(width: 12),
                ]
              )
            ],
          ),
        )
      );
  }
}