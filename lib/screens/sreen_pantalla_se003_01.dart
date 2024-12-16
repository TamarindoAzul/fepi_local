import 'package:flutter/material.dart';

class SreenPantallaSe003_01 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_se003_01';
  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<SreenPantallaSe003_01> {
  final Map<String, Map<String, String>> agendaData = {}; // Almacena datos de cada celda

  final List<String> days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'];
  final List<String> hours = [
    '08:00 - 09:00',
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
    '21:00 - 22:00',
    '22:00 - 23:00',
    '24:00 - 00:00',
  ];

  final String semana = "Semana: 10"; // Semana
  final String mes = "Mes: Marzo"; // Mes
  final String anio = "Año: 2024"; // Año

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
      ),
      body: Column(
        children: [
          // Información de la semana, mes y año
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "$semana | $mes | $anio",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                    border: TableBorder.all(color: Colors.grey, width: 0.5),
                    columns: [
                      const DataColumn(
                        label: Text(
                          'Horario',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      for (var day in days)
                        DataColumn(
                          label: Text(
                            day,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                    rows: [
                      for (var hour in hours)
                        DataRow(
                          cells: [
                            _buildCell(Text(hour)),
                            for (var day in days)
                              _buildCell(
                                GestureDetector(
                                  onTap: () => _showPopup(context, day, hour),
                                  child: Container(
                                    constraints: BoxConstraints(maxWidth: double.infinity), // Asegura que ocupe todo el espacio disponible
                                    decoration: BoxDecoration(
                                      color: agendaData.containsKey('$day|$hour')
                                          ? Colors.lightBlue[100]
                                          : Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0), // Ajusta el padding para un mejor espacio
                                    child: Text(
                                      agendaData['$day|$hour']?['NombreEC'] ?? '',
                                      style: const TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Método para construir celdas
  DataCell _buildCell(Widget child) {
    return DataCell(
      Container(
        padding: EdgeInsets.zero, // Eliminamos el relleno interno
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(), // Se asegura de que el contenedor ocupe todo el espacio disponible
        child: child,
      ),
    );
  }

  void _showPopup(BuildContext context, String day, String hour) {
    final cellKey = '$day|$hour';
    final isFilled = agendaData.containsKey(cellKey);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (isFilled) {
          // Mostrar información de la celda llena
          final data = agendaData[cellKey]!;
          return AlertDialog(
            title: const Text('Detalles de Actividad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Horario: ${data['Horario']}'),
                const SizedBox(height: 8),
                Text('Nombre EC: ${data['NombreEC']}'),
                const SizedBox(height: 8),
                Text('Descripción: ${data['Descripcion']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _editCell(context, day, hour);
                },
                child: const Text('Editar'),
              ),
            ],
          );
        } else {
          // Permitir agregar datos a celdas vacías
          final _descripcionController = TextEditingController();
          String? selectedEC;
          final List<String> nombreECOptions = ['EC1', 'EC2', 'EC3'];

          return AlertDialog(
            title: const Text('Nueva Actividad'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Horario: $hour'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedEC,
                  items: nombreECOptions
                      .map((ec) => DropdownMenuItem<String>(
                            value: ec,
                            child: Text(ec),
                          ))
                      .toList(),
                  onChanged: (value) => selectedEC = value,
                  decoration: const InputDecoration(labelText: 'Selecciona EC'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción de la Actividad'),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedEC != null) {
                    setState(() {
                      agendaData[cellKey] = {
                        'Horario': hour,
                        'NombreEC': selectedEC!,
                        'Descripcion': _descripcionController.text,
                      };
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        }
      },
    );
  }

  void _editCell(BuildContext context, String day, String hour) {
    final cellKey = '$day|$hour';
    final data = agendaData[cellKey]!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final _descripcionController = TextEditingController(text: data['Descripcion']);
        String selectedEC = data['NombreEC']!;
        final List<String> nombreECOptions = ['EC1', 'EC2', 'EC3'];

        return AlertDialog(
          title: const Text('Editar Actividad'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horario: $hour'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedEC,
                items: nombreECOptions
                    .map((ec) => DropdownMenuItem<String>(
                          value: ec,
                          child: Text(ec),
                        ))
                    .toList(),
                onChanged: (value) => selectedEC = value!,
                decoration: const InputDecoration(labelText: 'Selecciona EC'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción de la Actividad'),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  agendaData[cellKey] = {
                    'Horario': hour,
                    'NombreEC': selectedEC,
                    'Descripcion': _descripcionController.text,
                  };
                });
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
