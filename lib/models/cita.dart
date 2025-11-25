class Cita {
  String cliente;
  String servicio;
  String? nota;
  String hora;
  DateTime fecha;

  Cita({
    required this.cliente,
    required this.servicio,
    this.nota,
    required this.hora,
    required this.fecha,
  });
}
