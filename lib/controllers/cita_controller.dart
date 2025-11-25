import '../models/cita.dart';

class CitasController {
  final Map<DateTime, List<Cita>> _citas = {};

  List<Cita> getCitas(DateTime fecha) {
    final fechaClean = DateTime(fecha.year, fecha.month, fecha.day);
    return _citas[fechaClean] ?? [];
  }

  void agregarCita(Cita cita) {
    final fecha = DateTime(cita.fecha.year, cita.fecha.month, cita.fecha.day);
    if (_citas[fecha] == null) _citas[fecha] = [];
    _citas[fecha]!.add(cita);
  }

  void editarCita(Cita vieja, Cita nueva) {
    final fechaOld = DateTime(vieja.fecha.year, vieja.fecha.month, vieja.fecha.day);
    _citas[fechaOld]?.remove(vieja);

    final fechaNew = DateTime(nueva.fecha.year, nueva.fecha.month, nueva.fecha.day);
    if (_citas[fechaNew] == null) _citas[fechaNew] = [];
    _citas[fechaNew]!.add(nueva);
  }

  void eliminarCita(Cita cita) {
    final fecha = DateTime(cita.fecha.year, cita.fecha.month, cita.fecha.day);
    _citas[fecha]?.remove(cita);
  }
}
