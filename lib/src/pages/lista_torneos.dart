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
        ),
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/fondo2.jpg'),
                      fit: BoxFit.cover)),
              padding: const EdgeInsets.all(20),
              child: FutureBuilder<List<dynamic>>(
                  //aqui sera FutureBuilder<List<TournamentList>>
                  future: FetchTournamentList
                      .getTournamentList(), // esta en API_service y sera _torneoList.getTournamentList(widget.username)
                  builder: (context, snapshot) {
                    var data = snapshot.data;
                    return ListView.builder(
                        itemCount: data?.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            popUpReglas(
                                                context,
                                                getReglas(
                                                    data?[index]['reglas']));
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
                                          String idTorneo = data![index];
                                          UnirseTorneo(idTorneo);
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
            TextButton(onPressed: () {}, child: Text('Crear torneo'))
          ],
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

  Future<dynamic> UnirseTorneo(String idTorneo) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/game/getInfoPartida');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'idPartida': idTorneo};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body);
      print(respuesta);
      print(respuesta['id']);
      final route = MaterialPageRoute(
          builder: (context) => AnadirJugadoresTorneo(
                nomUser: widget.username,
                autorization: widget.authorization,
                idPagina: respuesta['idTorneo'],
                numP: 9,
                infoInicial: respuesta,
                reglas: respuesta['reglas'],
              ));
      Navigator.push(context, route);
    } else {
      print('No se ha creado');
      if (response.statusCode != 200) {
        print(response.statusCode);
      }
    }
  }
}
