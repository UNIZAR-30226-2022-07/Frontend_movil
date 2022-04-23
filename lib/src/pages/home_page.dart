import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/clasificacion.dart';
import 'package:flutter_unogame/src/pages/partida.dart';
import 'package:flutter_unogame/src/pages/search_players.dart';
import 'crear_partida.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController controller;

  GlobalKey<FormState> _formKey = GlobalKey();
  String code = '';
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
            // gradient: LinearGradient(colors: <Color>[
            //   Color.fromARGB(255, 255, 244, 244),
            //   Color.fromARGB(0, 255, 70, 70)
            // ], begin: Alignment.topCenter),
            image: DecorationImage(
                image: AssetImage('images/fondo.png'), fit: BoxFit.fill)),
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
                      final route = MaterialPageRoute(
                          builder: (context) => const Partida());
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
                    onPressed: () async {
                      final code = await openDialog();
                      if (code == null || code.isEmpty) return;

                      setState(() => this.code = code);
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

  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Inserta el codigo de partida:'),
            content: TextField(
              autofocus: true,
              // decoration: InputDecoration(hintText: 'Enter code'),
              controller: controller, // para acceder al codigo que introducimos
              onSubmitted: (_) => submit(),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    submit();
                  },
                  child: Text('Submit')),
            ],
          ));

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
