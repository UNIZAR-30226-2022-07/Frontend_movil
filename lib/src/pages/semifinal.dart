import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/models/carta.dart';
import 'package:flutter_unogame/src/pages/chat.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../models/mano.dart';
import 'package:http/http.dart' as http;

import 'pantalla_espera.dart';

class Semifinal extends StatefulWidget {
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
  const Semifinal(
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
  State<Semifinal> createState() => _SemifinalState();
}

class _SemifinalState extends State<Semifinal> {
  int robarCartas = 0;
  bool salto = false;
  bool robar2 = true;
  bool robar4 = true;
  bool botonPulsado = false;
  List<types.Message> listaMensajes = [];
  bool partidaEmpezada = false;
  late StreamSubscription userListener;
  late StreamSubscription gameListener;
  late StreamSubscription jugadaListener;
  late StreamSubscription cartaMedioListener;
  late StompClient stompClient;
  late Carta cima;
  late Mano mano;
  late String _turno;
  late List<dynamic> mapa = [];
  String idFinal = '';
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
    if (a is String) {
      idFinal = a;
    } else {
      List<Carta> vieja = mano.cartas;
      List<Carta> lista = Carta.getCartas(a);
      vieja.addAll(lista);
      setState(() {
        if (partidaEmpezada) {
          mano = Mano(cartas: vieja);
        } else {
          mano = Mano(cartas: vieja);
          partidaEmpezada = true;
        }
      });
    }
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
  void gestionarJugada(dynamic a) async {
    if (a != 'ALGUIEN HA INTENTADO JUGAR Y NO ERA SU TURNO') {
      dynamic exp = RegExp(r'HA GANADO [a-zA-Z0-9]+');
      if (a is String && exp.hasMatch(a)) {
        //Significa que un usuario ha ganado la partida
        print(a);
        if (a == 'HA GANADO ${widget.nomUser}') {
          //Esperamos 2 segundos por si acaso
          Future.delayed(const Duration(seconds: 2));
          popUpGanador(context);
        } else {
          popUpFinal(context, a);
        }
      } else {
        // a = jsonDecode(a);
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
        //Gestionar la lógica de los bloqueos
        if (carta['numero'] == 'BLOQUEO') {
          if (!salto) {
            stompClient.send(
                destination: '/game/pasarTurno/${widget.idPartida}',
                body: '',
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
            salto = true;
          } else {
            salto = false;
          }
        }
        //Gestionar la lógica de los draws
        if (carta['numero'] == 'MAS_DOS') {
          if (robar2) {
            stompClient.send(
                destination: '/game/card/draw/${widget.idPartida}',
                body: "2",
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
            stompClient.send(
                destination: '/game/pasarTurno/${widget.idPartida}',
                body: '',
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
            robar2 = false;
          } else {
            robar2 = false;
          }
        }
        //Gestionar la lógica de los draws4
        if (carta['numero'] == 'MAS_CUATRO') {
          if (robar4) {
            stompClient.send(
                destination: '/game/card/draw/${widget.idPartida}',
                body: "4",
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
            stompClient.send(
                destination: '/game/pasarTurno/${widget.idPartida}',
                body: '',
                headers: {
                  'Authorization': 'Bearer ${widget.authorization}',
                  'username': widget.nomUser
                });
            robar4 = false;
          } else {
            robar4 = true;
          }
        }

        setState(() {
          cima = c; //Se cambia la cima
          mapa = mapaJugadores; //Se actualiza la lista de jugadores
          _turno = turno;
        });
      }
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
    // if (cima.numero == 'MAS_DOS') {
    //   if (seleccionada.numero == 'MAS_DOS') {
    //     robarCartas = 0;
    //   } else {
    //     robarCartas = 2;
    //     sePuede = false;
    //   }
    // }
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
            if (mano.length() == 2 && !botonPulsado) {
              stompClient.send(
                  destination: '/game/card/draw/${widget.idPartida}',
                  body: "2",
                  headers: {
                    'Authorization': 'Bearer ${widget.authorization}',
                    'username': widget.nomUser
                  });
              Future.delayed(const Duration(seconds: 2));
            }
            botonPulsado = false;
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
          print('Robando carta...');
          stompClient.send(
              destination: '/game/card/draw/${widget.idPartida}',
              body: "1",
              headers: {
                'Authorization': 'Bearer ${widget.authorization}',
                'username': widget.nomUser
              });
          //Salto mi turno q no puedo jugar
          stompClient.send(
              destination: '/game/pasarTurno/${widget.idPartida}',
              body: '',
              headers: {
                'Authorization': 'Bearer ${widget.authorization}',
                'username': widget.nomUser
              });
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
                              if (mano.length() == 2) {
                                setState(() {
                                  botonPulsado = true;
                                });
                              }
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

  Future<dynamic> popUpGanador(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Has ganado'),
              content: TextButton(
                child: const DefaultTextStyle(
                  child: Text('Jugar la final'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red),
                ),
                onPressed: () {
                  //Pasar a la final
                  pasarFinal();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ));
  }

  Future<dynamic> pasarFinal() async {
    //Pedir info de la final -> getInfoPartida
    Uri url = Uri.parse('https://onep1.herokuapp.com/game/getInfoPartida');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {
      'idPartida': idFinal,
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body);
      print(respuesta);
      List<String> jugadores = [];
      for (dynamic a in respuesta['jugadores']) {
        jugadores.add(a);
      }
      final route = MaterialPageRoute(
          builder: (context) => EsperaPartida(
              autorization: widget.authorization,
              idPagina: idFinal,
              nomUser: widget.nomUser,
              nPlayers: respuesta['numeroJugadores'],
              jugadores: jugadores,
              infoInicial: respuesta,
              reglas: respuesta['reglas']));
      Navigator.push(context, route);
    }
  }

  Future<dynamic> popUpFinal(BuildContext context, String mensaje) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(mensaje),
              content: TextButton(
                child: const DefaultTextStyle(
                  child: Text('Salir de la partida'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red),
                ),
                onPressed: () {
                  stompClient.send(
                      destination: '/game/disconnect/${widget.idPartida}',
                      body: '',
                      headers: {
                        'Authorization': 'Bearer ${widget.authorization}',
                        'username': widget.nomUser
                      });
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ));
  }
}
