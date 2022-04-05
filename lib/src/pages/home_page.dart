import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/clasificacion.dart';
import 'package:flutter_unogame/src/pages/game.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/pages/search_players.dart';
import 'package:flutter_unogame/src/widgets/insertCode_form.dart';
import '../widgets/input_text.dart';
import 'crear_partida.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _code = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.emoji_events,
                size: 40,
                color: Colors.yellow,
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
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
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
                          MaterialPageRoute(builder: (context) => Partida());
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
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
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
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
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
                      popUpCodigo(context);
                      // final route = MaterialPageRoute(
                      //     builder: (context) => const Partida());
                      // Navigator.push(context, route);
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
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
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
                      'Torneos',
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

  Future<dynamic> popUpCodigo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            
            builder: ((context, setState) => AlertDialog(
                  
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                  title: const Text('Introducir código de partida:'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CodeForm(),
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
