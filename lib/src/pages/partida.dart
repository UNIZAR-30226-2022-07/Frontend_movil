import 'package:flutter/material.dart';

import '../widgets/card.dart';
import '../widgets/icon_container.dart';

class Partida extends StatefulWidget {
  const Partida({ Key? key }) : super(key: key);

  @override
  State<Partida> createState() => _PartidaState();
}

class _PartidaState extends State<Partida> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Divider(
                    height: 25,
                  ),
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
        );
  }
}





























//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 19, 107, 22),
//       body: Center(
//         child: Container(
//           child: Stack(
//             clipBehavior: Clip.none,
//             alignment: AlignmentDirectional.bottomStart,
//             children: const [
//               MyCard(),
//               Positioned(
//                 left: 50,
//                 bottom: 0,
//                 child: MyCard(),
//               ),
//               Positioned(
//                 left: 100,
//                 bottom: 0,
//                 child: MyCard(),
//               ),
//               Positioned(
//                 left: 150,
//                 bottom: 0,
//                 child: MyCard(),
//               ),
//             ],
//           )
//         ),
//       ),
//     );
//   }
// }