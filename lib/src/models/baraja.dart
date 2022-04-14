class Baraja {
  List<String> cartas;

  Baraja({required this.cartas});

  void addCard(String carta) {
    cartas.add(carta);
  }

  void delCard(String carta) {
    cartas.remove(carta);
  }
}
