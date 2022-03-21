import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/pages/partida.dart';

// import 'search_players.dart';

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
          leading: IconButton(
            icon: Icon(Icons.star),
            // icon: Image.asset('images/uno.jpg'),
            onPressed: () { },
          ),
          backgroundColor: Color.fromARGB(255, 255, 155, 147),
          
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                // final route = MaterialPageRoute(
                // builder: (context) => SearchPlayers());
                // Navigator.push(context, route);
              },
            ),
          ],
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
              horizontal: 200.0,
              vertical: 50
            ),
            children: <Widget>  [
              // Divider(
              //   height: 90,
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(230, 0, 0, 0)),
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
                  Divider(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(230, 0, 0, 0)),
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
                      child: Text('Create private game',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'FredokaOne',
                          fontSize: 30.0
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60.0,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(230, 0, 0, 0)),
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
                      child: Text('Join private game',
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
