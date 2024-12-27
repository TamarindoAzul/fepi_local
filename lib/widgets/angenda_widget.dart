import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_buttons.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';

class AgendaWidget extends StatefulWidget {
  const AgendaWidget({Key? key}) : super(key: key);

  @override
  _AgendaWidgetState createState() => _AgendaWidgetState();
}

class _AgendaWidgetState extends State<AgendaWidget> {
  DateTime _selectedDate = DateTime.now(); // Fecha seleccionada por el usuario
  final Map<String, Map<String, String>> agendaData = {}; // Almacena datos de cada celda
  final List<String> days = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes'
  ];
  final List<String> hours = [
    '08:00 - 09:00', '09:00 - 10:00', '10:00 - 11:00', '11:00 - 12:00',
    '12:00 - 13:00', '13:00 - 14:00', '14:00 - 15:00', '15:00 - 16:00',
    '16:00 - 17:00', '17:00 - 18:00', '18:00 - 19:00', '19:00 - 20:00',
    '20:00 - 21:00', '21:00 - 22:00', '22:00 - 23:00', '24:00 - 00:00'
  ];

  String get semana => "Semana: ${_getWeekOfMonth(_selectedDate)}";
  String get mes => "Mes: ${_selectedDate.month}";
  String get anio => "Año: ${_selectedDate.year}";

  int _getWeekOfMonth(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final difference = date.difference(startOfMonth).inDays;
    return ((difference / 7).floor()) + 1;
  }

  void _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Actualizar la fecha seleccionada
      });
    }
  }

  // Define ScrollControllers for both scroll views
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Información de la semana, mes y año
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ElevatedButton(
                  style: AppButtons.btnFORM(),
                  onPressed: _seleccionarFecha,
                  child: Text(
                    'Seleccionar Fecha',
                    style: AppTextStyles.secondMedium(color: AppColors.color1),
                  ),
                ),
                Text(
                  "$semana | $mes | $anio",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: true,
            controller: verticalController,  // Attach the vertical scroll controller
            child: SingleChildScrollView(
              controller: verticalController,  // Same controller for vertical scroll
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                controller: horizontalController,  // Different controller for horizontal scroll
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                  border: TableBorder.all(color: Colors.grey, width: 0.5),
                  columns: [
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
                          for (var day in days)
                            _buildCell(
                              GestureDetector(
                                onTap: () => _showPopup(context, day, hour),
                                child: Container(
                                  width: 100,
                                  constraints: BoxConstraints(minWidth: 100),
                                  decoration: BoxDecoration(
                                    color: agendaData.containsKey('$day|$hour')
                                        ? Colors.lightBlue[100]
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    agendaData['$day|$hour']?['NombreEC'] ?? hour,
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
    );
  }

  DataCell _buildCell(Widget child) {
    return DataCell(
      Container(
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(),
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
                  decoration: const InputDecoration(
                      labelText: 'Descripción de la Actividad'),
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
        final _descripcionController =
            TextEditingController(text: data['Descripcion']);
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
                decoration: const InputDecoration(
                    labelText: 'Descripción de la Actividad'),
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
