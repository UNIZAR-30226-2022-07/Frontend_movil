import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:http/http.dart' as http;

import 'notificacion.dart';

class NotisApi {
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
    List _temp = [];

    for (var i in data['feed']) {
      _temp.add(i['content']['details']);
    }

    return Notificacion.NotificacionesFromSnapshot(_temp);
  }
}
