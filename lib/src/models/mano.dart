import 'package:flutter_unogame/src/models/carta.dart';

class Mano {
  List<Carta> cartas;

  Mano({required this.cartas});

  int length() {
    return cartas.length;
  }

  void add(Carta carta) {
    cartas.add(carta);
  }

  void del(Carta carta) {
    cartas.remove(carta);
  }
}
