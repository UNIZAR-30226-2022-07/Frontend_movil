import 'package:flutter/material.dart';

class Clasification extends StatelessWidget {
  const Clasification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double sizeIcons = 50.0;
    int number = 5;
    const textStyle =
        TextStyle(color: Colors.black, fontFamily: 'Raleway', fontSize: 30.0);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 255, 155, 147),
            //toolbarHeight: 0,
            titleSpacing: 1.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                IconButton(
                  iconSize: sizeIcons,
                  icon: const Icon(Icons.people_alt),
                  onPressed: () {},
                ),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 10,
                ),
                IconButton(
                  iconSize: sizeIcons,
                  icon: const Icon(Icons.flag_rounded),
                  onPressed: () {},
                ),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 10,
                  width: 20.0,
                ),
                IconButton(
                  iconSize: sizeIcons,
                  icon: const Icon(Icons.public),
                  onPressed: () {},
                ),
              ],
            )),
      ),
      body: ListView(
        children: [
          //El primero va a ser el usuario en cuestión
          Card(
            child: ListTile(
              tileColor: const Color.fromARGB(255, 97, 184, 255),
              leading: Text(
                '$number',
                style: textStyle,
              ),
              title: const Text(
                'Tú',
                style: textStyle,
              ),
              trailing: const Icon(Icons.emoji_events, size: 40),
            ),
          )
        ],
      ),
    );
  }
}

// List<Widget> getListado(String type) {
//   switch (type) {
//     case 'amigos': //Solicitar en cuestión del tipo
//       break;
//     case 'nacional':
//       break;
//     case 'mundial':
//       break;
//   }
//   //Al salir del switch, ya tiene la lista JSON con los jugadores
//   Habrá que reecorrer los datos en cuestión e ir generando una lista de 
//   Cards con los ListTile de cada jugador
//   return null;
// }
