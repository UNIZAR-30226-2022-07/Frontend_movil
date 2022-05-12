import 'dart:convert';

class Carta {
  String color;
  String numero;
  String url;
  String? especialidad;
  Carta({required this.color, required this.numero, required this.url}) {
    if (numero == 'MAS_CUATRO') {
      especialidad = 'draw4';
    } else if (numero == 'UNDEFINED') {
      especialidad = 'wild';
    }
  }

  static String getURL(String num, String color) {
    String rtdo = 'images/cartas/';
    switch (color) {
      case 'ROJO':
        rtdo += 'rojo-';
        break;
      case 'AZUL':
        rtdo += 'azul-';
        break;
      case 'AMARILLO':
        rtdo += 'amarillo-';
        break;
      case 'VERDE':
        rtdo += 'verde-';
        break;
      // case 'CAMBIO_COLOR':
      //   break;
      // default:
    }
    switch (num) {
      case 'CERO':
        rtdo += '0.png';
        break;
      case 'UNO':
        rtdo += '1.png';
        break;
      case 'DOS':
        rtdo += '2.png';
        break;
      case 'TRES':
        rtdo += '3.png';
        break;
      case 'CUATRO':
        rtdo += '4.png';
        break;
      case 'CINCO':
        rtdo += '5.png';
        break;
      case 'SEIS':
        rtdo += '6.png';
        break;
      case 'SIETE':
        rtdo += '7.png';
        break;
      case 'OCHO':
        rtdo += '8.png';
        break;
      case 'NUEVE':
        rtdo += '9.png';
        break;
      case 'BLOQUEO':
        rtdo += 'block.png';
        break;
      case 'MAS_DOS':
        rtdo += 'draw2.png';
        break;
      case 'CAMBIO_SENTIDO':
        rtdo += 'reverse.png';
        break;
      case 'UNDEFINED':
        rtdo += 'wild.png';
        break;
      case 'MAS_CUATRO':
        rtdo += 'draw4.png';
        break;
      default:
    }
    return rtdo;
  }

  String buildMessage() {
    Map<String, String> rtdo = {'numero': numero, 'color': color};
    String mensaje = jsonEncode(rtdo);
    return mensaje;
  }

  static List<Carta> getCartas(List<dynamic> mensaje) {
    List<Carta> rtdo = [];
    for (dynamic i in mensaje) {
      if (i != null) {
        print(Carta.getURL(i['numero'], i['color']));
        rtdo.add(Carta(
            color: i['color'],
            numero: i['numero'],
            url: Carta.getURL(i['numero'], i['color'])));
      }
    }
    return rtdo;
  }
}
