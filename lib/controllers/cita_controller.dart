import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cita.dart';

class CitasController {
  final supabase = Supabase.instance.client;

  final Map<DateTime, List<Cita>> _citas = {};

  List<Cita> getCitas(DateTime fecha) {
    final f = DateTime(fecha.year, fecha.month, fecha.day);
    return _citas[f] ?? [];
  }

  Future<void> cargarCitasDeSupabase() async {
    final data = await supabase.from('citas').select();

    _citas.clear();

    for (var item in data) {
      final cita = Cita.fromJson(item);
      final fecha = DateTime(cita.fecha.year, cita.fecha.month, cita.fecha.day);

      _citas.putIfAbsent(fecha, () => []);
      _citas[fecha]!.add(cita);
    }
  }

  Future<void> agregarCita(Cita cita) async {
    final res = await supabase.from('citas').insert(cita.toJson()).select();

    final newCita = Cita.fromJson(res.first);

    final fecha = DateTime(newCita.fecha.year, newCita.fecha.month, newCita.fecha.day);
    _citas.putIfAbsent(fecha, () => []);
    _citas[fecha]!.add(newCita);
  }

  Future<void> editarCita(Cita vieja, Cita nueva) async {
    await supabase.from('citas')
      .update(nueva.toJson())
      .eq('id', vieja.id as Object);

    final oldDate = DateTime(vieja.fecha.year, vieja.fecha.month, vieja.fecha.day);
    _citas[oldDate]?.removeWhere(((c) => c.id == vieja.id));

    final newDate = DateTime(nueva.fecha.year, nueva.fecha.month, nueva.fecha.day);
    _citas.putIfAbsent(newDate, () => []);
    _citas[newDate]!.add(nueva);
  }

  Future<void> eliminarCita(Cita cita) async {
    await supabase.from('citas').delete().eq('id', cita.id as Object);

    final fecha = DateTime(cita.fecha.year, cita.fecha.month, cita.fecha.day);
    _citas[fecha]?.removeWhere((c) => c.id == cita.id);
  }
}

