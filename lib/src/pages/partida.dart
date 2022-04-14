import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/widgets/rival_card.dart';

class Partida extends StatefulWidget {
  const Partida({Key? key}) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

List<String> veggies = ['Broccoli', 'Carrot', 'Cucumber'];

class _PartidaState extends State<Partida> {
  @override
  Widget rivalsCards(int nRivals) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        // padding: const EdgeInsets.all(80),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Column(
              children: [
                RivalCard(userName: 'Player 1', cards: 5),
              ],
            ),
          ],
        ),
        // child: ListView.builder(
        //   itemCount: nRivals,
        //   itemBuilder: (BuildContext context, int index) {
        //     return const Card(
        //       elevation: 5,
        //       child: ListTile(
        //         title: Text('Jugador'),
        //       ),
        //     );
        //   },
        // ),
      );

  @override
  Widget buildCard(String carta) => GestureDetector(
      onTap: () {
        print("Container buildCard clicked");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(carta), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Center(child: Text('$index')),
      ));

  @override
  Widget cartaRobar(int index) => GestureDetector(
      onTap: () {
        print("Container cartaRobar clicked");
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 10),
        width: 70,
        height: 120,
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage('images/uno.jpg'), fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(15),
        ),
        // child: Center(child: Text('$index')),
      ));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 6, 104, 16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                rivalsCards(5),
                Column(children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildCard('images/azul.jpg'),
                      const SizedBox(
                        width: 20,
                      ),
                      cartaRobar(20),
                      const SizedBox(
                        width: 80,
                      )
                    ],
                  ),
                ]),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 0, 0, 2),
              child: Column(
                children: <Widget>[
                  Row(children: [
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                    buildCard('images/azul.jpg'),
                    const SizedBox(width: 12),
                  ])
                ],
              ),
            )
          ],
        ));
  }
}
