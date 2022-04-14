import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/models/carta.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';

class Partida extends StatefulWidget {
  const Partida({Key? key}) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

//Esta será la lista de jugadores de la partida
List<Map<String, dynamic>> mapa = [
  {'username': 'Julián', 'cartas': 5},
  {'username': 'Paula', 'cartas': 5},
  {'username': 'Nerea', 'cartas': 5},
  {'username': 'Victor', 'cartas': 5},
  {'username': 'César', 'cartas': 5},
];

class _PartidaState extends State<Partida> {
  bool comprobarMov(Carta seleccionada, Carta cima) {
    bool sePuede = false;
    sePuede = seleccionada.numero == cima.numero ||
        seleccionada.color == cima.color ||
        seleccionada.esEspecial == true;
    return sePuede;
  }

  @override
  Widget rivalsCards() => Container(
      height: 210,
      width: 200,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      //decoration: BoxDecoration(color: Colors.red),
      child: SingleChildScrollView(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: mapa.length,
          itemBuilder: (BuildContext context, int index) {
            return RivalCard(
                userName: mapa[index]['username'],
                cards: mapa[index]['cartas']);
          },
        ),
      ));

  @override
  Widget buildCard(String carta) => GestureDetector(
      onTap: () {
        print("Container buildCard clicked");
        // if (comprobarMov(carta, cima)) {
        //   moverCarta(carta);
        //   eliminarCarta(carta);
        // }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(carta), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Center(child: Text('$index')),
      ));

  @override
  Widget cartaRobar(int index) => GestureDetector(
      onTap: () {
        print("Container cartaRobar clicked");
        //Pedir carta al backend y cuando llegue:
        //Añadir carta a la mano del jugador
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('images/uno.jpg'), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Center(child: Text('$index')),
      ));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 6, 104, 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rivalsCards(),
                Column(children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildCard('images/azul.jpg'),
                      const SizedBox(
                        width: 20,
                      ),
                      cartaRobar(20),
                      const SizedBox(
                        width: 80,
                      )
                    ],
                  ),
                ]),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 2),
              child: Column(
                children: <Widget>[
                  Row(children: [
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
                  ])
                ],
              ),
            )
          ],
        ));
  }
}
