import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/partida.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft]
    );
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.star),
          title: Text(''),
          actions: [
            Icon(Icons.list),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 65),
              child: Icon(Icons.notifications),
            ),
            // Icon(Icons.more_vert),
          ],
          backgroundColor: Color.fromARGB(255, 255, 68, 68),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 255, 244, 244),
                Color.fromARGB(0, 255, 70, 70)
              ],
              begin: Alignment.topCenter
            ),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 200
            ),
            children: <Widget>  [
              
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xE6CC0E08)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      onPressed: (){
                        final route = MaterialPageRoute(
                          builder: (context) => Partida());
                        Navigator.push(context, route);
                      },
                      child: Text('Quick Game',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
