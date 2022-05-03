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

dynamic a = Notificacion(person: 'Julián', body: 'Quiere ser tu amigo');

class _notificationsState extends State<Notifications> {
  List<Notificacion> notificaciones = [
    Notificacion(
        person: 'Julián',
        accion: 'amistad',
        body: 'te ha invitado a una partida'),
    a,
    a,
    a,
    a,
    a,
    a,
    a
  ];
  //final notis = NotisApi.getNotifications(widget.username);

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          child: Flex(direction: Axis.vertical, children: [
            Expanded(
              child: ListView.builder(
                itemCount: notificaciones.length,
                itemBuilder: (BuildContext context, int index) {
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
                                  notificaciones[index].person,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(notificaciones[index].body,
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
                                          if (notificaciones[index].accion ==
                                              'amistad') {
                                            AcceptFriend(
                                                    widget.username,
                                                    index,
                                                    notificaciones[index]
                                                        .person)
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
                                          if (notificaciones[index].accion ==
                                              'amistad') {
                                            CancelFriend(
                                                    widget.username,
                                                    index,
                                                    notificaciones[index]
                                                        .person)
                                                .then((_) => setState(() {}));
                                          } else {
                                            // Cuando sea una invitación a una partida
                                          }
                                          //notificaciones.removeAt(index);
                                          //Navigator.of(context).pop();
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
                      notificaciones.removeAt(index);
                      print(direccion);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ]),
        ));
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
    print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      print(respuesta['accessToken']);
      notificaciones.removeAt(i);
      // Navigator.pushReplacementNamed(context, 'home_page');
      print(response);
    } else {
      print(response.statusCode);
      print('Error');
    }
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
      print(respuesta['accessToken']);
      notificaciones.removeAt(i);
      // En este caso hay que borrar la notificación
      // Navigator.pushReplacementNamed(context, 'home_page');
      print(response);
    } else {
      print('Error');
    }
  }
}
