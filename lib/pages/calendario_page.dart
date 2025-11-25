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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendario de citas")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CrearCitaPage(
                fechaInicial: _selectedDay!,
                onSave: (cita) {
                  setState(() {
                    controller.agregarCita(cita);
                  });
                },
              ),
            ),
          );
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
                        Text(cita.nota ?? ""),
                        SizedBox(width: 10),

                        // BOTÓN EDITAR
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CrearCitaPage(
                                  fechaInicial: cita.fecha,
                                  citaAEditar: cita,
                                  onSave: (nueva) {
                                    setState(() {
                                      controller.editarCita(cita, nueva);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),

                        // BOTÓN ELIMINAR
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("Eliminar cita"),
                                content: Text(
                                    "¿Seguro que deseas eliminar esta cita?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancelar"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  TextButton(
                                    child: Text("Eliminar"),
                                    onPressed: () {
                                      setState(() {
                                        controller.eliminarCita(cita);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
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
