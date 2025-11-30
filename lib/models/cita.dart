class Cita {
  int? id;
  String cliente;
  String servicio;
  String? nota;
  String hora;
  DateTime fecha;

  Cita({
    this.id,
    required this.cliente,
    required this.servicio,
    this.nota,
    required this.hora,
    required this.fecha,
  });

  Map<String, dynamic> toJson() {
    return {
      "cliente": cliente,
      "servicio": servicio,
      "nota": nota,
      "hora": hora,
      "fecha": fecha.toIso8601String(),
    };
  }

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json["id"],
      cliente: json["cliente"],
      servicio: json["servicio"],
      nota: json["nota"],
      hora: json["hora"],
      fecha: DateTime.parse(json["fecha"]),
    );
  }
}
