import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/pagina_invitar_amigos.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';
import '../pages/home_page.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';
import "dart:async";
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class AnadirJugadores extends StatefulWidget {
  final int numP;
  final dynamic reglas;
  final String idPagina;
  final String autorization;
  final String nomUser;
  final dynamic infoInicial;
  AnadirJugadores(
      {required this.autorization,
      required this.reglas,
      required this.idPagina,
      required this.nomUser,
      required this.numP,
      required this.infoInicial});

  @override
  State<AnadirJugadores> createState() => _AnadirJugadoresState();
}

class _AnadirJugadoresState extends State<AnadirJugadores> {
  String message = '';
  int nJugadores = 1;
  bool partidaEmpezada = false;
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();
  final canalCartaMedio = StreamController.broadcast();
  final canalJugada = StreamController.broadcast();
  List<String> _listaJugadores = [];
  List<bool> _listacompleta = [];

// {jugadores: [{nombre: usuario123, cartas: []}], reglas: [],
//estado: NEW, id: 6dbd5630-f5a9-452c-b54c-05f3248b259c,
//njugadores: 1, tturno: 5, ultimaCartaJugada: {numero: NUEVE, color: AZUL},
//turno: {nombre: usuario123, cartas: []}, tipo: true}

  String getReglas() {
    String rtdo = 'Reglas activas: ';
    bool primera = true;
    for (dynamic a in widget.reglas) {
      if (primera) {
        rtdo += a;
        primera = false;
      } else {
        rtdo += ', ' + a;
      }
    }
    return rtdo;
  }

