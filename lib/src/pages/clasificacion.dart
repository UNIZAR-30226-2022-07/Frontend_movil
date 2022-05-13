import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:flutter_unogame/src/widgets/player_card.dart';

import '../models/players_api.dart';

class ClasificationPage extends StatefulWidget {
  @override
  _ClasificationPageState createState() => _ClasificationPageState();
}

class _ClasificationPageState extends State<ClasificationPage> {
  // late List<Player> _players;
  // bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   getPlayers();
  // }

  // Future<void> getPlayers() async {
  //   _players = await PlayerApi.getRecipe();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

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
          body: TabBarView(children: [
            FriendsPage('usuario123'),
            NationalPage('espagna'),
            WorldPage()
          ])));
  // body: _isLoading
  //   ? const Center(child: CircularProgressIndicator())
  //   : ListView.builder(
  //       itemCount: _players.length,
  //       itemBuilder: (context, index) {
  //         return PlayerCard(
  //             userName: 'juliferre09',
  //             rating: '3º',
  //             trophies: '400',
  //             ownUser: true);
  //       },
  //     ));
}

Future<List<Player>> getPlayers(String tipo, String aux) async {
  List<Player> l = [];
  if (tipo == 'rankingAmigos') {
    List<Player> l = await PlayerApi.getPlayers(aux);
    return l;
  } else if (tipo == 'rankingPais') {
    List<Player> l = await PlayerApi.getPlayersPais(aux);
    return l;
  } else {
    List<Player> l = await PlayerApi.getPlayersWorld();
    return l;
  }
}

Widget FriendsPage(String usuario) {
  return FutureBuilder(
      future: getPlayers('rankingAmigos', usuario),
      builder: (context, projectSnap) {
        //List<Player>? data = projectSnap.data;
        List<Player>? data = projectSnap.data as List<Player>?;
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return Scaffold(
            body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: (data == null) ? 1 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!projectSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return PlayerCard(
                          userName: data![index].userName,
                          trophies: data[index].trophies.toString(),
                          rating: data[index].rating.toString(),
                          ownUser: false);
                    }))
          ],
        ));
      });
}

Widget NationalPage(String pais) {
  return FutureBuilder(
      future: getPlayers('rankingNacional', pais),
      builder: (context, projectSnap) {
        //List<Player>? data = projectSnap.data;
        List<Player>? data = projectSnap.data as List<Player>?;
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return Scaffold(
            body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: (data == null) ? 1 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!projectSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return PlayerCard(
                          userName: data![index].userName,
                          trophies: data[index].trophies.toString(),
                          rating: data[index].rating.toString(),
                          ownUser: data[index].userName == 'usuario123');
                    }))
          ],
        ));
      });
}

Widget WorldPage() {
  return FutureBuilder(
      future: getPlayers('rankingMundial', ''),
      builder: (context, projectSnap) {
        //List<Player>? data = projectSnap.data;
        List<Player>? data = projectSnap.data as List<Player>?;
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container();
        }
        return Scaffold(
            body: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: (data == null) ? 1 : data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!projectSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return PlayerCard(
                          userName: data![index].userName,
                          trophies: data[index].trophies.toString(),
                          rating: data[index].rating.toString(),
                          ownUser: data[index].userName == 'usuario123');
                    }))
          ],
        ));
      });
}

// class FriendsPage extends StatelessWidget {
//   const FriendsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         const SizedBox(
//           height: 5,
//         ),
//         PlayerCard(
//           userName: 'juliferre09',
//           rating: '3º',
//           trophies: '400',
//           ownUser: true,
//         ),
//         PlayerCard(
//           userName: 'paulaEzpe',
//           rating: '1º',
//           trophies: '450',
//           ownUser: false,
//         ),
//       ],
//     ));
//   }
// }

// class NationalPage extends StatelessWidget {
//   const NationalPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         const SizedBox(
//           height: 5,
//         ),
//         PlayerCard(
//           userName: 'juliferre09-nacional',
//           rating: '3º',
//           trophies: '400',
//           ownUser: true,
//         ),
//         PlayerCard(
//           userName: 'paulaEzpe',
//           rating: '1º',
//           trophies: '450',
//           ownUser: false,
//         ),
//       ],
//     ));
//   }
// }

// class WorldPage extends StatelessWidget {
//   const WorldPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         const SizedBox(
//           height: 5,
//         ),
//         PlayerCard(
//           userName: 'juliferre09-mundial',
//           rating: '3º',
//           trophies: '400',
//           ownUser: true,
//         ),
//         PlayerCard(
//           userName: 'paulaEzpe',
//           rating: '1º',
//           trophies: '450',
//           ownUser: false,
//         ),
//       ],
//     ));
//   }
// }
