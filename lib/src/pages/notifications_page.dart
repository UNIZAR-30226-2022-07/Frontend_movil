import 'package:flutter/material.dart';

import '../models/notificacion.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _notificationsState();
}

dynamic a = Notificacion(
    title: 'Julián te ha enviado una solicitud de amistad',
    body: '¿Deseas agregar a Julián como amigo?aaaaaaaaaaaaaaaaaaaaaaaaa');

class _notificationsState extends State<Notifications> {
  List<Notificacion> notificaciones = [
    Notificacion(
        title: 'Julián te ha enviado una solicitud de amistad',
        accion: 'amistad',
        body:
            '¿Deseas agregar a Julián como amigo?aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
    a,
    a,
    a,
    a,
    a,
    a,
    a
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Notificaciones',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
          child: ListView.builder(
            itemCount: notificaciones.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                child: GestureDetector(
                  onTap: () {
                    print('Pulsado');
                    if (notificaciones[index].accion == 'amistad') {
                      popUpAmistad(context, index).then((_) => setState(() {}));
                    } else if (notificaciones[index].accion == 'partida') {
                      popUpPartida(context, index);
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                notificaciones[index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                notificaciones[index].body,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 4,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    ),
                  ),
                ),
                onDismissed: (direccion) {
                  notificaciones.removeAt(index);
                  print(direccion);
                  setState(() {});
                },
              );
            },
          ),
        ));
  }

  Future<dynamic> popUpAmistad(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    '¿Aceptar la solicitud?',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                            onPressed: () {
                              //Enviar a Backend: Aceptar solicitud
                              notificaciones.removeAt(index);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                            onPressed: () {
                              //Enviar a Backend: denegar solicitud
                              notificaciones.removeAt(index);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ))));
  }

  Future<dynamic> popUpPartida(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    '¿Quieres unirte a la partida?',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                            onPressed: () {
                              //Enviar a Backend: Aceptar solicitud
                              notificaciones.removeAt(index);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.check,
                              color: Colors.white,
                            )),
                      ),
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                            onPressed: () {
                              //Enviar a Backend: denegar solicitud
                              notificaciones.removeAt(index);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            )),
                      )
                    ],
                  ),
                ))));
  }
}
