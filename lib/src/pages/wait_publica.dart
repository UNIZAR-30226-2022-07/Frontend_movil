import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';

import 'partida.dart';

class EsperaPublica extends StatefulWidget {
  final String idPagina;
  final String autorization;
  final String nomUser;
  final int nPlayers;
  final List<String> jugadores;
  final dynamic infoInicial;
  EsperaPublica({
    required this.autorization,
    required this.idPagina,
    required this.nomUser,
    required this.nPlayers,
    required this.jugadores,
    required this.infoInicial,
  });

  @override
  State<EsperaPublica> createState() => _EsperaPublicaState();
}

class _EsperaPublicaState extends State<EsperaPublica> {
  String message = '';
  int nJugadores = 1;
  bool partidaEmpezada = false;
  bool primeraConstruccion = true;
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();
  final canalCartaMedio = StreamController.broadcast();
  final canalJugada = StreamController.broadcast();
  late List<String> _listaJugadores = widget.jugadores;

// {jugadores: [{nombre: usuario123, cartas: []}], reglas: [],
//estado: NEW, id: 6dbd5630-f5a9-452c-b54c-05f3248b259c,
//njugadores: 1, tturno: 5, ultimaCartaJugada: {numero: NUEVE, color: AZUL},
//turno: {nombre: usuario123, cartas: []}, tipo: true}

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
    _listaJugadores.add(widget.nomUser);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    if (primeraConstruccion) {
      stompClient.activate();
      primeraConstruccion = false;
    }
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
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
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ]));
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
