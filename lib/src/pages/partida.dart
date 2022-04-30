// import 'dart:_http';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/models/carta.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';

import '../models/mano.dart';

class Partida extends StatefulWidget {
  const Partida({Key? key}) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

//Simula la lista de cartas que tendrá el jugador
// inicialmente proporcionada por el Backend
List<Carta> cartasJugador = [
  Carta(color: 'rojo', numero: '5', url: 'images/cartas/rojo-5.png'),
  Carta(color: 'verde', numero: '5', url: 'images/cartas/verde-5.png'),
  Carta(esEspecial: true, especialidad: 'wild', url: 'images/cartas/wild.png'),
  Carta(
      esEspecial: true, especialidad: 'draw4', url: 'images/cartas/draw4.png'),
];

class _PartidaState extends State<Partida> {
  // Última carta echada por cualquiera de los jugadores
  Carta cima =
      Carta(color: 'rojo', numero: '3', url: 'images/cartas/rojo-3.png');

  //Lista de jugadores de la partida
  List<Map<String, dynamic>> mapa = [
    {'username': 'Julián', 'cartas': 5},
    {'username': 'Paula', 'cartas': 5},
    {'username': 'Nerea', 'cartas': 5},
    {'username': 'Victor', 'cartas': 5},
    {'username': 'César', 'cartas': 5},
  ];
  bool miTurno = true;
  Mano mano = Mano(cartas: cartasJugador);

  // Esta función dependerá también de las diferentes reglas con las que se juegue
  bool comprobarMov(Carta seleccionada, Carta cima) {
    bool sePuede = false;
    sePuede = seleccionada.numero == cima.numero ||
        seleccionada.color == cima.color ||
        seleccionada.color == null;
    return sePuede;
  }

  Widget rivalsCards() => Container(
      height: 210,
      width: 280,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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

  Widget buildCard(Carta carta) => GestureDetector(
      onTap: () {
        if (miTurno) {
          //Si es el turno del jugador
          if (comprobarMov(carta, cima)) {
            if (carta.color == null) {
              //Caso de las wild y el draw4
              switch (carta.especialidad) {
                case 'draw4':
                  popUpDraw(context, carta).then((_) => setState(() {}));
                  break;
                case 'wild':
                  popUpWild(context, carta).then((_) => setState(() {}));
                  break;
              }
            } else {
              cima = carta; //Cambia la cima
              mano.del(carta); //Se elimina la carta de la mano del jugador
            }

            //Avisar al backend de la jugada
          } else {
            print('No se puede realizar ese movimiento');
          }
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(carta.url), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
      ));

  Widget ultimaCarta(Carta carta) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(carta.url), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Center(child: Text('$index')),
      );

  Widget cartaRobar() => GestureDetector(
      onTap: () {
        if (miTurno) {
          //Pedir carta al backend y cuando llegue:
          Carta c = Carta(
              color: 'rojo', numero: '3', url: 'images/cartas/rojo-3.png');
          mano.add(c);
          //Añadir carta a la mano del jugador
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('images/cartas/back.png'), fit: BoxFit.fill),
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
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // No es un buildCard sino la cima
                      ultimaCarta(cima),
                      const SizedBox(
                        width: 20,
                      ),
                      cartaRobar(),
                      const SizedBox(
                        width: 80,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(250, 199, 9, 9)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            //Acciones a realizar al apretar el botón UNO
                            //Avisar al Backend
                          },
                          child: const Text(
                            'UNO',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'FredokaOne',
                                fontSize: 25.0),
                          ),
                        ),
                      ),
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
                child: SizedBox(
                  height: 130,
                  width: MediaQuery.of(context).size.width - 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: cartasJugador.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildCard(mano.cartas[index]);
                    },
                  ),
                ))
          ],
        ));
  }

  Future<dynamic> popUpWild(BuildContext context, Carta carta) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Elige un color',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'azul',
                                url: 'images/cartas/azul-wild.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Azul',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'rojo',
                                url: 'images/cartas/rojo-wild.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Rojo',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'verde',
                                url: 'images/cartas/verde-wild.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Verde',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'amarillo',
                                url: 'images/cartas/amarillo-wild.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Amarillo',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ))));
  }

  Future<dynamic> popUpDraw(BuildContext context, Carta carta) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Elige un color',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'azul',
                                url: 'images/cartas/azul-draw4.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Azul',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'rojo',
                                url: 'images/cartas/rojo-draw4.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Rojo',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'verde',
                                url: 'images/cartas/verde-draw4.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Verde',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          )),
                      TextButton(
                          onPressed: () {
                            cima = Carta(
                                color: 'amarillo',
                                url: 'images/cartas/amarillo-draw4.png');
                            mano.del(carta);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Amarillo',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ))));
  }
}
