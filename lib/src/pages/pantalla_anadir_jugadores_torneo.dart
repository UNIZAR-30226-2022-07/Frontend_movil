import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_unogame/src/pages/wait_torneo.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';

class AnadirJugadoresTorneo extends StatefulWidget {
  final int numP;
  final String idPagina;
  final String autorization;
  final String nomUser;
  final dynamic infoInicial;
  final dynamic reglas;
  AnadirJugadoresTorneo(
      {required this.autorization,
      required this.idPagina,
      required this.nomUser,
      required this.numP,
      required this.infoInicial,
      required this.reglas});

  @override
  State<AnadirJugadoresTorneo> createState() => _AnadirJugadoresTorneoState();
}

class _AnadirJugadoresTorneoState extends State<AnadirJugadoresTorneo> {
  String message = '';
  int nJugadores = 1;
  bool partidaEmpezada = false;
  String idPartidaTorneo = '';
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();
  final canalCartaMedio = StreamController.broadcast();
  final canalJugada = StreamController.broadcast();
  List<String> _listaJugadores = [];

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
    //Llega aquí el identificador de la semifinal a la que hay que entrar
    stompClient.subscribe(
        destination: '/user/${widget.nomUser}/msg',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            print('Canal usuario');
            print(frame.body);
            dynamic a = "No es tu turno";
            if (frame.body != a) {
              if (partidaEmpezada) {
                canalUser.sink.add(json.decode(frame.body!));
              } else {
                //Nos llega el id de la partida a jugar
                idPartidaTorneo = frame.body!;
                partidaEmpezada = true;
                Uri url = Uri.parse(
                    'https://onep1.herokuapp.com/game/getInfoPartida');
                final headers = {
                  HttpHeaders.contentTypeHeader:
                      "application/json; charset=UTF-8"
                };
                Map mapeddate = {
                  'idPartida': idPartidaTorneo,
                };
                //Obtenemos la info necesaria para poder ir a la partida en cuestión
                final response = await http.post(url,
                    headers: headers, body: jsonEncode(mapeddate));
                print(response.body);
                if (response.statusCode == 200) {
                  Map<String, dynamic> respuesta = json.decode(response.body);
                  List<String> jugadores = [];
                  for (dynamic a in respuesta['jugadores']) {
                    jugadores.add(a);
                  }
                  //Pasamos a la pantalla de esperaTorneo si todo ha ido bien
                  final route = MaterialPageRoute(
                      builder: (context) => EsperaTorneo(
                          autorization: widget.autorization,
                          idPagina: idPartidaTorneo,
                          idTorneo: widget.idPagina,
                          nomUser: widget.nomUser,
                          nPlayers: respuesta['numeroJugadores'],
                          jugadores: jugadores,
                          infoInicial: respuesta,
                          reglas: respuesta['reglas']));
                  Navigator.push(context, route);
                }
              }
            }
          }
        });

    //conectarse al torneo y nos devuelve la lista de los jugadores
    stompClient.subscribe(
      destination: '/topic/connect/torneo/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print('Canal general');
          print(json.decode(frame.body!));
          //en principio sobra esta comprobación
          if (!partidaEmpezada) {
            dynamic a = json.decode(frame.body!);
            List<String> jugadores = [];
            for (dynamic i in a) {
              jugadores.add(i['nombre']);
            }
            print(jugadores);
            //Se actualiza la lista de jugadores
            setState(() {
              // _listaJugadores[nJugadores] = jugadores[jugadores.length - 1];
              _listaJugadores = jugadores;
              nJugadores = jugadores.length;
            });
            //Se comprueba si se ha llegado al número necesario de jugadores
            // y si el jugador en cuestión es el host
            if (nJugadores == widget.numP && jugadores[0] == widget.nomUser) {
              //Comenzar la partida automáticamente
              stompClient.send(
                  destination: '/game/begin/torneo/${widget.idPagina}',
                  body: '',
                  headers: {
                    'Authorization': 'Bearer ${widget.autorization}',
                    'username': widget.nomUser
                  });
            }
          } else {
            canalGeneral.sink.add(json.decode(frame.body!));
          }
        }
      },
    );

    stompClient.subscribe(
      destination: '/topic/disconnect/torneo/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {}
      },
    );

    //Envío de mensaje para conectarme al torneo
    stompClient.send(
        destination: '/game/connect/torneo/${widget.idPagina}',
        body: '',
        headers: {
          'Authorization': 'Bearer ${widget.autorization}',
          'username': widget.nomUser
        });
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
    int i = 1;
    for (dynamic a in widget.infoInicial['jugadores']) {
      _listaJugadores[i] = a;
      i++;
    }
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
                //Botón info reglas
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
                    itemCount: 9,
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
                                child: _listaJugadores.length > index
                                    ? Text(_listaJugadores[index])
                                    : Text('Esperando...')),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //Reglas de la partida activas
                DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    child: Text(getReglas())),
                const SizedBox(
                  height: 30,
                ),
                //Botón salir del torneo
                TextButton(
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
                        destination:
                            '/game/disconnect/torneo/${widget.idPagina}',
                        body: '',
                        headers: {
                          'Authorization': 'Bearer ${widget.autorization}',
                          'username': widget.nomUser
                        });
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
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
                    'Descripción de las reglas de la partida',
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
}
