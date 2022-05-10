import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/models/carta.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import '../models/mano.dart';

class Partida extends StatefulWidget {
  final Stream userListener;
  final Stream gameListener;
  final StompClient stompClient;
  final String idPartida;
  final String nomUser;
  final String authorization;
  const Partida(
      {Key? key,
      required this.idPartida,
      required this.nomUser,
      required this.userListener,
      required this.gameListener,
      required this.authorization,
      required this.stompClient})
      : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  late StreamSubscription userListener;
  late StreamSubscription gameListener;
  late StompClient stompClient;
  late Carta cima;
  late Mano mano;

  @override
  void initState() {
    super.initState();
    userListener =
        widget.userListener.listen((event) => gestionarUsuario(event));
    gameListener = widget.gameListener.listen((event) => gestionarGame(event));
    stompClient = widget.stompClient;
    cima = Carta(color: '', url: 'images/one.png', numero: '');
    mano = Mano(cartas: []);
  }

  void gestionarUsuario(dynamic a) {
    print("Partida.dart:");
    print(a);
    setState(() {
      mano = Mano(cartas: Carta.getCartas(a));
      print(mano.cartas);
    });
  }

  void gestionarGame(dynamic a) {
    String url = Carta.getURL(a['num'], a['col']);
    print('Cima de la partida inicial: ' + url);
    setState(() {
      cima = Carta(
        color: a['col'],
        numero: a['num'],
        url: url,
      );
    });
  }

  //Lista de jugadores de la partida
  List<Map<String, dynamic>> mapa = [
    {'username': 'Julián', 'cartas': 5},
    {'username': 'Paula', 'cartas': 5},
    {'username': 'Nerea', 'cartas': 5},
    {'username': 'Victor', 'cartas': 5},
    {'username': 'César', 'cartas': 5},
  ];
  bool miTurno = true;

  // Esta función dependerá también de las diferentes reglas con las que se juegue
  bool comprobarMov(Carta seleccionada, Carta cima) {
    bool sePuede = false;
    sePuede = seleccionada.numero == cima.numero ||
        seleccionada.color == cima.color ||
        seleccionada.numero == 'UNDEFINED' ||
        seleccionada.numero == 'MAS_CUATRO';
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
            //Enviar a backend la carta a jugar
            stompClient.send(
                destination: '/card/play/${widget.idPartida}',
                body: carta.buildMessage(),
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
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
              color: 'ROJO', numero: 'TRES', url: 'images/cartas/rojo-3.png');
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
                      ),
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
                    itemCount: mano.length(),
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
                                color: 'AZUL',
                                numero: 'UNDEFINED',
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
                                color: 'ROJO',
                                numero: 'UNDEFINED',
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
                                color: 'VERDE',
                                numero: 'UNDEFINED',
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
                                color: 'AMARILLO',
                                numero: 'UNDEFINED',
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
                                color: 'AZUL',
                                numero: 'MAS_CUATRO',
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
                                color: 'ROJO',
                                numero: 'MAS_CUATRO',
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
                                color: 'VERDE',
                                numero: 'MAS_CUATRO',
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
                                color: 'AMARILLO',
                                numero: 'MAS_CUATRO',
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
