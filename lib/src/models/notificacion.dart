class Notificacion {
  String person;
  String body;
  String? accion;

  Notificacion({required this.person, required this.body, this.accion});

  factory Notificacion.fromJson(dynamic json) {
    return Notificacion(
        person: json['name'] as String, body: 'Quiere ser tu amigo');
  }

  static List<Notificacion> NotificacionesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Notificacion.fromJson(data);
    }).toList();
  }
}
