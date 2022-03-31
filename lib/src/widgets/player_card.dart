import 'package:flutter/material.dart';

class PlayerCard extends StatelessWidget {
  final String userName;
  final String rating;
  final String trophies;
  final bool ownUser;
  PlayerCard(
      {required this.userName,
      required this.trophies,
      required this.rating,
      required this.ownUser});
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: ownUser ? Colors.blue : const Color.fromARGB(255, 255, 155, 147),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 25,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    rating,
                    style: textStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                userName,
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(
                    trophies,
                    style: textStyle,
                  ),
                  const SizedBox(width: 7),
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.yellow,
                    size: 25,
                  ),
                ],
              ),
            )
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
