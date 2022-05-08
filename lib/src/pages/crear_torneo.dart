import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/pantalla_anadir_jugadores.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';
int count = 2;
bool tiempoA10 = false;

class CreateTournament extends StatefulWidget {
  final String autorization;
  final String username;
  const CreateTournament({Key? key,required this.autorization, required this.username}) : super(key: key);

  @override
  State<CreateTournament> createState() => _CreateTournamentState();
}

class _CreateTournamentState extends State<CreateTournament> {
  bool regla1 = false;
  bool regla2 = false;
  bool regla3 = false;
  bool regla4 = false;
  int tiempo = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear torneo',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                                height: 150,
                              ),
                      const Text(
                        'Reglas de la partida',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Reglas',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 40,
                              )
                            ],
                          ),
                          onPressed: () {
                            popUpReglas(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // CrearTorneo(); //falta de implementar aqui esta funcion
                      final route = MaterialPageRoute(
                          builder: (context) => HomePage(autorization: widget.autorization,
                username: widget.username));
                      Navigator.push(context, route);
                    },
                    child: const Text('Crear'),

                    //onPressed: () => {}, child: const Text('Crear'))
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future<dynamic> popUpReglas(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('Popup example'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Regla 1'),
                          value: regla1,
                          onChanged: (regla1) =>
                              setState(() => this.regla1 = regla1!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Regla 2'),
                          value: regla2,
                          onChanged: (regla2) =>
                              setState(() => this.regla2 = regla2!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Regla 3'),
                          value: regla3,
                          onChanged: (regla3) =>
                              setState(() => this.regla3 = regla3!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Regla 4'),
                          value: regla4,
                          onChanged: (regla4) =>
                              setState(() => this.regla4 = regla4!),
                        ),
                      ),
                      // Switch.adaptive(
                      //     value: regla1,
                      //     onChanged: (regla1) => setState(() => regla1 = true))
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ))));
  }
}