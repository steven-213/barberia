import 'package:flutter/material.dart';
import '../models/cita.dart';

class CrearCitaPage extends StatefulWidget {
  final Function(Cita) onSave;
  final DateTime fechaInicial;
  final Cita? citaAEditar;

  CrearCitaPage({
    required this.onSave,
    required this.fechaInicial,
    this.citaAEditar,
  });

  @override
  State<CrearCitaPage> createState() => _CrearCitaPageState();
}

class _CrearCitaPageState extends State<CrearCitaPage> {
  final clienteCtrl = TextEditingController();
  final servicioCtrl = TextEditingController();
  final notaCtrl = TextEditingController();

  TimeOfDay? horaSeleccionada;
  late DateTime fechaSeleccionada;

  @override
  void initState() {
    super.initState();

    fechaSeleccionada = widget.fechaInicial;

    if (widget.citaAEditar != null) {
      clienteCtrl.text = widget.citaAEditar!.cliente;
      servicioCtrl.text = widget.citaAEditar!.servicio;
      notaCtrl.text = widget.citaAEditar!.nota ?? "";

      final partes = widget.citaAEditar!.hora.split(":");
      horaSeleccionada = TimeOfDay(
        hour: int.parse(partes[0]),
        minute: int.parse(partes[1]),
      );

      fechaSeleccionada = widget.citaAEditar!.fecha;
    }
  }

  void guardar() {
    if (clienteCtrl.text.isEmpty ||
        servicioCtrl.text.isEmpty ||
        horaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Completa todos los campos obligatorios")),
      );
      return;
    }

    final cita = Cita(
      cliente: clienteCtrl.text,
      servicio: servicioCtrl.text,
      nota: notaCtrl.text,
      hora:
          "${horaSeleccionada!.hour}:${horaSeleccionada!.minute.toString().padLeft(2, '0')}",
      fecha: fechaSeleccionada,
    );

    widget.onSave(cita);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.citaAEditar == null ? "Crear cita" : "Editar cita"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: clienteCtrl,
              decoration: InputDecoration(labelText: "Cliente"),
            ),
            TextField(
              controller: servicioCtrl,
              decoration: InputDecoration(labelText: "Servicio"),
            ),
            TextField(
              controller: notaCtrl,
              decoration: InputDecoration(labelText: "Nota (opcional)"),
            ),
            SizedBox(height: 20),

            // botón seleccionar hora
            Row(
              children: [
                Text(horaSeleccionada == null
                    ? "Hora no seleccionada"
                    : "Hora: ${horaSeleccionada!.hour}:${horaSeleccionada!.minute.toString().padLeft(2, "0")}"),
                Spacer(),
                ElevatedButton(
                  child: Text("Seleccionar hora"),
                  onPressed: () async {
                    final hora = await showTimePicker(
                      context: context,
                      initialTime:
                          horaSeleccionada ?? TimeOfDay.now(),
                    );
                    if (hora != null) {
                      setState(() => horaSeleccionada = hora);
                    }
                  },
                )
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: guardar,
              child: Text("Guardar cita"),
            ),
          ],
        ),
      ),
    );
  }
}
