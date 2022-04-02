import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/clasificacion.dart';
import 'package:flutter_unogame/src/pages/game.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/pages/search_players.dart';
import 'crear_partida.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      appBar: AppBar(
        // title: const Text(
        //   'Home',
        //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        // ),
        centerTitle: true,
        leading: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.emoji_events,
                size: 40,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {
                final route = MaterialPageRoute(
                    builder: (context) => ClasificationPage());
                Navigator.push(context, route);
              },
            )),
        backgroundColor: const Color.fromARGB(255, 255, 155, 147),
        actions: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 40,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.list,
                size: 40,
                color: Color.fromARGB(255, 157, 13, 13),
              ),
              onPressed: () {
                final route =
                    MaterialPageRoute(builder: (context) => SearchPlayers());
                Navigator.push(context, route);
              },
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color.fromARGB(255, 255, 244, 244),
            Color.fromARGB(0, 255, 70, 70)
          ], begin: Alignment.topCenter),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 200.0, vertical: 100),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final route =
                          MaterialPageRoute(builder: (context) => GamePage());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Partida rápida',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                          builder: (context) => const CreatePage());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Crear partida privada',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black54),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      final route = MaterialPageRoute(
                          builder: (context) => const Partida());
                      Navigator.push(context, route);
                    },
                    child: const Text(
                      'Unirse a partida privada',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
