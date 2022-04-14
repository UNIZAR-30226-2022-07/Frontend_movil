import 'package:flutter/material.dart';

class RivalCard extends StatelessWidget {
  final String userName;
  final int cards;
  RivalCard({
    required this.userName,
    required this.cards,
  });
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
      width: 100,
      height: 25,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                '$cards',
                style: textStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
