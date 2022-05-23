import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/semifinal.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';

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

  void onConnect(StompFrame frame) async {
    //por aqui devuelve tu mano de cartas
    stompClient.subscribe(
        destination: '/user/${widget.nomUser}/msg',
        callback: (StompFrame frame) async {
          if (frame.body != null) {
            print('Canal usuario');
            print(frame.body);
            dynamic a = "No es tu turno";
            if (frame.body != a) {
              if (!partidaEmpezada) {
                Uri url = Uri.parse(
                    'https://onep1.herokuapp.com/game/getInfoPartida');
                final headers = {
                  HttpHeaders.contentTypeHeader:
                      "application/json; charset=UTF-8"
                };
                Map mapeddate = {
                  'idPartida': widget.idPagina,
                };
                //Obtenemos la info necesaria para poder ir a la partida en cuestión
                final response = await http.post(url,
                    headers: headers, body: jsonEncode(mapeddate));
                final respuesta = jsonDecode(response.body);
                partidaEmpezada = true;
                final route = MaterialPageRoute(
                    builder: (context) => Semifinal(
                          userListener: canalUser.stream,
                          gameListener: canalGeneral.stream,
                          cartaMedioListener: canalCartaMedio.stream,
                          jugadaListener: canalJugada.stream,
                          stompClient: stompClient,
                          nomUser: widget.nomUser,
                          authorization: widget.autorization,
                          idPartida: widget.idPagina,
                          infoInicial: respuesta,
                          listaInicial: _listaJugadores,
                        ));
                Navigator.push(context, route);
                await Future.delayed(const Duration(seconds: 1));
              }
              canalUser.sink.add(jsonDecode(frame.body!));
            }
          }
        });

    //conectarse a la partida y nos devuelve la lista de los jugadores
    stompClient.subscribe(
      destination: '/topic/connect/${widget.idPagina}',
      callback: (StompFrame frame) async {
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
              nJugadores = jugadores.length;
            });
            if (nJugadores == widget.nPlayers &&
                jugadores[0] == widget.nomUser) {
              //Comenzar la partida automáticamente
              Uri url =
                  Uri.parse('https://onep1.herokuapp.com/game/getInfoPartida');
              final headers = {
                HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
              };
              Map mapeddate = {
                'idPartida': widget.idPagina,
              };
              //Obtenemos la info necesaria para poder ir a la partida en cuestión
              final response = await http.post(url,
                  headers: headers, body: jsonEncode(mapeddate));
              final respuesta = jsonDecode(response.body);
              stompClient.send(
                  destination: '/game/begin/${widget.idPagina}',
                  body: '',
                  headers: {
                    'Authorization': 'Bearer ${widget.autorization}',
                    'username': widget.nomUser
                  });
              partidaEmpezada = true;
              final route = MaterialPageRoute(
                  builder: (context) => Semifinal(
                        userListener: canalUser.stream,
                        gameListener: canalGeneral.stream,
                        cartaMedioListener: canalCartaMedio.stream,
                        jugadaListener: canalJugada.stream,
                        stompClient: stompClient,
                        nomUser: widget.nomUser,
                        authorization: widget.autorization,
                        idPartida: widget.idPagina,
                        infoInicial: respuesta,
                        listaInicial: _listaJugadores,
                      ));
              Navigator.push(context, route);
            }
          }
        }
      },
    );

    //devuelve la carta del medio
    stompClient.subscribe(
      destination: '/topic/begin/${widget.idPagina}',
      callback: (StompFrame frame) async {
        if (frame.body != null) {
          print('Canal carta medio:');
          print(frame.body);
          if (!partidaEmpezada) {
            partidaEmpezada = true;
            Uri url =
                Uri.parse('https://onep1.herokuapp.com/game/getInfoPartida');
            final headers = {
              HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
            };
            Map mapeddate = {
              'idPartida': widget.idPagina,
            };
            //Obtenemos la info necesaria para poder ir a la partida en cuestión
            final response = await http.post(url,
                headers: headers, body: jsonEncode(mapeddate));
            final respuesta = jsonDecode(response.body);
            final route = MaterialPageRoute(
                builder: (context) => Semifinal(
                      userListener: canalUser.stream,
                      gameListener: canalGeneral.stream,
                      cartaMedioListener: canalCartaMedio.stream,
                      jugadaListener: canalJugada.stream,
                      stompClient: stompClient,
                      nomUser: widget.nomUser,
                      authorization: widget.autorization,
                      idPartida: widget.idPagina,
                      infoInicial: respuesta,
                      listaInicial: _listaJugadores,
                    ));
            Navigator.push(context, route);
            await Future.delayed(const Duration(seconds: 1));
          }
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
    _listaJugadores = List.filled(widget.nPlayers, 'Esperando...');
    _listaJugadores[0] = widget.nomUser;
    int i = 1;
    for (dynamic a in widget.infoInicial['jugadores']) {
      _listaJugadores[i] = a;
      i++;
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
                                child: _listaJugadores.length > index
                                    ? Text(_listaJugadores[index])
                                    : const Text('Esperando...')),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //Reglas de la partida
                DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    child: Text(getReglas())),
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
