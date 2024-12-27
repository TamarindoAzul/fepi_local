import 'package:fepi_local/constansts/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';

class ScreenPantallaSe001 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_se001';
  const ScreenPantallaSe001({super.key});

  @override
  _ScreenPantallaSe001State createState() => _ScreenPantallaSe001State();
}

class _ScreenPantallaSe001State extends State<ScreenPantallaSe001> {
  DateTime? _selectedDate;
  final Map<String, Map<String, dynamic>> _asistenciaProfesores = {
    'Profesor 1': {'asistencia': false, 'entrada': null, 'salida': null},
    'Profesor 2': {'asistencia': false, 'entrada': null, 'salida': null},
    'Profesor 3': {'asistencia': false, 'entrada': null, 'salida': null},
  };

  void _seleccionarFecha(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _registrarAsistencia() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe seleccionar una fecha antes de registrar la asistencia.')),
      );
      return;
    }

    // Aquí se pueden guardar los datos en una base de datos o servicio.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registro de asistencia enviado correctamente.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoreo del desempeño de EC'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: AppButtons.btnFORM(),
                    onPressed: () => _seleccionarFecha(context),
                    child: Text('Seleccionar Fecha',style:  AppTextStyles.secondMedium(color: AppColors.color1)),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(height: 20,),
                  Text(
                    _selectedDate == null
                        ? 'No se ha seleccionado fecha'
                        : 'Fecha seleccionada: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    style: AppTextStyles.secondMedium(color: AppColors.color2, fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: _asistenciaProfesores.entries.map((entry) {
                  final String nombre = entry.key;
                  final Map<String, dynamic> datos = entry.value;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nombre, style: AppTextStyles.secondMedium(color: AppColors.color3)),
                          const SizedBox(height: 10),
                          CheckboxListTile(
                            checkColor: AppColors.color1,
                            activeColor: AppColors.color3,
                            title: Text('Asistencia', style: AppTextStyles.secondRegular(color: AppColors.color2),),
                            value: datos['asistencia'],
                            onChanged: _selectedDate == null
                                ? null
                                : (bool? value) {
                                    setState(() {
                                      datos['asistencia'] = value ?? false;
                                      if (!datos['asistencia']) {
                                        datos['entrada'] = null;
                                        datos['salida'] = null;
                                      }
                                    });
                                  },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: AppButtons.textFieldStyle(
                              labelText: 'Horario de entrada',
                            ),
                            keyboardType: TextInputType.datetime,
                            enabled: datos['asistencia'],
                            initialValue: datos['entrada'] ?? '',
                            onChanged: (value) {
                              setState(() {
                                datos['entrada'] = value;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: AppButtons.textFieldStyle(
                              labelText: 'Horario de salida',
                            ),
                            keyboardType: TextInputType.datetime,
                            enabled: datos['asistencia'],
                            initialValue: datos['salida'] ?? '',
                            onChanged: (value) {
                              setState(() {
                                datos['salida'] = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _registrarAsistencia,
                style: AppButtons.btnFORM(backgroundColor: AppColors.color3),
                child: Text('Enviar Registro',style: AppTextStyles.secondMedium(color: AppColors.color1),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
