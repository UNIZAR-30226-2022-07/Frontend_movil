import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/anadir_amigos.dart';
import 'package:flutter_unogame/src/pages/search.dart';
import '../models/user_model.dart';
import 'API_service.dart';
import 'package:http/http.dart' as http;

class ListTorneos extends StatefulWidget {
  final String username;
  const ListTorneos({Key? key,required this.username})
      : super(key: key);
  @override
  _ListTorneosState createState() => _ListTorneosState();
}

class _ListTorneosState extends State<ListTorneos> {
  final FetchTournamentList _torunamentList = FetchTournamentList();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Torneos',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<dynamic>>( //aqui sera FutureBuilder<List<TournamentList>>
              future: _torunamentList.getTournamentList(), // esta en API_service y sera _torneoList.getTournamentList(widget.username)
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
                              children: [
                                const SizedBox(width: 20),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Torneo ${index}',
                                        // '${data?[index]}', //aqui sera el nombre del torneo realmente
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 50.0),
                                      // Text(
                                      //   'hola',
                                      //   style: const TextStyle(
                                      //       fontSize: 18,
                                      //       fontWeight: FontWeight.w600),
                                      // ),
                                      const SizedBox(width:400),
                                      TextButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 221, 26, 26)),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          // String nom = '${data?[index].username}';
                                          // print(nom);
                                          //aqui habrá que poner lo que haga cuando le de a unirse
                                        },
                                        child: const Text(
                                          'Unirme',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'FredokaOne',
                                              fontSize: 15.0),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ])
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}