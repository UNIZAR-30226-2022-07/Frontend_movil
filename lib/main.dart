import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/anadir_amigos.dart';
import 'package:flutter_unogame/src/pages/clasificacion.dart';
import 'package:flutter_unogame/src/pages/crear_partida.dart';
import 'package:flutter_unogame/src/pages/home_page.dart';
import 'package:flutter_unogame/src/pages/login_page.dart';
import 'package:flutter_unogame/src/pages/notifications_page.dart';
import 'package:flutter_unogame/src/pages/pantalla_anadir_jugadores.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/pages/search_players.dart';
import 'package:flutter_unogame/src/pages/sign_in.dart';
import 'package:flutter_unogame/src/pages/sign_up.dart';
import 'package:flutter_unogame/src/pages/forgot_password.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 255, 155, 147), centerTitle: true),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: 'Login',
      routes: <String, WidgetBuilder>{
        'Login': (BuildContext context) => LoginPage(),
        'sign_in': (BuildContext context) => const SignIn(),
        'sign_up': (BuildContext context) => const SignUp(),
        'forgot_password': (BuildContext context) => const forgotPassword(),
        'home_page': (BuildContext context) => const HomePage(
              autorization: '',
              username: '',
            ),
        'lista_amigos': (BuildContext context) => SearchPlayers(username: ''),
        // 'clasification': (BuildContext context) => ClasificationPage(
        //       userName: '',
        //     ),
        'anadir_jugadores': (BuildContext context) => AnadirJugadores(
              autorization: '',
              idPagina: '',
              nomUser: '',
              numP: 0,
            ),
        'crear_partida': (BuildContext context) => CreatePage(
              autorization: '',
              nomUser: '',
            ),
        'notificaciones': (BuildContext context) => Notifications(
              username: '',
            ),
        'search_friend': (BuildContext context) => AnadirAmigos(username: ''),
      },
    );
  }
}
