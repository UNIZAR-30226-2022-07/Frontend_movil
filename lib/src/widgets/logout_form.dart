import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter_unogame/src/pages/activar_cuenta.dart';
import 'package:flutter_unogame/src/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_unogame/src/widgets/input_text.dart';



class LogoutForm extends StatefulWidget {
  const LogoutForm({Key? key}) : super(key: key);

  @override
  _LogoutFormState createState() => _LogoutFormState();
}

bool _valido = false;
class ColorItem {
  ColorItem(this.name, this.color);  final String name;
  final Color color;
}

class _LogoutFormState extends State<LogoutForm> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _name = '';
  String _email = '';
  String _password = '';
  String _passwordR = '';
  final List<String> items = ["Afganistán",
    "Albania",
    "Alemania",
    "Andorra",
    "Angola",
    "Anguila",
    "Antártida",
    "Antigua y Barbuda",
    "Arabia Saudita",
    "Argelia",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaiyán",
    "Bélgica",
    "Bahamas",
    "Bahrein",
    "Bangladesh",
    "Barbados",
    "Belice",
    "Benín",
    "Bhután",
    "Bielorrusia",
    "Birmania",
    "Bolivia",
    "Bosnia y Herzegovina",
    "Botsuana",
    "Brasil",
    "Brunéi",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Camboya",
    "Camerún",
    "Canadá",
    "Chad",
    "Chile",
    "China",
    "Chipre",
    "Ciudad del Vaticano",
    "Colombia",
    "Comoras",
    "República del Congo",
    "República Democrática del Congo",
    "Corea del Norte",
    "Corea del Sur",
    "Costa de Marfil",
    "Costa Rica",
    "Croacia",
    "Cuba",
    "Curazao",
    "Dinamarca",
    "Dominica",
    "Ecuador",
    "Egipto",
    "El Salvador",
    "Emiratos Árabes Unidos",
    "Eritrea",
    "Eslovaquia",
    "Eslovenia",
    "España",
    "Estados Unidos de América",
    "Estonia",
    "Etiopía",
    "Filipinas",
    "Finlandia",
    "Fiyi",
    "Francia",
    "Gabón",
    "Gambia",
    "Georgia",
    "Ghana",
    "Gibraltar",
    "Granada",
    "Grecia",
    "Groenlandia",
    "Guadalupe",
    "Guam",
    "Guatemala",
    "Guayana Francesa",
    "Guernsey",
    "Guinea",
    "Guinea Ecuatorial",
    "Guinea-Bissau",
    "Guyana",
    "Haití",
    "Honduras",
    "Hong kong",
    "Hungría",
    "India",
    "Indonesia",
    "Irán",
    "Irak",
    "Irlanda",
    "Isla Bouvet",
    "Isla de Man",
    "Isla de Navidad",
    "Isla Norfolk",
    "Islandia",
    "Islas Bermudas",
    "Islas Caimán",
    "Islas Cocos (Keeling)",
    "Islas Cook",
    "Islas de Åland",
    "Islas Feroe",
    "Islas Georgias del Sur y Sandwich del Sur",
    "Islas Heard y McDonald",
    "Islas Maldivas",
    "Islas Malvinas",
    "Islas Marianas del Norte",
    "Islas Marshall",
    "Islas Pitcairn",
    "Islas Salomón",
    "Islas Turcas y Caicos",
    "Islas Ultramarinas Menores de Estados Unidos",
    "Islas Vírgenes Británicas",
    "Islas Vírgenes de los Estados Unidos",
    "Israel",
    "Italia",
    "Jamaica",
    "Japón",
    "Jersey",
    "Jordania",
    "Kazajistán",
    "Kenia",
    "Kirguistán",
    "Kiribati",
    "Kuwait",
    "Líbano",
    "Laos",
    "Lesoto",
    "Letonia",
    "Liberia",
    "Libia",
    "Liechtenstein",
    "Lituania",
    "Luxemburgo",
    "México",
    "Mónaco",
    "Macao",
    "Macedônia",
    "Madagascar",
    "Malasia",
    "Malawi",
    "Mali",
    "Malta",
    "Marruecos",
    "Martinica",
    "Mauricio",
    "Mauritania",
    "Mayotte",
    "Micronesia",
    "Moldavia",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Mozambique",
    "Namibia",
    "Nauru",
    "Nepal",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Noruega",
    "Nueva Caledonia",
    "Nueva Zelanda",
    "Omán",
    "Países Bajos",
    "Pakistán",
    "Palau",
    "Palestina",
    "Panamá",
    "Papúa Nueva Guinea",
    "Paraguay",
    "Perú",
    "Polinesia Francesa",
    "Polonia",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reino Unido",
    "República Centroafricana",
    "República Checa",
    "República Dominicana",
    "República de Sudán del Sur",
    "Reunión",
    "Ruanda",
    "Rumanía",
    "Rusia",
    "Sahara Occidental",
    "Samoa",
    "Samoa Americana",
    "San Bartolomé",
    "San Cristóbal y Nieves",
    "San Marino",
    "San Martín (Francia)",
    "San Pedro y Miquelón",
    "San Vicente y las Granadinas",
    "Santa Elena",
    "Santa Lucía",
    "Santo Tomé y Príncipe",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leona",
    "Singapur",
    "Sint Maarten",
    "Siria",
    "Somalia",
    "Sri lanka",
    "Sudáfrica",
    "Sudán",
    "Suecia",
    "Suiza",
    "Surinám",
    "Svalbard y Jan Mayen",
    "Swazilandia",
    "Tayikistán",
    "Tailandia",
    "Taiwán",
    "Tanzania",
    "Territorio Británico del Océano Índico",
    "Territorios Australes y Antárticas Franceses",
    "Timor Oriental",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad y Tobago",
    "Tunez",
    "Turkmenistán",
    "Turquía",
    "Tuvalu",
    "Ucrania",
    "Uganda",
    "Uruguay",
    "Uzbekistán",
    "Vanuatu",
    "Venezuela",
    "Vietnam",
    "Wallis y Futuna",
    "Yemen",
    "Yibuti",
    "Zambia",
    "Zimbabue",];  
  late String _country;
  

  @override
  void initState() {
    _country = items[0];
    super.initState();
  }
  Widget build(BuildContext context) {
    var value2;
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            InputText(
              hint: 'Nombre de usuario',
              label: 'Nombre de usuario',
              keyboard: TextInputType.name,
              icono: const Icon(Icons.supervised_user_circle),
              onChanged: (data) {
                _name = data;
              },
              validator: (data) {
                if (data!.trim().isEmpty) {
                  return "Nombre de usuario incorrecto";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            InputText(
              hint: 'Email',
              label: 'Email',
              keyboard: TextInputType.emailAddress,
              icono: const Icon(Icons.verified_user),
              onChanged: (data) {
                _email = (data);
              },
              validator: (data) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(data ?? '') ? null : 'Correo inválido';
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            InputText(
              hint: 'Contraseña',
              label: 'Contraseña',
              obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _password = (data);
              },
              validator: (data) {
                if (data!.trim().isEmpty || data.length < 6) {
                  return "Contraseña inválida";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            InputText(
              hint: 'Repetir contraseña',
              label: 'Repetir contraseña',
              obsecure: true,
              icono: const Icon(Icons.lock_outline),
              onChanged: (data) {
                _passwordR = (data);
              },
              validator: (data) {
                if (data! != _password) {
                  return "Contraseña inválida";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),       
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                      color: Color.fromARGB(255, 96, 95, 95),
                      width: 1,
                      style: BorderStyle.solid
                  )
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DropdownButton(
                    isExpanded: true,
                    style: Theme.of(context).textTheme.headline6,
                    value: _country,
                    items: items.map<DropdownMenuItem<String>>(
                            (String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Center(child: Text(item)),
                                ))
                        .toList(),
                    onChanged: (String? value) =>
                        setState(() => _country = value!),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ), 
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xE6CC0E08)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _valido = false;
                    RegistrationUser();
                    if (!_valido) {}
                  }
                },
                child: const Text(
                  'Regístrate',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'FredokaOne',
                      fontSize: 25.0),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '¿Ya tienes cuenta?',
                  style: const TextStyle(fontFamily: 'FredokaOne'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'sign_in');
                  },
                  child: const Text(
                    '¡Inicia sesión!',
                    style:
                        TextStyle(color: Colors.teal, fontFamily: 'FredokaOne'),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: <Widget>[
            //     FloatingActionButton(
            //       backgroundColor: Colors.red[900],
            //       child: const Icon(Icons.settings_backup_restore),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //     ),
            //   ],
            // )
          ],
        ));
  }

//   Future RegistrationUser() async {
//     Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signup');

//     final client = HttpClient();
//     final request = await client.postUrl(url);
//     request.headers
//         .set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
//     request.write(
//         '{"username": "Hello2", "email": "hola@gmail.com", "pais": "espama", "password": "haaaaaaaaaaaaola"}');
//     print(request);
//     final response = await request.close();
//     response.transform(utf8.decoder).listen((contents) {
//       print(contents);
//     });
//     return response;
//   }
// }

  Future<dynamic> popUpError(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const Text(
                    'Nombre de usuario no disponible',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                ))));
  }
  
  
  Future RegistrationUser() async {
    Uri url = Uri.parse('https://onep1.herokuapp.com/api/auth/signup');
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
    };
    Map<String, String> mapeddate = {
      'username': _name,
      'email': _email,
      'pais': _country,
      'password': _password
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(mapeddate));

    if (response.statusCode == 200) {
      _valido = true;
      final route = MaterialPageRoute(
          builder: (context) => ActivateAccount());
      Navigator.push(context, route);
    } else {
      popUpError(context);
      _valido = false;
      var respuesta = json.decode(response.body);
      print(respuesta['message']);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(respuesta['message']),
      //   backgroundColor: Colors.red,
      //   width: 30,
      // ));
    }
  }
}
