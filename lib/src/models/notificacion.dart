class Notificacion {
  String person;
  String body;
  String? accion;
  String? idPartida;

  Notificacion(
      {required this.person, required this.body, this.accion, this.idPartida});
}
