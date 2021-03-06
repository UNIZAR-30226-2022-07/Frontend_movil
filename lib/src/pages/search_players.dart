import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/anadir_amigos.dart';
import '../models/user_model.dart';
import 'API_service.dart';
import 'package:http/http.dart' as http;

class SearchPlayers extends StatefulWidget {
  final String username;
  const SearchPlayers({Key? key, required this.username}) : super(key: key);
  @override
  _SearchPlayersState createState() => _SearchPlayersState();
}

class _SearchPlayersState extends State<SearchPlayers> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Mis amigos',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () {
                  final route = MaterialPageRoute(
                      builder: (context) =>
                          AnadirAmigos(username: widget.username));
                  Navigator.push(context, route);
                },
                iconSize: 38.0,
                icon: const Icon(Icons.add),
              )
            ],
          ),
          body: PlayerBuilder()),
    );
  }

  Widget PlayerBuilder() {
    return FutureBuilder<List<Userlist>>(
        future: FetchFriendList.getFriendList(
            widget.username), // esta en API_service
        builder: (context, snapshot) {
          var data = snapshot.data;
          if (snapshot.connectionState == ConnectionState.none &&
              snapshot.hasData == null) {
            return Container();
          }
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
            child: Flex(direction: Axis.vertical, children: [
              Expanded(
                child: ListView.builder(
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
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      '${data?[index].username}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  // const SizedBox(width: 300),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextButton(
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
                                        String nom = '${data?[index].username}';
                                        print(nom);
                                        DeleteFriend(widget.username, nom)
                                            .then((_) => setState(() {}));
                                      },
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'FredokaOne',
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
              ),
            ]),
          );
        });
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

  Future DeleteFriend(String username, String friendname) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/friends/deleteFriend');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    print(friendname);
    Map mapeddate = {'username': username, 'friendname': friendname};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
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
