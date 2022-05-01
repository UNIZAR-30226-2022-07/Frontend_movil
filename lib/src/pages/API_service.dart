import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';


// class FetchFriendList {
//   var data = [];
//   List<Userlist> results = []; //para meter aqui los amigos

//   Future<List<Userlist>> getFriendList() async {
//     var url = Uri.parse('https://onep1.herokuapp.com/friends/friendsList');
//     try {
      
//       final headers = {
//         HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
//       };

//       Map mapeddate = {'username': "paulapruebas"}; // lo que yo le mando a backend para que me mande la lista de amigos
      
//       final response = await http.post(url,
//         headers: headers, body: jsonEncode(mapeddate));
      
//       if (response.statusCode == 200) {
//         Map<String, dynamic> respuesta = json.decode(response.body);
//         respuesta["username"].forEach((value) {
//           // añadir al value a results
//           print(value);
//           results.add(value);
//         });
//         // results = data.map((e) => Userlist.fromJson(e)).toList();
//         // if (query != null) {
//         //   results = results
//         //       .where((element) =>
//         //           element.username!.toLowerCase().contains((query.toLowerCase())))
//         //       .toList();
//         // }
//       } 
//       else {
//         print("fetch error");
//         print(response.statusCode);

//       }
//     } on Exception catch (e) {
//       print('error: $e');
//     }
//     return results;
//   }
// }
