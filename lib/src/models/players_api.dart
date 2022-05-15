import 'dart:convert';
import 'dart:io';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:http/http.dart' as http;

class PlayerApi {
  static Future<List<Player>> getRecipe() async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "18", "start": "0", "tag": "list.recipe.popular"});

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": "YOUR API KEY FROM YUMMLY API",
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['feed']) {
      _temp.add(i['content']['details']);
    }

    return Player.playersFromSnapshot(_temp);
  }

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
      String cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      // String pais = cutted[2];
      print(i);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => a.trophies.compareTo(b.trophies));
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
    print(data);

    var l = data['message'];
    var laux = json.decode(l);
    List<Player> rtdos = [];
    for (var i in laux) {
      List<String> cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      print(i);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => a.trophies.compareTo(b.trophies));
    int n = 1;
    for (var j in rtdos) {
      j.rating = n;
      n++;
    }
    return rtdos;
    //return Notificacion.NotificacionesFromSnapshot(_temp);
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
    //"[\"3nsalada3,0,espagna\",\"nereapruebas,0,España\"]"
    for (var i in laux) {
      print(i);
      List<String> cutted = i.split(',');
      String name = cutted[0];
      int trophies = int.parse(cutted[1]);
      rtdos.add(Player(userName: name, trophies: trophies));
    }
    rtdos.sort((a, b) => a.trophies.compareTo(b.trophies));
    int n = 1;
    for (var j in rtdos) {
      j.rating = n;
      n++;
    }
    return rtdos;
    //return Notificacion.NotificacionesFromSnapshot(_temp);
  }
}
