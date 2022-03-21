import 'package:flutter/material.dart';


class MyCard extends StatelessWidget {
  const MyCard({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          height: 150,
          width: 100,
          child: Image.asset('images/uno.jpg'),
        ),
      )
    );
  }
}


