import 'package:flutter/material.dart';

int count = 2;
bool tiempoA10 = false;

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 200.0, vertical: 100),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Número de Personas',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      Text(
                        '$count',
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.all(10),
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
                                iconSize: 35,
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
                                iconSize: 35,
                              ),
                            ]),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'Tiempo de turno',
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 125,
                    ),
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: !tiempoA10 ? Colors.blue : Colors.black38,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          child: const Text(
                            '5s',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () => setState(() => tiempoA10 = false),
                        )),
                    Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: tiempoA10 ? Colors.blue : Colors.black38,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextButton(
                          child: const Text(
                            '10s',
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                          onPressed: () => setState(() => tiempoA10 = true),
                        ))
                  ]),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Reglas de la partida',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 125,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black26,
                        ),
                        child: Row(
                          children: const [
                            Text(
                              'Reglas',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        },
                      )
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}

Widget _buildPopupDialog(BuildContext context) {
  return AlertDialog(
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
          ElevatedButton(
              onPressed: () {},
              child: const Text(
                ".",
                style: TextStyle(color: Colors.transparent, fontSize: 5),
              ))
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
  );
}
