import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final String url;
  const IconContainer({Key? key, required this.url }) 
          : assert(url != null),
          super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.0,
      height: 200.0,
      child: CircleAvatar(
        radius: 70.0,
        backgroundColor: Color.fromARGB(0, 189, 17, 17),
        backgroundImage: AssetImage(this.url),
      ),
    );
  }
}  