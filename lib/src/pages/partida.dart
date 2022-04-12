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
  Widget buildCard(String carta) => GestureDetector(
    onTap: () {
      print("Container clicked");
    },
    child: Container(
      margin: const EdgeInsets.symmetric(
      horizontal: 1, vertical: 10
      ),
      width: 70,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
              image: AssetImage(carta),
              fit: BoxFit.fill
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      // child: Center(child: Text('$index')),
    )
  );

  @override
  Widget cartaRobar(int index) => GestureDetector(
    onTap: () {
      print("Container clicked");
    },
    child: Container(
      margin: const EdgeInsets.symmetric(
      horizontal: 1, vertical: 10
      ),
      width: 70,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(
              image: AssetImage('images/uno.jpg'),
              fit: BoxFit.fill
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      // child: Center(child: Text('$index')),
    )
  );
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
     return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 6, 104, 16),
        ),
        child: Column(
          children: [
            SizedBox(
                    height:80,
                    width: 20,
            ), 
            Row(
              children: [
                SizedBox(
                  width: 350,
                ),
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildCard('images/azul.jpg'),
                  ]
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    cartaRobar(20),
                  ]
                )
              ],
              
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Column (
                children: <Widget>[
                  SizedBox(
                    height:25,
                  ), 
                  Row(
                    children: [
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                      buildCard('images/azul.jpg'),
                      const SizedBox(width: 12),
                    ]
                  )
                ],
              ),
            )

          ],
        )
      );
  }
}