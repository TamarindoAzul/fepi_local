import 'package:fepi_local/database/database_gestor.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaWidget extends StatefulWidget {
  const AgendaWidget({Key? key}) : super(key: key);

  @override
  _AgendaWidgetState createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends State<AgendaWidget> {
  late Future<Map<String, List<Map<String, dynamic>>>> _eventos;

  @override
  void initState() {
    super.initState();
    _eventos = _cargarEventos(); // Aquí se llama a la función que retorna un Future
  }

  Future<Map<String, List<Map<String, dynamic>>>> _cargarEventos() async {
    final db = DatabaseHelper();
    final eventos = await db.obtenerActividadesPorUsuario(1);
    print (eventos);
    return eventos;
  }

  Future<void> _crearActividad() async {
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController horaController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController estadoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Agregar Actividad'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fechaController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              ),
              TextField(
                controller: horaController,
                decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: estadoController,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final nuevaActividad = {
                'id_Usuario': 1, // Asegúrate de incluir el ID de usuario aquí
                'fecha': fechaController.text.trim(),
                'hora': horaController.text.trim(),
                'nombreEC': nombreController.text.trim(),
                'descripcion': descripcionController.text.trim(),
                'estado': estadoController.text.trim(),
              };
              final bd= await DatabaseHelper(); 
              // Insertar la nueva actividad en la base de datos
              await bd.insertarActividad(nuevaActividad);

              // Actualizar la UI
              final eventos = await _eventos;
              setState(() {
                final fecha = nuevaActividad['fecha'] as String;
                if (eventos[fecha] == null) {
                  eventos[fecha!] = [];
                }
                eventos[fecha]!.add(nuevaActividad);
                print("Actividad agregada. Eventos actuales: $eventos");
              });

              Navigator.of(context).pop();
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _editarActividad(Map<String, dynamic> actividad) {
  final TextEditingController fechaController = TextEditingController(text: actividad['fecha']);
  final TextEditingController horaController = TextEditingController(text: actividad['hora']);
  final TextEditingController nombreController = TextEditingController(text: actividad['nombreEC']);
  final TextEditingController descripcionController = TextEditingController(text: actividad['descripcion']);
  final TextEditingController estadoController = TextEditingController(text: actividad['estado']);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Editar Actividad'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: fechaController,
              decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
            ),
            TextField(
              controller: horaController,
              decoration: const InputDecoration(labelText: 'Hora (HH:MM)'),
            ),
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: estadoController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final actividadEditada = {
              'id_ActividadAcomp': actividad['id_ActividadAcomp'],
              'fecha': fechaController.text.trim(),
              'hora': horaController.text.trim(),
              'nombreEC': nombreController.text.trim(),
              'descripcion': descripcionController.text.trim(),
              'estado': estadoController.text.trim(),
            };

            // Llamar a la función para editar la actividad en la base de datos
            final db = DatabaseHelper();
            await db.editarActividadAcomp(actividadEditada);

            // Actualizar la UI después de editar la actividad
            final eventos = await _eventos;

            setState(() {
              final fecha = actividadEditada['fecha'];
              final index = eventos[fecha]?.indexWhere((act) => act['id_ActividadAcomp'] == actividad['id_ActividadAcomp']);
              if (index != null && index != -1) {
                eventos[fecha]![index] = actividadEditada;
              }
            });

            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

  void _eliminarActividad(Map<String, dynamic> actividad) async {
  final fecha = actividad['fecha'];
  final idActividad = actividad['id_ActividadAcomp'];
  print(idActividad); // Suponiendo que este es el identificador único

  // Llamar a la función de eliminación de la base de datos
  final db = DatabaseHelper();
  await db.eliminarActividad(idActividad);

  // Actualizar la UI después de eliminar la actividad de la base de datos
  final eventos = await _eventos;

  setState(() {
    eventos[fecha]?.removeWhere((act) => act['id_ActividadAcomp'] == idActividad);
    if (eventos[fecha]?.isEmpty ?? true) {
      eventos.remove(fecha);
    }
  });

  print("Actividad eliminada. Eventos actuales: $eventos");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Actividades'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _crearActividad, // Llamada a la función para agregar actividad
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _eventos, // Este espera que _eventos sea un Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final eventos = snapshot.data ?? {}; // Aquí es donde puedes acceder a los eventos cargados
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: DateTime.now(),
                eventLoader: (day) {
                  final fecha = '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
                  return eventos[fecha] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) async {
                  final fecha = '${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}';
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Actividades para $fecha'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var actividad in eventos[fecha] ?? [])
                              ListTile(
                                title: Text(actividad['nombreEC']),
                                subtitle: Text('${actividad['hora']} - ${actividad['descripcion']}'),
                                onTap: () {
                                  _editarActividad(actividad);
                                },
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _eliminarActividad(actividad);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
