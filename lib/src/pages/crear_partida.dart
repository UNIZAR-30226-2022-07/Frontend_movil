import 'package:flutter/material.dart';

int count = 2;
bool tiempoA10 = false;

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  bool regla1 = false;
  bool regla2 = false;
  bool regla3 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear partida',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              Color.fromARGB(255, 255, 244, 244),
              Color.fromARGB(0, 255, 70, 70)
            ], begin: Alignment.topCenter),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Número de Personas',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IntrinsicHeight(
                            child: Row(children: [
                              IconButton(
                                onPressed: () {
                                  if (count > 2) setState(() => count--);
                                },
                                icon: const Icon(
                                  Icons.exposure_minus_1,
                                  color: Colors.white,
                                ),
                                iconSize: 30,
                              ),
                              const VerticalDivider(
                                thickness: 4,
                                color: Colors.white24,
                              ),
                              IconButton(
                                onPressed: () {
                                  if (count < 6) {
                                    setState(() => count++);
                                  }
                                },
                                icon: const Icon(
                                  Icons.exposure_plus_1,
                                  color: Colors.white,
                                ),
                                iconSize: 30,
                              ),
                            ]),
                          ))
                    ],
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tiempo de turno',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:
                                      !tiempoA10 ? Colors.blue : Colors.black38,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    '5s',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  onPressed: () =>
                                      setState(() => tiempoA10 = false),
                                )),
                            Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      tiempoA10 ? Colors.blue : Colors.black38,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextButton(
                                  child: const Text(
                                    '10s',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  onPressed: () =>
                                      setState(() => tiempoA10 = true),
                                ))
                          ],
                        ),
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reglas de la partida',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black26,
                          ),
                          child: Row(
                            children: const [
                              Text(
                                'Reglas',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.arrow_drop_down_outlined,
                                size: 40,
                              )
                            ],
                          ),
                          onPressed: () {
                            popUpReglas(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () => {}, child: const Text('Crear'))
                ],
              )
            ],
          )),
    );
  }

  Future<dynamic> popUpReglas(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text('Popup example'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(children: [
                        const Text("Regla 1"),
                        const SizedBox(
                          width: 5,
                        ),
                        // CheckboxListTile(
                        //   controlAffinity: ListTileControlAffinity.leading,
                        //   title: const Text('Regla 1'),
                        //   value: regla1,
                        //   onChanged: (regla1) =>
                        //       setState(() => this.regla1 = regla1!),
                        // )
                        // Switch.adaptive(
                        //     value: regla1,
                        //     onChanged: (regla1) => setState(() => regla1 = true))
                      ]),
                      Text("Regla 2"),
                      Text("Regla 3"),
                      Text("Regla 4"),
                      Text("Regla 5"),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ))));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: ((context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: const Text('Popup example'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      const Text("Regla 1"),
                      const SizedBox(
                        width: 5,
                      ),
                      Checkbox(
                          value: regla1,
                          onChanged: (regla1) => setState(() => regla1 = true))
                      // Switch.adaptive(
                      //     value: regla1,
                      //     onChanged: (regla1) => setState(() => regla1 = true))
                    ]),
                    Text("Regla 2"),
                    Text("Regla 3"),
                    Text("Regla 4"),
                    Text("Regla 5"),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ))));
}



// Widget _buildPopupDialog(BuildContext context) {
 
//   return AlertDialog(
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//     title: const Text('Popup example'),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Row(children: [
//           const Text("Regla 1"),
//           const SizedBox(
//             width: 5,
//           ),
//           Switch.adaptive(value: regla1, onChanged: (value) => value = !value)
//         ]),
//         Text("Regla 2"),
//         Text("Regla 3"),
//         Text("Regla 4"),
//         Text("Regla 5"),
//       ],
//     ),
//     actions: <Widget>[
//       TextButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         child: const Text('Close'),
//       ),
//     ],
//   );
// }
