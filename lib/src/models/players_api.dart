import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:http/http.dart' as http;

class PlayerApi {
  List<Player> rtdos = [];
  static Future<List<Player>> getPlayers(String username) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/ranking/rankingAmigos');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));
    Map data = jsonDecode(response.body);
    print(data);

    var l = data['message'];
    var laux = json.decode(l);
    List<Player> rtdos = [];
    //"[\"3nsalada3,0,espagna\",\"nereapruebas,0,España\"]"
    for (var i in laux) {
      List<String> cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => b.trophies.compareTo(a.trophies));
    int n = 1;
    for (var j in rtdos) {
      j.rating = n;
      n++;
    }
    return rtdos;
    //return Notificacion.NotificacionesFromSnapshot(_temp);
  }

  static Future<List<Player>> getPlayersPais(String pais) async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/ranking/rankingPais');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'pais': pais};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));
    Map data = jsonDecode(response.body);
    print('funcion pais');
    print(data);

    var l = data['message'];
    var laux = json.decode(l);
    List<Player> rtdos = [];
    for (var i in laux) {
      List<String> cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => b.trophies.compareTo(a.trophies));
    int n = 1;
    for (var j in rtdos) {
      j.rating = n;
      n++;
    }
    return rtdos;
  }

  static Future<List<Player>> getPlayersWorld() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/ranking/rankingMundial');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    final response = await http.post(url, headers: headers);
    Map data = jsonDecode(response.body);
    print(data);

    var l = data['message'];
    var laux = json.decode(l);

    List<Player> rtdos = [];
    for (var i in laux) {
      List<String> cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => b.trophies.compareTo(a.trophies));
    int n = 1;
    for (var j in rtdos) {
      j.rating = n;
      n++;
    }
    return rtdos;
  }
}
