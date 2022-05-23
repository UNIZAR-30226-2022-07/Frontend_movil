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
bool tiempoA15 = false;

class CreatePage extends StatefulWidget {
  final String autorization;
  final String nomUser;
  const CreatePage(
      {Key? key, required this.autorization, required this.nomUser})
      : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool ceroSwitch = false;
  bool crazy7 = false;
  bool progDraw = false;
  bool chaosDraw = false;
  bool blockDraw = false;
  bool repeatDraw = false;
  int tiempo = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear partida',
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
                      const Text(
                        'Número de Personas',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IntrinsicHeight(
                            child: Row(children: [
                              IconButton(
                                onPressed: () {
                                  if (count > 1) setState(() => count--);
                                },
                                icon: const Icon(
                                  Icons.exposure_minus_1,
                                  color: Colors.white,
                                ),
                                iconSize: 30,
                              ),
                              const VerticalDivider(
                                thickness: 4,
                                color: Colors.white24,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (count < 6) {
                                    setState(() => count++);
                                  }
                                },
                                icon: const Icon(
                                  Icons.exposure_plus_1,
                                  color: Colors.white,
                                ),
                                iconSize: 30,
                              ),
                            ]),
                          ))
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiempo de turno',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      tiempoA15 ? Colors.blue : Colors.black38,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextButton(
                                    child: const Text(
                                      '15s',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    onPressed: () {
                                      setState(() => tiempoA15 = true);
                                      tiempo = 15;
                                    })),
                            Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      !tiempoA15 ? Colors.blue : Colors.black38,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextButton(
                                    child: const Text(
                                      '20s',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    onPressed: () {
                                      setState(() => tiempoA15 = false);
                                      tiempo = 20;
                                    }))
                          ],
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      CrearPartida();
                      // final route = MaterialPageRoute(
                      //     builder: (context) => AnadirJugadores());
                      // Navigator.push(context, route);
                    },
                    child: const Text('Crear'),
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
                          title: const Text('0 Switch'),
                          value: ceroSwitch,
                          onChanged: (regla1) =>
                              setState(() => ceroSwitch = regla1!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Crazy 7'),
                          value: crazy7,
                          onChanged: (regla2) =>
                              setState(() => crazy7 = regla2!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Progressive Draw'),
                          value: progDraw,
                          onChanged: (regla3) =>
                              setState(() => progDraw = regla3!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Chaos Draw'),
                          value: chaosDraw,
                          onChanged: (regla4) =>
                              setState(() => chaosDraw = regla4!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Block Draw'),
                          value: blockDraw,
                          onChanged: (regla3) =>
                              setState(() => blockDraw = regla3!),
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: const Text('Reapeat Draw'),
                          value: repeatDraw,
                          onChanged: (regla4) =>
                              setState(() => repeatDraw = regla4!),
                        ),
                      ),
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

  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'No se ha podido crear la partida',
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
                    'Se ha creado la partida correctamente',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 16, 159, 19),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  dynamic crearReglas() {
    List<String> reglas = [];
    if (ceroSwitch) {
      reglas.add('CERO_SWITCH');
    }
    if (blockDraw) {
      reglas.add('BLOCK_DRAW');
    }
    if (crazy7) {
      reglas.add('CRAZY_7');
    }
    if (progDraw) {
      reglas.add('PROGRESSIVE_DRAW');
    }
    if (chaosDraw) {
      reglas.add('CHAOS_DRAW');
    }
    if (repeatDraw) {
      reglas.add('REPEAT_DRAW');
    }
    return reglas;
  }

  Future CrearPartida() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/game/create');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    // Crear una función para construir el campo reglas
    dynamic a = crearReglas();
    Map mapeddate = {
      'playername': widget.nomUser,
      'nplayers': count,
      'tturn': tiempo,
      'rules': a
    };

    final response = await http.post(url,
        headers: headers, body: jsonEncode(mapeddate)); // print(response);
    if (response.statusCode == 200) {
      Map<String, dynamic> respuesta = json.decode(response
          .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
      print(respuesta);
      print(respuesta['id']);
      final route = MaterialPageRoute(
          builder: (context) => AnadirJugadores(
                nomUser: widget.nomUser,
                reglas: crearReglas(),
                autorization: widget.autorization,
                idPagina: respuesta['id'],
                numP: count,
                infoInicial: respuesta,
              ));
      Navigator.push(context, route);
      popUpCorrecto(context);
    } else {
      print('No se ha creado');
      if (response.statusCode != 200) {
        print(response.statusCode);
        popUpError(context);
      }
    }
  }
}
