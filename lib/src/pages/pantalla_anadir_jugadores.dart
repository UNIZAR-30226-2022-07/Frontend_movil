

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnadirJugadores extends StatefulWidget {
  const AnadirJugadores({ Key? key }) : super(key: key);

  @override
  State<AnadirJugadores> createState() => _AnadirJugadoresState();
}

class _AnadirJugadoresState extends State<AnadirJugadores> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 237, 150, 150),
      ),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: const Color(0xff2c2c2c),
                ),
                child: Center(
                  child: Text(
                    'aqui el codigo',
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: 18,
                      color: Colors.white,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
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
                          // final route =
                          //     MaterialPageRoute(builder: (context) => Partida());
                          // Navigator.push(context, route);
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