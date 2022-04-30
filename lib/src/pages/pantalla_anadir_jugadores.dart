import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';


class AnadirJugadores extends StatefulWidget {
    final String idPagina;
  AnadirJugadores({required this.idPagina });
  
  String cogerID() {
    return this.idPagina;
  }

  @override
  State<AnadirJugadores> createState() => _AnadirJugadoresState();
}

class _AnadirJugadoresState extends State<AnadirJugadores> {
  
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
                      child: Text('Aqui va el codigo'),
                      onPressed: () {
                        final data = ClipboardData(text: '25342756374');
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
  
}