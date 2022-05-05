import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/anadir_amigos.dart';
import 'package:flutter_unogame/src/pages/search.dart';
import '../models/user_model.dart';
import 'API_service.dart';
import 'package:http/http.dart' as http;

class SearchPlayers extends StatefulWidget {
  @override
  _SearchPlayersState createState() => _SearchPlayersState();
}

class _SearchPlayersState extends State<SearchPlayers> {
  final FetchFriendList _friendList = FetchFriendList();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My friends',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              onPressed: () {
                final route = MaterialPageRoute(
                          builder: (context) => AnadirAmigos());
                      Navigator.push(context, route);
              },
              iconSize: 38.0,
              icon: const Icon(Icons.add),
            )
          ], 
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<Userlist>>(
              future: _friendList.getFriendList(), // esta en API_service
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
                                        '${data?[index].username}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
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
                                          String nom = '${data?[index].username}';
                                          print(nom);
                                          DeleteFriend(nom);
                                        },
                                        child: const Text(
                                          'Eliminar',
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

    Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Ha ocurrido un error', //en realidad habria que imprimir respuestaBackend
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future<dynamic> popUpCorrecto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Se ha eliminado correctamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 25, 170, 49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }
  
  Future DeleteFriend(String friendname) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/friends/deleteFriend');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    print(friendname);
    Map mapeddate = {'username': "paulapruebas", 'friendname': friendname};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      popUpCorrecto(context);
      print(response);
    } else {
      Map<String, dynamic> respuesta = json.decode(response.body);
      print(respuesta);
      // print('No existe el usuario');
      popUpError(context);
      print(response.statusCode);
    }
  }
}




