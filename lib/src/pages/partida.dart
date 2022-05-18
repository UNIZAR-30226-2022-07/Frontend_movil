import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/models/carta.dart';
import 'package:flutter_unogame/src/pages/chat.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../models/mano.dart';

class Partida extends StatefulWidget {
  final Stream userListener;
  final Stream gameListener;
  final Stream cartaMedioListener;
  final Stream jugadaListener;
  final StompClient stompClient;
  final String idPartida;
  final String nomUser;
  final String authorization;
  final dynamic infoInicial;
  final dynamic listaInicial;
  const Partida(
      {Key? key,
      required this.idPartida,
      required this.nomUser,
      required this.userListener,
      required this.cartaMedioListener,
      required this.jugadaListener,
      required this.gameListener,
      required this.authorization,
      required this.stompClient,
      this.infoInicial,
      required this.listaInicial})
      : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  List<types.Message> listaMensajes = [];
  late StreamSubscription userListener;
  late StreamSubscription gameListener;
  late StreamSubscription jugadaListener;
  late StreamSubscription cartaMedioListener;
  late StompClient stompClient;
  late Carta cima;
  late Mano mano;
  late String _turno;
  late List<dynamic> mapa = [];
  //infoInicial
// {jugadores: [{nombre: usuario123, cartas: []}], reglas: [],
//estado: NEW, id: 6dbd5630-f5a9-452c-b54c-05f3248b259c,
//njugadores: 1, tturno: 5, ultimaCartaJugada: {numero: NUEVE, color: AZUL},
//turno: {nombre: usuario123, cartas: []}, tipo: true}

  @override
  void initState() {
    super.initState();
    userListener =
        widget.userListener.listen((event) => gestionarUsuario(event));
    gameListener = widget.gameListener.listen((event) => gestionarGame(event));
    jugadaListener =
        widget.jugadaListener.listen((event) => gestionarJugada(event));
    cartaMedioListener =
        widget.cartaMedioListener.listen((event) => gestionarCarta(event));
    stompClient = widget.stompClient;
    cima = Carta(color: '', url: 'images/one.png', numero: '');
    mano = Mano(cartas: []);
    if (widget.infoInicial != null) {
      if (widget.infoInicial['turno'] != null) {
        _turno = widget.infoInicial['turno']['nombre'];
      } else {
        _turno = widget.infoInicial['jugadores'][0];
      }
    } else {
      _turno = 'otro';
    }
    for (String a in widget.listaInicial) {
      if (a != widget.nomUser) {
        Map<String, dynamic> aux = {'username': a, 'numeroCartas': 7};
        mapa.add(aux);
      }
    }
    // _turno = widget.nomUser;
  }

  // Van a llegar los mensajes específicos del usuario
  //  -- Las cartas de la mano inicial
  void gestionarUsuario(dynamic a) {
    setState(() {
      mano = Mano(cartas: Carta.getCartas(a));
    });
  }

  // Va a llegar la lista de jugadores
  void gestionarGame(dynamic a) {
    // "jugadores":[{"username":"usuario123","numeroCartas":5}]
    List<Map<String, dynamic>> mapaJugadores = a['jugadores'];
    //Borramos nuestro jugador
    for (dynamic a in mapaJugadores) {
      if (a['username'] == widget.nomUser) {
        //Borramos a nuestro propio usuario
        mapaJugadores.remove(a);
        break;
      }
    }
    setState(() {
      mapa = mapaJugadores; //Se actualiza la lista de jugadores
    });
  }

  // Canal para enviar y recibir jugadas
  void gestionarJugada(dynamic a) {
    if (a != 'ALGUIEN HA INTENTADO JUGAR Y NO ERA SU TURNO') {
      dynamic carta = a['carta'];
      // Carta que se va a poner en la cima
      Carta c = Carta(
          color: carta['color'],
          numero: carta['numero'],
          url: Carta.getURL(carta['numero'], carta['color']));

      List<dynamic> mapaJugadores = a['jugadores'];
      //Borramos nuestro jugador
      for (dynamic a in mapaJugadores) {
        if (a['username'] == widget.nomUser) {
          //Borramos a nuestro propio usuario
          mapaJugadores.remove(a);
          break;
        }
      }
      dynamic turno = a['turno'];
      setState(() {
        cima = c; //Se cambia la cima
        mapa = mapaJugadores; //Se actualiza la lista de jugadores
        _turno = turno;
      });
    }
  }

