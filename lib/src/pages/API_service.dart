import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class FetchFriendList {
  static Future<List<Userlist>> getFriendList(String username) async {
    var url = Uri.parse('https://onep1.herokuapp.com/friends/friendsList');
    List<Userlist> results = [];
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
      };

      Map mapeddate = {
        'username': username
      }; // lo que yo le mando a backend para que me mande la lista de amigos

      final response =
          await http.post(url, headers: headers, body: jsonEncode(mapeddate));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        print(data);
        var l = data['message'];
        var laux = json.decode(l);
        for (var i in laux) {
          print(i);
          results.add(Userlist(username: i));
        }
        return results;
      } else {
        print("fetch error");
        print(response.statusCode);
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}

class FetchTournamentList {
  static Future<List<dynamic>> getTournamentList() async {
    var url = Uri.parse('https://onep1.herokuapp.com/torneo/getTorneos');
    List<dynamic> results = [];
    try {
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
      };

      Map mapeddate =
          {}; // lo que yo le mando a backend para que me mande la lista de amigos

      final response =
          await http.post(url, headers: headers, body: jsonEncode(mapeddate));

      if (response.statusCode == 200) {
        results = jsonDecode(response.body);
        print(results);
        return results;
      } else {
        print("fetch error");
        print(response.statusCode);
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}


