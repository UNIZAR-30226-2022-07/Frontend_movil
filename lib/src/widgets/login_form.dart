import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';
import 'dart:convert';

import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:async';

import '../pages/partida.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name = '';
  String _password = '';
  bool partidaEmpezada = false;
  final canalUser = StreamController.broadcast();
  final canalGeneral = StreamController.broadcast();
  final canalCartaMedio = StreamController.broadcast();
  final canalJugada = StreamController.broadcast();
  late List<String> _listaJugadores = [];
  String autori = '';
  String resp = '';
  late StompClient stompClient;
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'usuario123',
              label: 'Nombre de usuario',
              keyboard: TextInputType.emailAddress,
              icono: const Icon(Icons.verified_user),
              onChanged: (data) {
                _name = data;
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
            InputText(
              hint: 'Contraseña',
              label: 'Contraseña',
              obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _password = (data);
              },
              validator: (data) {
                if (data!.length < 6) {
                  return "Contraseña inválida";
                }
                return null;
              },
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
                    LoginUser();
                    //mirar si hay partidas activas
                  }
                },
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FredokaOne',
                      fontSize: 25.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '¿Tu primera vez aquí?',
                  style: TextStyle(fontFamily: 'FredokaOne'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'sign_up');
                  },
                  child: const Text(
                    '¡Regístrate!',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'forgot_password');
                  },
                  child: const Text(
                    'Recuperar contraseña',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            )
          ],
        ));
  }

  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'El nombre de usuario o la contraseña son incorrectos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))));
  }

  // Future LoginUser() async {
  //   Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signin');
  //   final headers = {
  //     HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
  //   };
  //   Map mapeddate = {'username': _name, 'password': _password};

  //   final response = await http.post(url,
  //       headers: headers, body: jsonEncode(mapeddate)); // print(response);
  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> respuesta = json.decode(response
  //         .body); // https://coflutter.com/dart-how-to-get-keys-and-values-from-map/
  //     // print(respuesta);
  //     // print(respuesta['accessToken']);
  //     final route = MaterialPageRoute(
  //         builder: (context) => HomePage(
  //               autorization: respuesta['accessToken'],
  //               username: respuesta['username'],
  //               pais: respuesta['pais'],
  //             ));
  //     Navigator.push(context, route);
  //     // Navigator.pushReplacementNamed(context, 'home_page');
  //     print(response);
  //   } else {
  //     print('Contraseña incorrecta');
  //     if (response.statusCode != 200) {
  //       popUpError(context);
  //     }
  //   }
  // }

  Future LoginUser() async {
    //----------------------------------------------------
    //--------------------------------------------------------
    Uri urlLogin = Uri.parse('https://onep1.herokuapp.com/api/auth/signin');
    Uri urlActive =
        Uri.parse('https://onep1.herokuapp.com/game/getPartidasActivas');
    Uri urlGetinfo =
        Uri.parse('https://onep1.herokuapp.com/game/getInfoPartida');
    //los headers son los mismos para ambos
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };

    Map mapeddateLogin = {'username': _name, 'password': _password};
    Map mapeddateActive = {'username': _name};

    final responseLogin = await http.post(urlLogin,
        headers: headers, body: jsonEncode(mapeddateLogin)); // print(response);

    if (responseLogin.statusCode == 200) {
      Map<String, dynamic> respuestaLogin = json.decode(responseLogin.body);
      final responseActive = await http.post(urlActive,
          headers: headers,
          body: jsonEncode(mapeddateActive)); // print(response);

      if (responseActive.statusCode == 200) {
        Map<String, dynamic> respuestaActive = json.decode(responseActive.body);
        if (respuestaActive['message'] == "No hay partidas para el usuario") {
          print("no hay partidas porque ha entrado");
          final route = MaterialPageRoute(
              builder: (context) => HomePage(
                    autorization: respuestaLogin['accessToken'],
                    username: respuestaLogin['username'],
                    pais: respuestaLogin['pais'],
                  ));
          Navigator.push(context, route);
          print(respuestaActive['message']);
        }
        //en el caso de que si que haya partidas
        else {
          print("ir a una partida");
          resp = respuestaActive['partidas'].toString();
          print("aqui va el id $resp");
          print(resp);
          //para enviar el id de la partida que nos han dado ellos mismos
          Map mapeddateGetinfo = {'idPartida': resp};
          final responseGetinfo = await http.post(urlGetinfo,
              headers: headers,
              body: jsonEncode(mapeddateGetinfo)); // print(response);
          if (responseGetinfo.statusCode == 200) {
            //aqui me pasan toda la info de la partida, y falta conectarme a ella
            Map<String, dynamic> respuestaGetinfo =
                json.decode(responseGetinfo.body);
            String numJ = respuestaGetinfo['numeroJugadores'].toString();
            String tt = respuestaGetinfo['tiempoTurno'].toString();
            String jugadores = respuestaGetinfo['jugadores'].toString();
            String reglas = respuestaGetinfo['reglas'].toString();
            void onConnect(StompFrame frame) async {
              autori = respuestaLogin['accessToken'].toString();
              //por aqui devuelve tu mano de cartas
              //Funciona
              stompClient.subscribe(
                  destination: '/user/$_name/msg',
                  callback: (StompFrame frame) async {
                    if (frame.body != null) {
                      print('Canal usuario');
                      print(frame.body);
                      dynamic a = "No es tu turno";
                      if (frame.body != a) {
                        if (!partidaEmpezada) {
                          partidaEmpezada = true;
                          final route = MaterialPageRoute(
                              builder: (context) => Partida(
                                    userListener: canalUser.stream,
                                    gameListener: canalGeneral.stream,
                                    cartaMedioListener: canalCartaMedio.stream,
                                    jugadaListener: canalJugada.stream,
                                    stompClient: stompClient,
                                    nomUser: _name,
                                    authorization: autori,
                                    idPartida: resp,
                                    infoInicial: respuestaGetinfo,
                                    listaInicial: _listaJugadores,
                                  ));
                          Navigator.push(context, route);
                        }
                        await Future.delayed(const Duration(seconds: 1));
                        canalUser.sink.add(json.decode(frame.body!));
                      }
                    }
                  });
              //conectarse a la partida y nos devuelve la lista de los jugadores
              stompClient.subscribe(
                destination: '/topic/connect/$resp',
                callback: (StompFrame frame) {
                  if (frame.body != null) {
                    canalGeneral.sink.add(json.decode(frame.body!));
                    print('Canal general');
                    print(json.decode(frame.body!));
                    if (!partidaEmpezada) {
                      dynamic a = json.decode(frame.body!);
                      List<String> jugadores = [];
                      for (dynamic i in a) {
                        jugadores.add(i['nombre']);
                      }
                      print(jugadores);
                      setState(() {
                        _listaJugadores = jugadores;
                      });
                    }
                  }
                },
              );
              //devuelve la carta del medio
              stompClient.subscribe(
                destination: '/topic/begin/$resp',
                callback: (StompFrame frame) async {
                  if (frame.body != null) {
                    print('Canal carta medio:');
                    print(frame.body);
                    if (!partidaEmpezada) {
                      partidaEmpezada = true;
                      final route = MaterialPageRoute(
                          builder: (context) => Partida(
                                userListener: canalUser.stream,
                                gameListener: canalGeneral.stream,
                                cartaMedioListener: canalCartaMedio.stream,
                                jugadaListener: canalJugada.stream,
                                stompClient: stompClient,
                                nomUser: _name,
                                authorization: autori,
                                idPartida: resp,
                                infoInicial: respuestaGetinfo,
                                listaInicial: _listaJugadores,
                              ));
                      Navigator.push(context, route);
                    }
                    await Future.delayed(const Duration(seconds: 1));
                    canalCartaMedio.sink.add(json.decode(frame.body!));
                  }
                },
              );
              //enviar mensaje para jugar una carta
              stompClient.subscribe(
                destination: '/topic/jugada/$resp',
                callback: (StompFrame frame) {
                  if (frame.body != null) {
                    canalJugada.sink.add(json.decode(frame.body!));
                    print('Canal jugada');
                    print(frame.body);
                  }
                },
              );

              stompClient.subscribe(
                  destination: '/topic/disconnect/$resp',
                  callback: (StompFrame frame) async {
                    if (frame.body != null) {
                      print('Canal usuario');
                      print(frame.body);
                      await Future.delayed(const Duration(seconds: 1));
                      canalUser.sink.add(json.decode(frame.body!));
                    }
                  });
              //para el boton de uno
              stompClient.subscribe(
                  destination: '/topic/buttonOne/$resp',
                  callback: (StompFrame frame) async {
                    if (frame.body != null) {
                      print('Canal usuario');
                      print(frame.body);
                      await Future.delayed(const Duration(seconds: 1));
                      canalUser.sink.add(json.decode(frame.body!));
                    }
                  });
              //Envío de mensaje para conectarte a una partida
              // stompClient.send(
              //     destination: '/game/connect/$resp',
              //     body: '',
              //     headers: {
              //       'Authorization': 'Bearer $autori',
              //       'username': _name
              //     });
            }

            stompClient = StompClient(
              config: StompConfig.SockJS(
                url: 'https://onep1.herokuapp.com/onep1-game',
                onConnect: onConnect,
                beforeConnect: () async {
                  print('waiting to connect...');
                  await Future.delayed(const Duration(milliseconds: 200));
                  print('connecting...');
                },
                stompConnectHeaders: {
                  'Authorization': 'Bearer $autori',
                  'username': _name
                },
                webSocketConnectHeaders: {
                  'Authorization': 'Bearer $autori',
                  'username': _name
                },
                onWebSocketError: (dynamic error) => print(error.toString()),
                onStompError: (dynamic error) => print(error.toString()),
                onDisconnect: (f) => print('disconnected'),
              ),
            );

            // @override
            // void initState() {
            //   super.initState();
            //   if (stompClient == null) {
            //     StompFrame frame;
            //     StompClient client = StompClient(
            //         config: StompConfig.SockJS(
            //       url: 'wss://onep1.herokuapp.com/onep1-game',
            //       onConnect: onConnect,
            //       onWebSocketError: (dynamic error) => print(error.toString()),
            //     ));
            //     stompClient.activate();
            //   }
            // }
            stompClient.activate();
            GetMiMano();
          } else {
            print("problema con la info que me envían de la partida");
          }
        }
      } else {
        print("error en las partidas activas");
      }
    }
    //---------------------------------------------------------------------------------------

    else {
      print('Contraseña incorrecta');
      if (responseLogin.statusCode != 200) {
        popUpError(context);
      }
    }
  }

  Future GetMiMano() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/game/getManoJugador');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map<String, String> mapeddate = {
      'username': _name,
      'idPartida': resp,
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));

    if (response.statusCode == 200) {
      print("ha legado bien el mensaje");
    } else {
      print("ha llegado mal el mensaje");
    }
  }
}
