import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/player_card.dart';

class ClasificationPage extends StatefulWidget {
  @override
  _ClasificationPageState createState() => _ClasificationPageState();
}

class _ClasificationPageState extends State<ClasificationPage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Rankings',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom: const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    icon: Icon(Icons.people_alt),
                    text: 'Amigos',
                  ),
                  Tab(
                    icon: Icon(Icons.flag_rounded),
                    text: 'Nacional',
                  ),
                  Tab(
                    icon: Icon(Icons.public),
                    text: 'Mundial',
                  )
                ]),
          ),
          body: const TabBarView(
              children: [FriendsPage(), NationalPage(), WorldPage()])));
}

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        PlayerCard(
          userName: 'juliferre09',
          rating: '3º',
          trophies: '400',
          ownUser: true,
        ),
        PlayerCard(
          userName: 'paulaEzpe',
          rating: '1º',
          trophies: '450',
          ownUser: false,
        ),
      ],
    ));
  }
}

class NationalPage extends StatelessWidget {
  const NationalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        PlayerCard(
          userName: 'juliferre09-nacional',
          rating: '3º',
          trophies: '400',
          ownUser: true,
        ),
        PlayerCard(
          userName: 'paulaEzpe',
          rating: '1º',
          trophies: '450',
          ownUser: false,
        ),
      ],
    ));
  }
}

class WorldPage extends StatelessWidget {
  const WorldPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        PlayerCard(
          userName: 'juliferre09-mundial',
          rating: '3º',
          trophies: '400',
          ownUser: true,
        ),
        PlayerCard(
          userName: 'paulaEzpe',
          rating: '1º',
          trophies: '450',
          ownUser: false,
        ),
      ],
    ));
  }
}

// class ClasificationBar extends State<ClasificationPage> {
//   @override
//   Widget build(BuildContext context) {
//     const double sizeIcons = 50.0;

//     double width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         child: ListView(
//           children: [
//             Container(
//               color: const Color.fromARGB(255, 255, 155, 147),
//               child: IntrinsicHeight(
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   //crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     Container(
//                       width: width / 3 - 12,
//                       color: Colors.black12,
//                       child: IconButton(
//                         iconSize: sizeIcons,
//                         color: Colors.white,
//                         icon: const Icon(Icons.people_alt),
//                         onPressed: () {},
//                       ),
//                     ),
//                     const VerticalDivider(
//                       color: Colors.white,
//                       thickness: 3,
//                     ),
//                     Container(
//                         width: width / 3 - 12,
//                         color: Colors.black12,
//                         child: IconButton(
//                           iconSize: sizeIcons,
//                           color: Colors.white,
//                           icon: const Icon(Icons.flag_rounded),
//                           onPressed: () {},
//                         )),
//                     const VerticalDivider(
//                       color: Colors.white,
//                       thickness: 3,
//                       width: 20.0,
//                     ),
//                     Container(
//                         width: width / 3 - 12,
//                         color: Colors.black12,
//                         child: IconButton(
//                           iconSize: sizeIcons,
//                           color: Colors.white,
//                           icon: const Icon(Icons.public),
//                           onPressed: () {},
//                         )),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