  // Canal al que nos va a llegar la carta inicial de la partida
  void gestionarCarta(dynamic a) {
    String url = Carta.getURL(a['numero'], a['color']);
    setState(() {
      cima = Carta(
        color: a['color'],
        numero: a['numero'],
        url: url,
      );
    });
  }

  // Esta función dependerá también de las diferentes reglas con las que se juegue
  bool comprobarMov(Carta seleccionada, Carta cima) {
    bool sePuede = false;
    sePuede = seleccionada.numero == cima.numero ||
        seleccionada.color == cima.color ||
        seleccionada.numero == 'CAMBIO_COLOR' ||
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
              cards: mapa[index]['numeroCartas'],
              turno: mapa[index]['username'] == _turno,
            );
          },
        ),
      ));

  Widget buildCard(Carta carta) => GestureDetector(
      onTap: () {
        if (_turno == widget.nomUser) {
          //Si es el turno del jugador
          if (comprobarMov(carta, cima)) {
            //Caso de las wild y el draw4
            switch (carta.numero) {
              case 'CAMBIO_COLOR':
                popUpWild(context, carta).then((_) => setState(() {}));
                break;
              case 'MAS_CUATRO':
                popUpDraw(context, carta).then((_) => setState(() {}));
                break;
              default:
                cima = carta; //Cambia la cima
                mano.del(carta); //Se elimina la carta de la mano del jugador
                //Enviar a backend la carta a jugar
                print('Jugando la carta ' + carta.url);
                stompClient.send(
                    destination: '/game/card/play/${widget.idPartida}',
                    body: carta.buildMessage(),
                    headers: {
                      'Authorization': 'Bearer ${widget.authorization}',
                      'username': widget.nomUser
                    });
                break;
            }
            print(carta.buildMessage());
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
        if (_turno == widget.nomUser) {
          //Pedir carta al backend y cuando llegue:
          // Carta c = Carta(
          //     color: 'ROJO', numero: 'TRES', url: 'images/cartas/rojo-3.png');
          // mano.add(c);
          print('Robando carta...');
          Map<String, dynamic> robo = {'nCards': 1};
          print(jsonEncode(robo));
          stompClient.send(
              destination: '/game/card/draw/${widget.idPartida}',
              body: jsonEncode(robo),
              headers: {
                'Authorization': 'Bearer ${widget.authorization}',
                'username': widget.nomUser
              });

          //Añadir carta a la mano del jugador
          // setState(() {});
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
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 6, 104, 16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  //Hay que añadir aquí el botón del char
                  IconButton(
                      onPressed: () {
                        final route = MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  autorizacion: widget.authorization,
                                  idPagina: widget.idPartida,
                                  nomUser: widget.nomUser,
                                  listaMensajes: listaMensajes,
                                  callback: (List<types.Message> updatedList) {
                                    setState(() {
                                      listaMensajes = updatedList;
                                    });
                                  },
                                ));
                        Navigator.push(context, route);
                      },
                      icon: const Icon(
                        Icons.chat,
                        size: 40,
                        color: Colors.white,
                      )),
                ],
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 2),
                  child: Container(
                    decoration: BoxDecoration(
                      color: (_turno == widget.nomUser)
                          ? Colors.yellow
                          : Colors.transparent,
                    ),
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
          )),
    );
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
                                numero: 'CAMBIO_COLOR',
                                url: 'images/cartas/azul-wild.png');
                            mano.del(carta);
                            carta.color = 'AZUL';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'ROJO';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'VERDE';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'AMARILLO';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'AZUL';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'ROJO';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'VERDE';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
                            carta.color = 'AMARILLO';
                            //Enviar a backend la carta a jugar
                            print('Jugando la carta ' + carta.url);
                            stompClient.send(
                                destination:
                                    '/game/card/play/${widget.idPartida}',
                                body: carta.buildMessage(),
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.authorization}',
                                  'username': widget.nomUser
                                });
                            print(carta.buildMessage());
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
