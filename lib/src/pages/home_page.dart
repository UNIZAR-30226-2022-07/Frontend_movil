import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/pages/wait_publica.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/clasificacion.dart';
import 'package:flutter_unogame/src/pages/crear_torneo.dart';
import 'package:flutter_unogame/src/pages/editar_perfil.dart';
import 'package:flutter_unogame/src/pages/lista_torneos.dart';
import 'package:flutter_unogame/src/pages/notifications_page.dart';
import 'package:flutter_unogame/src/pages/pantalla_espera.dart';
import 'package:flutter_unogame/src/pages/search_players.dart';
import 'crear_partida.dart';

class HomePage extends StatefulWidget {
  final String autorization;
  final String username;
  final String pais;
  const HomePage(
      {Key? key,
      required this.autorization,
      required this.username,
      required this.pais})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;

  GlobalKey<FormState> _formKey = GlobalKey();
  String code = '';
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.emoji_events,
                size: 40,
                color: Colors.yellow,
              ),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => ClasificationPage(
                          userName: widget.username,
                          pais: widget.pais,
                        ));
                Navigator.push(context, route);
              },
            )),
        //backgroundColor: const Color.fromARGB(255, 255, 155, 147),
        actions: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 40,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => Notifications(
                          username: widget.username,
                          authorization: widget.autorization,
                        ));
                Navigator.push(context, route);
              },
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.supervised_user_circle_rounded,
                size: 40,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) =>
                        SearchPlayers(username: widget.username));
                Navigator.push(context, route);
              },
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 36,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => EditPage(username: widget.username));
                Navigator.push(context, route);
              },
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            // gradient: LinearGradient(colors: <Color>[
            //   Color.fromARGB(255, 255, 244, 244),
            //   Color.fromARGB(0, 255, 70, 70)
            // ], begin: Alignment.topCenter),
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          children: <Widget>[
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Uri url = Uri.parse(
                            'https://onep1.herokuapp.com/game/getPartidaPublica');
                        final headers = {
                          HttpHeaders.contentTypeHeader:
                              "application/json; charset=UTF-8"
                        };

                        final responsePartida =
                            await http.post(url, headers: headers);
                        if (responsePartida.statusCode == 200) {
                          dynamic idPartida = json.decode(responsePartida.body);
                          Uri url = Uri.parse(
                              'https://onep1.herokuapp.com/game/getInfoPartida');
                          print(idPartida);
                          Map mapeddate = {
                            'idPartida': idPartida,
                          };
                          final response = await http.post(url,
                              headers: headers, body: jsonEncode(mapeddate));
                          if (response.statusCode == 200) {
                            Map<String, dynamic> respuesta =
                                json.decode(response.body);
                            print(respuesta);
                            List<String> jugadores = [];
                            for (dynamic a in respuesta['jugadores']) {
                              jugadores.add(a);
                            }
                            final route = MaterialPageRoute(
                                builder: (context) => EsperaPublica(
                                      autorization: widget.autorization,
                                      idPagina: idPartida,
                                      nomUser: widget.username,
                                      nPlayers: respuesta['numeroJugadores'],
                                      jugadores: jugadores,
                                      infoInicial: respuesta,
                                    ));
                            Navigator.push(context, route);
                          } else {
                            print('Error');
                            dynamic respuesta = json.decode(response.body);
                            print(respuesta);
                          }
                        } else {
                          print('Error');
                          dynamic respuesta = json.decode(responsePartida.body);
                          print(respuesta);
                        }
                      },
                      child: const Text(
                        'Partida rápida',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'FredokaOne',
                            fontSize: 30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        final route = MaterialPageRoute(
                            builder: (context) => CreatePage(
                                  nomUser: widget.username,
                                  autorization: widget.autorization,
                                ));
                        Navigator.push(context, route);
                      },
                      child: const Text(
                        'Crear partida privada',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'FredokaOne',
                            fontSize: 30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final code = await openDialog();
                        if (code == null || code.isEmpty) return;
                        Uri url = Uri.parse(
                            'https://onep1.herokuapp.com/game/getInfoPartida');
                        final headers = {
                          HttpHeaders.contentTypeHeader:
                              "application/json; charset=UTF-8"
                        };
                        Map mapeddate = {
                          'idPartida': code,
                        };
                        final response = await http.post(url,
                            headers: headers, body: jsonEncode(mapeddate));
                        print(response.body);
                        setState(() => this.code = code);
                        if (response.statusCode == 200) {
                          Map<String, dynamic> respuesta =
                              json.decode(response.body);
                          print(respuesta);
                          List<String> jugadores = [];
                          for (dynamic a in respuesta['jugadores']) {
                            jugadores.add(a);
                          }
                          final route = MaterialPageRoute(
                              builder: (context) => EsperaPartida(
                                  autorization: widget.autorization,
                                  idPagina: code,
                                  nomUser: widget.username,
                                  nPlayers: respuesta['numeroJugadores'],
                                  jugadores: jugadores,
                                  infoInicial: respuesta,
                                  reglas: respuesta['reglas']));
                          Navigator.push(context, route);
                        }
                      },
                      child: const Text(
                        'Unirse a partida privada',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'FredokaOne',
                            fontSize: 30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black54),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        final route = MaterialPageRoute(
                            builder: (context) => ListTorneos(
                                  username: widget.username,
                                  authorization: widget.autorization,
                                ));
                        Navigator.push(context, route);
                      },
                      child: const Text(
                        'Buscar torneo',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'FredokaOne',
                            fontSize: 30.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //   SizedBox(
                  //     width: double.infinity,
                  //     height: 50.0,
                  //     child: TextButton(
                  //       style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStateProperty.all<Color>(Colors.black54),
                  //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //           RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(12.0),
                  //           ),
                  //         ),
                  //       ),
                  //       onPressed: () {
                  //         final route = MaterialPageRoute(
                  //             builder: (context) => CreateTournament(
                  //                 autorization: widget.autorization,
                  //                 username: widget.username));
                  //         Navigator.push(context, route);
                  //       },
                  //       child: const Text(
                  //         'Crear torneo',
                  //         style: TextStyle(
                  //             color: Colors.white,
                  //             fontFamily: 'FredokaOne',
                  //             fontSize: 30.0),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ])
          ],
        ),
      ),
    );
  }

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Inserta el codigo de partida:'),
            content: TextField(
              autofocus: true,
              // decoration: InputDecoration(hintText: 'Enter code'),
              controller: controller, // para acceder al codigo que introducimos
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('Submit')),
            ],
          ));

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
