import 'dart:convert';

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
                  element.name!.toLowerCase().contains((query.toLowerCase())))
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
}
<<<<<<< HEAD

  Future RegistrationUser() async{
    var uri = Uri.http("localhost:2000","");

    Map mapeddate ={
      'service':'credentials',
      'login':_email,
      'passwd':_password
    };
    print("JSON DATA: ${mapeddate}");

    http.Response response = await http.post(uri,body:mapeddate);
    // print(response);
    var data = jsonDecode(response.body);

    print("DATA: ${data}");

  }
=======
>>>>>>> 658b034178e05466574bd6f863a437c8272ddc1f
