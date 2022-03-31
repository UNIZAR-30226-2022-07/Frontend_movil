import 'package:flutter/material.dart';

class Clasification extends StatelessWidget {
  const Clasification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double sizeIcons = 50.0;
    int number = 5;

    const textStyle =
        TextStyle(color: Colors.black, fontFamily: 'Raleway', fontSize: 30.0);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            Container(
              color: const Color.fromARGB(255, 255, 155, 147),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      width: width / 3 - 12,
                      color: Colors.black12,
                      child: IconButton(
                        iconSize: sizeIcons,
                        color: Colors.white,
                        icon: const Icon(Icons.people_alt),
                        onPressed: () {},
                      ),
                    ),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 3,
                    ),
                    Container(
                        width: width / 3 - 12,
                        color: Colors.black12,
                        child: IconButton(
                          iconSize: sizeIcons,
                          color: Colors.white,
                          icon: const Icon(Icons.flag_rounded),
                          onPressed: () {},
                        )),
                    const VerticalDivider(
                      color: Colors.white,
                      thickness: 3,
                      width: 20.0,
                    ),
                    Container(
                        width: width / 3 - 12,
                        color: Colors.black12,
                        child: IconButton(
                          iconSize: sizeIcons,
                          color: Colors.white,
                          icon: const Icon(Icons.public),
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
            ),
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
