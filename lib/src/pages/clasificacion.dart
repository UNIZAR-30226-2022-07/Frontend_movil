import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/models/player.dart';
import 'package:flutter_unogame/src/widgets/player_card.dart';

import '../models/players_api.dart';

class ClasificationPage extends StatefulWidget {
  String userName;
  String pais;
  ClasificationPage({Key? key, required this.userName, required this.pais})
      : super(key: key);

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
          body: TabBarView(children: [
            FriendsPage(widget.userName),
            NationalPage(widget.userName, widget.pais),
            WorldPage(widget.userName)
          ])));
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

Widget NationalPage(String userName, String pais) {
  return FutureBuilder(
      future: getPlayers('rankingPais', pais),
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
                          ownUser: data[index].userName == userName);
                    }))
          ],
        ));
      });
}

Widget WorldPage(String userName) {
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
                          ownUser: data[index].userName == userName);
                    }))
          ],
        ));
      });
}
