import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class FetchUserList {
  var data = [];
  List<Userlist> results = [];
  String urlList = 'https://jsonplaceholder.typicode.com/users/';

  Future<List<Userlist>> getuserList({String? query}) async {
    var url = Uri.parse(urlList);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => Userlist.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.username!.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
      } else {
        print("fetch error");
      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }

  getFriendList() {}
}


class FetchFriendList {
  var data = [];
  List<Userlist> results = [];
  // String urlList = 'https://onep1.herokuapp.com/friends/friendsList';

  Future<List<Userlist>> getFriendList({String? query}) async {
    var url = Uri.parse('https://onep1.herokuapp.com/friends/friendsList');
    try {
      
      final headers = {
        HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
      };

      var _name;
      Map mapeddate = {'username': "paulapruebas"};
      
      final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate));
      if (response.statusCode == 200) {
        data = json.decode(response.body);
        results = data.map((e) => Userlist.fromJson(e)).toList();
        if (query != null) {
          results = results
              .where((element) =>
                  element.username!.toLowerCase().contains((query.toLowerCase())))
              .toList();
        }
      } 
      else {
        print("fetch error");
        print(response.statusCode);

      }
    } on Exception catch (e) {
      print('error: $e');
    }
    return results;
  }
}
