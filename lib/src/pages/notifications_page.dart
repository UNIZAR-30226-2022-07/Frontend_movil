import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import '../models/notificacion.dart';
import '../models/notificaciones_api.dart';

class Notifications extends StatefulWidget {
  String username;
  Notifications({Key? key, required this.username}) : super(key: key);

  @override
  State<Notifications> createState() => _notificationsState();
}

class _notificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notificaciones',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: NotisBuilder(widget.username));
  }

  Future<List<Notificacion>> getNotifications(String usuario) async {
    List<Notificacion> l = await NotisApi.getNotifications(usuario);
    return l;
  }

  Widget NotisBuilder(String usuario) {
    return FutureBuilder<List<Notificacion>>(
        future: getNotifications(usuario),
        builder: (context, projectSnap) {
          List<Notificacion>? data = projectSnap.data;
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
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
                  itemCount: (data == null) ? 1 : data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (!projectSnap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    '${data?[index].person}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text('${data?[index].body}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            //Enviar a Backend: Aceptar solicitud
                                            if ('${data?[index].accion}' ==
                                                'amistad') {
                                              AcceptFriend(
                                                      widget.username,
                                                      index,
                                                      '${data?[index].person}')
                                                  .then((_) => setState(() {}));
                                            }
                                            //notificaciones.removeAt(index);
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: IconButton(
                                          onPressed: () {
                                            //Enviar a Backend: denegar solicitud
                                            if ('${data?[index].accion}' ==
                                                'amistad') {
                                              CancelFriend(
                                                      widget.username,
                                                      index,
                                                      '${data?[index].person}')
                                                  .then((_) => setState(() {}));
                                            } else {
                                              // Cuando sea una invitación a una partida
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            //Faltan los iconos
                          ],
                        ),
                      ),
                      onDismissed: (direccion) {
                        // notificaciones.removeAt(index);
                        print(direccion);
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ]),
          );
        });
  }

  Future<dynamic> popUpErrorAceptarAmigo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Ha habido algún error al añadir a tu amigo',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future<dynamic> popUpCorrectoAceptarAmigo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Se ha añadido a tu amigo correctamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 16, 159, 19),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future AcceptFriend(String username, int i, String friend) async {
    Uri url =
        Uri.parse('https://onep1.herokuapp.com/friends/accept/friend-request');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username, 'friendname': friend};

    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body);
      // notificaciones.removeAt(i);
      // Navigator.pushReplacementNamed(context, 'home_page');
      popUpCorrectoAceptarAmigo(context);
    } else {
      popUpErrorAceptarAmigo(context);
      print(response.statusCode);
      print('Error');
    }
  }

  Future<dynamic> popUpErrorRechazarAmigo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Ha habido algún error al rechazar la petición',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future<dynamic> popUpCorrectoRechazarAmigo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Has rechazado la petición',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 16, 159, 19),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future CancelFriend(String username, int i, String friend) async {
    Uri url =
        Uri.parse('https://onep1.herokuapp.com/friends/cancel/friend-request');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username, 'friendname': friend};
    
    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      // notificaciones.removeAt(i);
    } else {
      print('Error');
    }
  }
}
