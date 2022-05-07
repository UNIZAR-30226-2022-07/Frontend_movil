import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/pages/login_page.dart';
import 'package:flutter_unogame/src/pages/sign_in.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final String username;
  EditPage({Key? key,required this.username}) : super(key: key);

  State<EditPage> createState() => _editState();
}

class _editState extends State<EditPage> {
  final List<String> items = [
    'España',
    'Francia',
    'Alemania',
    'Rumanía',
    'Bélgica',
    'Irlanda'
  ];
  String _newName = '';
  late String _newCountry;

  @override
  void initState() {
    _newCountry = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                    child: Column(
                  children: [
                    InputText(
                      hint: 'usuario123',
                      label: 'Nombre de usuario',
                      keyboard: TextInputType.emailAddress,
                      icono: const Icon(Icons.verified_user),
                      onChanged: (data) {
                        _newName = data;
                      },
                      validator: (data) {
                        if (data!.trim().isEmpty) {
                          return "Usuario inválido";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 150,
                      height: 45.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 196, 33, 22)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_newName.isNotEmpty ) {
                            EditName(widget.username, _newName);
                            final route = MaterialPageRoute(
                              builder: (context) => const SignIn());
                            Navigator.push(context, route);
                          }
                          else {
                            popUpErrorNombre(context);
                          }
                        },
                        child: const Text(
                          'Cambiar nombre',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                                color: Color.fromARGB(255, 96, 95, 95),
                                width: 1,
                                style: BorderStyle.solid)),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DropdownButton(
                                isExpanded: true,
                                style: Theme.of(context).textTheme.headline6,
                                value: _newCountry,
                                items: items
                                    .map<DropdownMenuItem<String>>(
                                        (String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Center(child: Text(item)),
                                            ))
                                    .toList(),
                                onChanged: (String? value) =>
                                    setState(() => _newCountry = value!),
                              ),
                            ])),
                    const SizedBox(
                      height: 25,
                    ),

                    SizedBox(
                      width: 150,
                      height: 45.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 196, 33, 22)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          EditCountry(widget.username, _newCountry);
                        },
                        child: const Text(
                          'Cambiar país',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            DeleteAccount(widget.username);
                            final route = MaterialPageRoute(
                              builder: (context) => LoginPage());
                            Navigator.push(context, route);
                          },
                          child: const Text(
                            'Eliminar cuenta',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal, fontFamily: 'FredokaOne'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            )
          ],
        ),
      ),
    );
  }



  Future<dynamic> popUpErrorNombre(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'No ha sido posible editar el nombre de usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
  }
  Future<dynamic> popUpCorrectoNombre(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'Se ha cambiado el nombre de usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 12, 149, 39),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
  }

  Future EditName(String username, String new_username) async {
    print(new_username);
    print(username);
    Uri url = Uri.parse('https://onep1.herokuapp.com/user/changeUsername');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username, 'newUsername': new_username};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      popUpCorrectoNombre(context);
      print(response);
    } else {
      print('Error al editar nombre');
      if (response.statusCode != 200) {
        popUpErrorNombre(context);
      }
    }
  }


  Future<dynamic> popUpErrorPais(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'No ha sido posible editar el país del usuario',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
  }
  Future<dynamic> popUpCorrectoPais(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'Se ha cambiado el país',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 12, 149, 39),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
    }

  Future EditCountry(String username, String country) async {
    print(username);
    Uri url = Uri.parse('https://onep1.herokuapp.com/user/changePais');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username, 'pais': country};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      popUpCorrectoPais(context);
      print(response);
    } else {
      print('Error al editar el país');
      if (response.statusCode != 200) {
        popUpErrorPais(context);
      }
    }
  }

  Future<dynamic> popUpCorrectoEliminar(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'Se ha eliminado la cuenta correctamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 12, 149, 39),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
    }

  Future<dynamic> popUpErrorEliminar(BuildContext context) {
      return showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: ((context, setState) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text(
                      'No ha sido posible eliminar la cuenta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))));
  }
  
  Future DeleteAccount(String username) async {
    print(username);
    Uri url = Uri.parse('https://onep1.herokuapp.com/user/deleteUser');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map mapeddate = {'username': username};

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      popUpCorrectoEliminar(context);
      print(response);
    } else {
      print('Error al eliminar cuenta');
      if (response.statusCode != 200) {
        popUpErrorEliminar(context);
      }
    }
  }
}
