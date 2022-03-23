import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/utils/players.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final controller = TextEditingController();
  List<Player> players = allPlayers;

  void searchBar(String query) {
    final suggestions = allPlayers.where((player) {
      final playerName = player.name.toLowerCase();
      final input = query.toLowerCase();

      return playerName.contains(input);
    }).toList();

    setState(() => players = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title: const Text('Search'),
        backgroundColor: Color.fromARGB(255, 255, 155, 147),
      ),
      backgroundColor: Color.fromARGB(255, 255, 155, 147),
      body: Column( 


        children: <Widget> [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Player name',
                fillColor: Colors.red,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 255, 71, 71)),
                )
              ),
              onChanged: searchBar,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];

                return ListTile(
                  leading: Image.network(
                    player.image,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(player.name),
                  // onTap: //=> Navigator.push(
                  // //   context,
                  // //   MaterialPageRoute(
                  //     // builder: (context) => PlayerPage(player : player),
                  //   ),
                  // ),
                );
              },
            )
          ),
        ],
      )
    );
  }
}