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

// const numbers = [1,2,3,4,5,6];
// final numbers = List.filled(4, 5);

class AnadirJugadores extends StatefulWidget {
  final int numP;
  final String idPagina;
  final String autorization;
  final String nomUser;
  AnadirJugadores(
      {required this.autorization,
      required this.idPagina,
      required this.nomUser,
      required this.numP});

  @override
  State<AnadirJugadores> createState() => _AnadirJugadoresState();
}

class _AnadirJugadoresState extends State<AnadirJugadores> {
  int? _selectedNumber;
  // late StompClient stompClient;
  // final socketUrl = 'ws://onep1.herokuapp.com/onep1-game';
  String message = '';
  bool comenzarPartida = false;
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();

  void onConnect(StompFrame frame) {
    //por aqui devuelve tu mano de cartas
    stompClient.subscribe(
        destination: '/user/${widget.nomUser}/msg',
        callback: (StompFrame frame) {
          if (frame.body != null) {
            canalUser.sink.add(json.decode(frame.body!));
            print(frame.body);
            //canalUser = json.decode(frame.body!);
            // canalUser = json.decode(frame.body!);
            // print(canalUser);
          }
        }
    );

    //conectarse a la partida y nos devuelve la lista de los jugadores
    stompClient.subscribe(
      destination: '/topic/connect/${widget.idPagina}',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalGeneral.sink.add(json.decode(frame.body!));
          //print(canalGeneral);
          print(frame.body);
          //Map<String, dynamic> result = json.decode(frame.body!);
          // canalGeneral = json.decode(frame.body!);
          // print(canalGeneral);
        }
      },
    );

    //devuelve la carta del medio
    stompClient.subscribe(
      destination: '/topic/begin/${widget.idPagina}', 
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalGeneral.sink.add(json.decode(frame.body!));
          //print(canalGeneral);
          print(frame.body);
          //Map<String, dynamic> result = json.decode(frame.body!);
          // canalGeneral = json.decode(frame.body!);
          // print(canalGeneral);
        }
      },
    );

    //enviar mensaje para jugar una carta
    stompClient.subscribe(
      destination: '/topic/jugada/${widget.idPagina}', 
      callback: (StompFrame frame) {
        if (frame.body != null) {
          canalGeneral.sink.add(json.decode(frame.body!));
          //print(canalGeneral);
          print(frame.body);
          //Map<String, dynamic> result = json.decode(frame.body!);
          // canalGeneral = json.decode(frame.body!);
          // print(canalGeneral);
        }
      },
    );

    

    print("me he suscrito");
    // Timer.periodic(Duration(seconds: 10), (_) {
    //   stompClient.send(
    //       destination: '/game/connect/${widget.idPagina}', body: 'widget.nomUser');
    // });

    

    //para conectarte a una partida
    stompClient.send(
        destination: '/connect/${widget.idPagina}',
        body: '',
        headers: {
          'Authorization': 'Bearer ${widget.autorization}',
          'username': widget.nomUser
        });
    print("lo he mandado");

    //empezar una partida (solo el que crea la partida)
    stompClient.send(
        destination: '/begin/${widget.idPagina}',
        body: '',
        headers: {
          'Authorization': 'Bearer ${widget.autorization}',
          'username': widget.nomUser
        });


    //para jugar un carta (va dentro de la funcion de callback) va en partida al igual que robar n cartas
    // stompClient.send(
    //     destination: '/card/play/${widget.idPagina}',
    //     body: '',
    //     headers: {
    //       'Authorization': 'Bearer ${widget.autorization}',
    //       'username': widget.nomUser
    //     });

    //fata el disconnect
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

  @override
  Widget build(BuildContext context) {
    List<String> numbers = List.filled(widget.numP, '+');
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 120,
                width: 200,
              ),
              Container(
                  height: 50,
                  width: 500,
                  child: Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: numbers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: index == numbers.length - 1
                              ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
                              : const EdgeInsets.only(left: 8),
                          child: ElevatedButton(
                            child: Text(numbers[index]),
                            style: ElevatedButton.styleFrom(
                              primary: numbers[index] == _selectedNumber
                                  ? Color.fromARGB(255, 43, 168, 214)
                                  : Color.fromARGB(
                                      102, 10, 10, 10), // background
                              onPrimary: numbers[index] == _selectedNumber
                                  ? Colors.white
                                  : Color.fromARGB(
                                      255, 65, 189, 210), // foreground
                            ),
                            onPressed: () {
                              final route = MaterialPageRoute(
                                  builder: (context) =>
                                      InvitePlayers(username: widget.nomUser));
                              Navigator.push(context, route);
                            },
                          ),
                        );
                      },
                    ),
                  )),
              // Row(
              //   children: <Widget>[
              //     SizedBox(
              //       width: 150,
              //       height: 150.0,
              //       child: TextButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.black54),
              //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12.0),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {
              //           // final route =
              //           //     MaterialPageRoute(builder: (context) => Partida());
              //           // Navigator.push(context, route);
              //         },
              //         child: const Text(
              //           '+',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontFamily: 'FredokaOne',
              //               fontSize: 80.0),
              //         ),
              //       ),
              //     ),

              //     const SizedBox(
              //       width: 20,
              //     ), //SizedBox
              //     SizedBox(
              //       width: 150,
              //       height: 150.0,
              //       child: TextButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.black54),
              //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12.0),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {
              //           // final route =
              //           //     MaterialPageRoute(builder: (context) => Partida());
              //           // Navigator.push(context, route);
              //         },
              //         child: const Text(
              //           '+',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontFamily: 'FredokaOne',
              //               fontSize: 80.0),
              //         ),
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 20,
              //     ), //
              //     SizedBox(
              //       width: 150,
              //       height: 150.0,
              //       child: TextButton(
              //         style: ButtonStyle(
              //           backgroundColor:
              //               MaterialStateProperty.all<Color>(Colors.black54),
              //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(12.0),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {
              //           // final route =
              //           //     MaterialPageRoute(builder: (context) => Partida());
              //           // Navigator.push(context, route);
              //         },
              //         child: const Text(
              //           '+',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontFamily: 'FredokaOne',
              //               fontSize: 80.0),
              //         ),
              //       ),
              //     ),
              //   ], //<Widget>[]
              //   mainAxisAlignment: MainAxisAlignment.center,
              // ),
              const SizedBox(
                height: 20,
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                      width: 240.0,
                      height: 42.0,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 25,
                          ),
                          ElevatedButton(
                            child: const Text('Copiar código'),
                            onPressed: () {
                              final data = ClipboardData(text: widget.idPagina);
                              Clipboard.setData(data);
                            },
                          ),
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 80,
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                        stompClient.activate();
                        print("entro a la partida");
                        final route = MaterialPageRoute(
                            builder: (context) => Partida(
                                  userListener: canalUser.stream,
                                  gameListener: canalGeneral.stream,
                                  //faltan de añadir 2 canales cambiarles el nombre
                                  stompClient: stompClient,
                                  nomUser: widget.nomUser,
                                  authorization: widget.autorization,
                                  idPartida: widget.idPagina,
                                ));
                        Navigator.push(context, route);
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

  Future<dynamic> faltanJugadores(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Aún no están todos los jugadores',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ));
  }
}
