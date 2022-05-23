import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/anadir_amigos.dart';
import 'package:flutter_unogame/src/pages/pantalla_anadir_jugadores_torneo.dart';
import 'package:flutter_unogame/src/pages/search.dart';
import '../models/user_model.dart';
import 'API_service.dart';
import 'package:http/http.dart' as http;

import 'crear_torneo.dart';

class ListTorneos extends StatefulWidget {
  final String username;
  final String authorization;
  const ListTorneos(
      {Key? key, required this.username, required this.authorization})
      : super(key: key);
  @override
  _ListTorneosState createState() => _ListTorneosState();
}

class _ListTorneosState extends State<ListTorneos> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Torneos',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => CreateTournament(
                        autorization: widget.authorization,
                        username: widget.username));
                Navigator.push(context, route);
              },
              child: const Text(
                'Crear torneo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<dynamic>>(
              //aqui sera FutureBuilder<List<TournamentList>>
              future: FetchTournamentList
                  .getTournamentList(), // esta en API_service y sera _torneoList.getTournamentList(widget.username)
              builder: (context, snapshot) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    // 'Torneo ${index}',
                                    '${((data?[index])['jugadores'])[0]}', //aqui sera el nombre del torneo realmente
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    // 'Torneo ${index}',
                                    '${((data?[index])['jugadores']).length}/9', //aqui sera el nombre del torneo realmente
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        popUpReglas(context,
                                            getReglas(data?[index]['reglas']));
                                      },
                                      child: const Text('Reglas activas')),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color.fromARGB(
                                                  255, 221, 26, 26)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      String idTorneo =
                                          data![index]['idTorneo'];
                                      dynamic d = data[index];
                                      UnirseTorneo(d);
                                    },
                                    child: const Text(
                                      'Unirme',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'FredokaOne',
                                          fontSize: 15.0),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }

  String getReglas(List<dynamic> reglas) {
    String rtdo = 'Reglas activas: ';
    bool primera = true;
    for (dynamic a in reglas) {
      if (primera) {
        rtdo += a;
        primera = false;
      } else {
        rtdo += ', ' + a;
      }
    }
    return rtdo;
  }

  Future<dynamic> popUpReglas(BuildContext context, String mensaje) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Reglas activas',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  content: Text(mensaje),
                ))));
  }

//{idTorneo: b81f8516-9fc3-4735-a89e-52251f1e89b3, tiempoTurno: 10, jugadores: [Helios2, victor], reglas: []}
  Future<dynamic> UnirseTorneo(dynamic dataTorneo) async {
    // print(response);
    final route = MaterialPageRoute(
        builder: (context) => AnadirJugadoresTorneo(
              nomUser: widget.username,
              autorization: widget.authorization,
              idPagina: dataTorneo['idTorneo'],
              numP: 9,
              infoInicial: dataTorneo,
              reglas: dataTorneo['reglas'],
            ));
    Navigator.push(context, route);
  }
}
