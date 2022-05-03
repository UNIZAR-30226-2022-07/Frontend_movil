import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';


class AnadirJugadores extends StatefulWidget {
    final String idPagina;
    final String autorization;
  AnadirJugadores({required this.autorization,required this.idPagina });


  @override
  State<AnadirJugadores> createState() => _AnadirJugadoresState();
}

class _AnadirJugadoresState extends State<AnadirJugadores> {
  // late StompClient stompClient;
  // final socketUrl = 'ws://onep1.herokuapp.com/onep1-game';
  String message = '';
  
  @override
  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/connect/<id>',
      callback: (frame) {
        List<dynamic>? result = json.decode(frame.body!);
        print(result);
      },
    );

    Timer.periodic(Duration(seconds: 10), (_) {
      stompClient.send(
        destination: '/game/connect', body: "hola"
      );
    });
  }

  
  late StompClient stompClient = StompClient(
    config: StompConfig(
      url: 'ws://onep1.herokuapp.com/onep1-game',
      onConnect: onConnect,
      beforeConnect: () async {
        print('waiting to connect...');
        await Future.delayed(Duration(milliseconds: 200));
        print('connecting...');
      },
      onWebSocketError: (dynamic error) => print(error.toString()),
      stompConnectHeaders: {'Authorization': 'Bearer $widget.autorization'},
      webSocketConnectHeaders: {'Authorization': widget.autorization},
    ),
  );
  // void initState() {
  //   super.initState();
  //   if (stompClient == null) {
  //     StompFrame frame;
  //     StompClient client = StompClient(
  //         config: StompConfig(
  //           url: 'ws://onep1.herokuapp.com/onep1-game',
  //           onConnect: onConnect,
  //         ),
  //     );
  //     stompClient.activate();
  //   }
  // }
  


  // @override
  // void onConnect(StompFrame frame) {
  //   stompClient.subscribe(
  //       destination: '/topic/connect/<id>',
  //       callback: (frame) {
  //         print(frame.body);
  //       }
        
  //   );
  //   stompClient.activate();
  //   stompClient.send(destination: '/game/connect', body: "hola");
  // }
  

  @override
  Widget build(BuildContext context) {
      
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
      child: Column (
        children: <Widget>[
          SizedBox(
            height:80,
            width: 20,
          ), 
          Row(
            children: <Widget>[
                    SizedBox(
                      width: 150,
                      height: 150.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // final route =
                          //     MaterialPageRoute(builder: (context) => Partida());
                          // Navigator.push(context, route);
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 80.0),
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      width: 20,
                    ), //SizedBox
                    SizedBox(
                      width: 150,
                      height: 150.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // final route =
                          //     MaterialPageRoute(builder: (context) => Partida());
                          // Navigator.push(context, route);
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 80.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ), //
                    SizedBox(
                      width: 150,
                      height: 150.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black54),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // final route =
                          //     MaterialPageRoute(builder: (context) => Partida());
                          // Navigator.push(context, route);
                        },
                        child: const Text(
                          '+',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 80.0),
                        ),
                      ),
                    ),
                  ], //<Widget>[]
                  mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            height:20,
            width: 20,
          ), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 240.0,
                height: 42.0,
                child: Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                      
                      child: Text('Aqui va el codigo, no cabe'),
                      onPressed: () {
                        final data = ClipboardData(text: widget.idPagina);
                        Clipboard.setData(data);
                      },
                    ),
                  ],
                )
              ),
            ],
          ),
          SizedBox(
            height:20,
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
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 32, 159, 255)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          // CrearPartida();
                          // initState();
                          // print(widget.autorization);
                          stompClient.activate();
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
        ]
      )
    );
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient.deactivate();
    }super.dispose();
  }
  
}