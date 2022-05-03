import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:http/http.dart' as http;

import 'notificacion.dart';

class NotisApi {
  List<Notificacion> rtdos = [];
  static Future<List<Notificacion>> getNotifications(String username) async {
    Uri url =
        Uri.parse('https://onep1.herokuapp.com/friends/receive/friend-request');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));
    Map data = jsonDecode(response.body);
    print(data);
    List<Notificacion> _temp = [];

    var l = data['message'];
    var laux = json.decode(l);
    for (var i in laux) {
      print(i);
      _temp.add(Notificacion(
          person: i, body: 'Quiere ser tu amigo', accion: 'amistad'));
    }
    return _temp;
    //return Notificacion.NotificacionesFromSnapshot(_temp);
  }
}
