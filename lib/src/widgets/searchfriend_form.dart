import 'dart:convert';
import 'dart:io';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class SearchFriendForm extends StatefulWidget {
  const SearchFriendForm({ Key? key }) : super(key: key);

  @override
  State<SearchFriendForm> createState() => _SearchFriendFormState();
}

class _SearchFriendFormState extends State<SearchFriendForm> {
  String respuestaBackend = '';
  GlobalKey<FormState> _formKey = GlobalKey();
  String friendname = '';
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'user123',
              label: 'Friend username',
              icono: const Icon(Icons.search),
              onChanged: (data) {
                friendname = data;
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "Usuario inválido";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xE6CC0E08)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    SearchFriend();
                  }
                  
                },
                child: const Text(
                  'Buscar',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FredokaOne',
                      fontSize: 25.0),
                ),
              ),
            ),
          ],
        )
      );
  }
  
  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Ha ocurrido un error', //en realidad habria que imprimir respuestaBackend
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  Future<dynamic> popUpCorrecto(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Has enviado una petición de amistad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 25, 170, 49),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }
  
  Future SearchFriend() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/friends/send/friend-request');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    print(friendname);
    Map mapeddate = {'username': "nereapruebas", 'friendname': friendname};
    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response.body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      // print(respuesta['accessToken']);
      // final route = MaterialPageRoute(
      //                     builder: (context) => HomePage(autorization: respuesta['accessToken'],));
      //                 Navigator.push(context, route);
      // Navigator.pushReplacementNamed(context, 'home_page');
      popUpCorrecto(context);
      print(response);
    } else {
      Map<String, dynamic> respuesta = json.decode(response.body);
      print(respuesta);
      // print('No existe el usuario');
      popUpError(context);
      print(response.statusCode);
    }
  }
}