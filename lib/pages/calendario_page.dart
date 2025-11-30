import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/cita_controller.dart';
import '../models/cita.dart';
import 'crear_cita_page.dart';

class CalendarioCitasPage extends StatefulWidget {
  @override
  _CalendarioCitasPageState createState() => _CalendarioCitasPageState();
}

class _CalendarioCitasPageState extends State<CalendarioCitasPage> {
  final CitasController controller = CitasController();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    await controller.cargarCitasDeSupabase();
    setState(() => cargando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Calendario de citas")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CrearCitaPage(
                fechaInicial: _selectedDay!,
              ),
            ),
          );

          if (result != null && result is Cita) {
            await controller.agregarCita(result);
            setState(() {});
          }
        },
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 1, 1),
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            eventLoader: controller.getCitas,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),

          Expanded(
            child: ListView(
              children: controller.getCitas(_selectedDay!).map((cita) {
                return Card(
                  child: ListTile(
                    title: Text("${cita.servicio} - ${cita.hora}"),
                    subtitle: Text(cita.cliente),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            final nueva = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CrearCitaPage(
                                  fechaInicial: cita.fecha,
                                  citaAEditar: cita,
                                ),
                              ),
                            );

                            if (nueva != null && nueva is Cita) {
                              await controller.editarCita(cita, nueva);
                              setState(() {});
                            }
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await controller.eliminarCita(cita);
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