  void onConnect(StompFrame frame) {
    //por aqui devuelve tu mano de cartas
    //Funciona
    stompClient.subscribe(
        destination: '/user/${widget.nomUser}/msg',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            print('Canal usuario');
            print(frame.body);
            dynamic a = "No es tu turno";
            if (frame.body != a) {
              canalUser.sink.add(json.decode(frame.body!));
            }
          }
        });

    //conectarse a la partida y nos devuelve la lista de los jugadores
    stompClient.subscribe(
      destination: '/topic/connect/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalGeneral.sink.add(json.decode(frame.body!));
          print(json.decode(frame.body!));
          print('Canal general');
          if (!partidaEmpezada) {
            dynamic a = json.decode(frame.body!);
            List<String> jugadores = [];
            for (dynamic i in a) {
              jugadores.add(i['nombre']);
            }
            print(jugadores);
            setState(() {
              _listaJugadores[nJugadores] = jugadores[jugadores.length - 1];
              _listacompleta[nJugadores] = true;
              nJugadores = jugadores.length;
            });
          }
        }
      },
    );

    //devuelve la carta del medio
    //Funciona
    stompClient.subscribe(
      destination: '/topic/begin/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalCartaMedio.sink.add(json.decode(frame.body!));
          print('Canal carta medio:');
          print(frame.body);
        }
      },
    );

    //enviar mensaje para jugar una carta
    stompClient.subscribe(
      destination: '/topic/jugada/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalJugada.sink.add(json.decode(frame.body!));
          print('Canal jugada');
          print(frame.body);
        }
      },
    );
  }

  late StompClient stompClient = StompClient(
    config: StompConfig.SockJS(
      url: 'https://onep1.herokuapp.com/onep1-game',
      onConnect: onConnect,
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(const Duration(milliseconds: 200));
        print('connecting...');
      },
      stompConnectHeaders: {
        'Authorization': 'Bearer ${widget.autorization}',
        'username': widget.nomUser
      },
      webSocketConnectHeaders: {
        'Authorization': 'Bearer ${widget.autorization}',
        'username': widget.nomUser
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      onStompError: (dynamic error) => print(error.toString()),
      onDisconnect: (f) => print('disconnected'),
    ),
  );

  @override
  void initState() {
    super.initState();
    if (stompClient == null) {
      StompFrame frame;
      StompClient client = StompClient(
          config: StompConfig.SockJS(
        url: 'wss://onep1.herokuapp.com/onep1-game',
        onConnect: onConnect,
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
      stompClient.activate();
    }
    _listaJugadores = List.filled(widget.numP, 'Esperando...');
    _listaJugadores[0] = widget.nomUser;
    _listacompleta = List.filled(widget.numP, false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> numbers = List.filled(widget.numP, '+');
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    stompClient.activate();
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          popUpReglas(context);
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          size: 40,
                          color: Colors.white,
                        )),
                  ],
                ),
                //Lista de jugadores
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.numP,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index == numbers.length - 1
                            ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
                            : const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.supervised_user_circle_rounded,
                              size: 60,
                            ),
                            DefaultTextStyle(
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                child: Text(_listaJugadores[index])),
                            !_listacompleta[index]
                                ? const SizedBox(
                                    height: 30,
                                  )
                                : SizedBox(
                                    height: 30,
                                    child: TextButton(
                                        onPressed: () {
                                          stompClient.send(
                                              destination:
                                                  '/game/disconnect/${widget.idPagina}',
                                              body: '',
                                              headers: {
                                                'Authorization':
                                                    'Bearer ${widget.autorization}',
                                                'username':
                                                    _listaJugadores[index]
                                              });
                                          setState(() {
                                            _listaJugadores[index] =
                                                'Esperando...';
                                            _listacompleta[index] = false;
                                            nJugadores--;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            primary: Colors.red,
                                            fixedSize: const Size(100, 20)),
                                        child: const Text('Expulsar')),
                                  )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    child: Text(getReglas())),
                const SizedBox(
                  height: 10,
                ),
                //Bot??n invitar amigos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DefaultTextStyle(
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            child: Text(widget.idPagina),
                          ),
                        ),
                        ElevatedButton(
                          child: const Text('Copiar c??digo'),
                          onPressed: () {
                            final data = ClipboardData(text: widget.idPagina);
                            Clipboard.setData(data);
                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          final route = MaterialPageRoute(
                              builder: (context) => InvitePlayers(
                                    username: widget.nomUser,
                                    idPartida: widget.idPagina,
                                  ));
                          Navigator.push(context, route);
                        },
                        child: const Text('Invitar amigos')),
                  ],
                ),
                //Bot??n crear
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 120,
                      height: 40.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 32, 159, 255)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // stompClient.activate();
                          //Env??o de un mensaje para empezar una partida (solo el que crea la partida)
                          if (nJugadores == widget.numP) {
                            partidaEmpezada = true;
                            stompClient.send(
                                destination: '/game/begin/${widget.idPagina}',
                                body: '',
                                headers: {
                                  'Authorization':
                                      'Bearer ${widget.autorization}',
                                  'username': widget.nomUser
                                });
                            print("entro a la partida");
                            final route = MaterialPageRoute(
                                builder: (context) => Partida(
                                      userListener: canalUser.stream,
                                      gameListener: canalGeneral.stream,
                                      cartaMedioListener:
                                          canalCartaMedio.stream,
                                      jugadaListener: canalJugada.stream,
                                      stompClient: stompClient,
                                      nomUser: widget.nomUser,
                                      authorization: widget.autorization,
                                      idPartida: widget.idPagina,
                                      infoInicial: widget.infoInicial,
                                      listaInicial: _listaJugadores,
                                    ));
                            Navigator.push(context, route);
                          } else {
                            faltanJugadores(context);
                            print('Faltan jugadores');
                          }
                        },
                        child: const Text(
                          'Crear',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20)
              ])),
    );
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient.deactivate();
    }
    canalGeneral.close();
    canalUser.close();
    super.dispose();
  }

  Future<dynamic> popUpReglas(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Descripci??n de las reglas de la partida',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: RichText(
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 12),
                            children: [
                          TextSpan(
                              text: '0 switch: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Cada vez que un usuario juegue la carta normal con numero 0, todos los jugadores pasan su mano al siguiente jugador en el sentido del juego.\n'),
                          TextSpan(
                              text: '\nCrazy 7: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Cada vez que un jugador juegue la carta normal con numero 7, podra elegir a otro jugador para intercambiar su mano.\n'),
                          TextSpan(
                              text: '\nProgressive draw: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Cuando en la cima de la pila de descartes haya una carta +2 o +4, el jugador que tenga el turno puede evitar robar jugando otra carta +2 si son del mismo color o +4, acumulando la cantidad de cartas pendientes por robar para el siguiente jugador.\n'),
                          TextSpan(
                              text: '\nChaos draw: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Si en algun momento el jugador debe robar cartas, el jugador robara una cantidad aleatoria entre 0 y 6 cartas.\n'),
                          TextSpan(
                              text: '\nBlock draw: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Si el jugador anterior ha jugado una carta +2 o +4, el jugador que tenga el turno puede evitar robar jugando la carta Bloqueo, saltando su propio turno y dejando las cartas pendientes de robar al siguiente jugador. El siguiente jugador puede encadenar otra carta de Bloqueo y evitar robar tambien.\n'),
                          TextSpan(
                              text: '\nRepeat draw: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'Si es el turno de un jugador y no puede jugar ninguna de las cartas de su mano, el jugador debera robar cartas de 1 en 1 hasta que pueda jugar una.\n'),
                        ])),
                  ),
                ))));
  }

  Future<dynamic> faltanJugadores(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'A??n no est??n todos los jugadores',
                style: TextStyle(fontSize: 24, color: Colors.red),
              ),
            ));
  }
}

// Expanded(
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: numbers.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: index == numbers.length - 1
//                           ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
//                           : const EdgeInsets.only(left: 8),
//                       child: ElevatedButton(
//                         child: Text(numbers[index]),
//                         style: ElevatedButton.styleFrom(
//                           primary: numbers[index] == _selectedNumber
//                               ? const Color.fromARGB(255, 43, 168, 214)
//                               : const Color.fromARGB(
//                                   102, 10, 10, 10), // background
//                           onPrimary: numbers[index] == _selectedNumber
//                               ? Colors.white
//                               : const Color.fromARGB(
//                                   255, 65, 189, 210), // foreground
//                         ),
//                         onPressed: () {
//                           final route = MaterialPageRoute(
//                               builder: (context) =>
//                                   InvitePlayers(username: widget.nomUser));
//                           Navigator.push(context, route);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
