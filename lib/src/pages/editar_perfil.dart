import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';

class EditPage extends StatefulWidget {
  EditPage({Key? key}) : super(key: key);

  State<EditPage> createState() => _editState();
}

class _editState extends State<EditPage> {
  final List<String> items = [
    'España',
    'Francia',
    'Alemania',
    'Rumanía',
    'Bélgica',
    'Irlanda'
  ];
  String _newName = '';
  late String _newCountry;

  @override
  void initState() {
    _newCountry = items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/fondo2.jpg'), fit: BoxFit.cover)),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                    child: Column(
                  children: [
                    InputText(
                      hint: 'usuario123',
                      label: 'Nombre de usuario',
                      keyboard: TextInputType.emailAddress,
                      icono: const Icon(Icons.verified_user),
                      onChanged: (data) {
                        _newName = data;
                      },
                      validator: (data) {
                        if (data!.trim().isEmpty) {
                          return "Usuario inválido";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                                color: Color.fromARGB(255, 96, 95, 95),
                                width: 1,
                                style: BorderStyle.solid)),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              DropdownButton(
                                isExpanded: true,
                                style: Theme.of(context).textTheme.headline6,
                                value: _newCountry,
                                items: items
                                    .map<DropdownMenuItem<String>>(
                                        (String item) =>
                                            DropdownMenuItem<String>(
                                              value: item,
                                              child: Center(child: Text(item)),
                                            ))
                                    .toList(),
                                onChanged: (String? value) =>
                                    setState(() => _newCountry = value!),
                              ),
                            ])),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: 100,
                      height: 45.0,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Color.fromARGB(255, 196, 33, 22)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          
                        },
                        child: const Text(
                          'Guardar',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'FredokaOne',
                              fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {},
                          child: const Text(
                            'Eliminar cuenta',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.teal, fontFamily: 'FredokaOne'),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
