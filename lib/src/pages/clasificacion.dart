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
          body: const TabBarView(
              children: [FriendsPage(), NationalPage(), WorldPage()])));
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
