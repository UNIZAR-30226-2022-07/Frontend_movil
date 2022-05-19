import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';

import 'partida.dart';

class EsperaTorneo extends StatefulWidget {
  final String idPagina;
  final String autorization;
  final String nomUser;
  final int nPlayers;
  final List<String> jugadores;
  final List<dynamic> reglas;
  final dynamic infoInicial;
  EsperaTorneo(
      {required this.autorization,
      required this.idPagina,
      required this.nomUser,
      required this.nPlayers,
      required this.jugadores,
      required this.infoInicial,
      required this.reglas});

  @override
  State<EsperaTorneo> createState() => _EsperaTorneoState();
}

class _EsperaTorneoState extends State<EsperaTorneo> {
  String message = '';
  int nJugadores = 1;
  bool partidaEmpezada = false;
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();
  final canalCartaMedio = StreamController.broadcast();
  final canalJugada = StreamController.broadcast();
  late List<String> _listaJugadores = widget.jugadores;

// {jugadores: [{nombre: usuario123, cartas: []}], reglas: [],
//estado: NEW, id: 6dbd5630-f5a9-452c-b54c-05f3248b259c,
//njugadores: 1, tturno: 5, ultimaCartaJugada: {numero: NUEVE, color: AZUL},
//turno: {nombre: usuario123, cartas: []}, tipo: true}

// if (soyHost) {
  //   stompClient.send(
  //       destination: '/game/begin/torneo/$idPartidaTorneo',
  //       body: '',
  //       headers: {
  //         'Authorization': 'Bearer ${widget.autorization}',
  //         'username': widget.nomUser
  //       });
  // }

  void onConnect(StompFrame frame) async {
    //por aqui devuelve tu mano de cartas
    //Funciona
    stompClient.subscribe(
        destination: '/user/${widget.nomUser}/msg',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            print('Canal usuario');
            print(frame.body);
            dynamic a = "No es tu turno";
            if (frame.body != a) {
              if (!partidaEmpezada) {
                partidaEmpezada = true;
                final route = MaterialPageRoute(
                    builder: (context) => Partida(
                          userListener: canalUser.stream,
                          gameListener: canalGeneral.stream,
                          cartaMedioListener: canalCartaMedio.stream,
                          jugadaListener: canalJugada.stream,
                          stompClient: stompClient,
                          nomUser: widget.nomUser,
                          authorization: widget.autorization,
                          idPartida: widget.idPagina,
                          infoInicial: widget.infoInicial,
                          listaInicial: _listaJugadores,
                        ));
                Navigator.push(context, route);
              }
              await Future.delayed(const Duration(seconds: 1));
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
          print('Canal general');
          print(json.decode(frame.body!));
          if (!partidaEmpezada) {
            dynamic a = json.decode(frame.body!);
            List<String> jugadores = [];
            for (dynamic i in a) {
              jugadores.add(i['nombre']);
            }
            print(jugadores);
            setState(() {
              _listaJugadores = jugadores;
            });
          }
        }
      },
    );

    //devuelve la carta del medio
    //Funciona
    stompClient.subscribe(
      destination: '/topic/begin/${widget.idPagina}',
      callback: (StompFrame frame) async {
        if (frame.body != null) {
          print('Canal carta medio:');
          print(frame.body);
          if (!partidaEmpezada) {
            partidaEmpezada = true;
            final route = MaterialPageRoute(
                builder: (context) => Partida(
                      userListener: canalUser.stream,
                      gameListener: canalGeneral.stream,
                      cartaMedioListener: canalCartaMedio.stream,
                      jugadaListener: canalJugada.stream,
                      stompClient: stompClient,
                      nomUser: widget.nomUser,
                      authorization: widget.autorization,
                      idPartida: widget.idPagina,
                      infoInicial: widget.infoInicial,
                      listaInicial: _listaJugadores,
                    ));
            Navigator.push(context, route);
          }
          await Future.delayed(const Duration(seconds: 1));
          canalCartaMedio.sink.add(json.decode(frame.body!));
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

    //Envío de mensaje para conectarte a una partida
    stompClient.send(
        destination: '/game/connect/${widget.idPagina}',
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
  }

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

  @override
  Widget build(BuildContext context) {
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
                    itemCount: _listaJugadores.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
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
                          child: const Text('Copiar código'),
                          onPressed: () {
                            final data = ClipboardData(text: widget.idPagina);
                            Clipboard.setData(data);
                          },
                        ),
                      ],
                    ),
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
                            destination: '/game/disconnect/${widget.idPagina}',
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ])),
    );
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

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient.deactivate();
    }
    canalGeneral.close();
    canalUser.close();
    super.dispose();
  }
}
