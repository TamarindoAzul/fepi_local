import 'package:fepi_local/database/database_gestor.dart';
import 'package:fepi_local/routes/getSavedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class TablaMatrizAct extends StatefulWidget {
  const TablaMatrizAct({Key? key}) : super(key: key);

  @override
  _TablaMatrizActState createState() => _TablaMatrizActState();
}

class _TablaMatrizActState extends State<TablaMatrizAct> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numeroCapacitacionController =
      TextEditingController();
  final TextEditingController _temaController = TextEditingController();
  final TextEditingController _claveRegionController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _claveMicroregionController =
      TextEditingController();
  final TextEditingController _nombreMicroregionController =
      TextEditingController();
  DateTime? _fechaProgramada;

  // Aquí va la función para insertar los datos
  Future<void> insertarDatosActCAP(Map<String, dynamic> datos) async {
    final db = await DatabaseHelper(); // Reemplaza con tu base de datos
    final prefs = await getSavedPreferences();
    final Map<String, dynamic> dataToInsert = {
      'id_Usuario': prefs['id_Usuario'] ?? 0, 
      'NumCapacitacion': datos['NumeroCapacitacion'],
      'TEMA': datos['Tema'],
      'ClaveRegion': datos['ClaveRegion'],
      'NombreRegion': datos['Region'], // Asegúrate de que los nombres coincidan
      'FechaProgramada': datos['FechaProgramada'],
      'Estado': datos['Estado'],
      'Reporte': datos['Reporte'],
    };
    print(dataToInsert);
    // Inserción en la base de datos
    await db.insertarDatosActCAP(dataToInsert);
  }

  void _asignar() {
  if (_formKey.currentState!.validate()) {
    // Convierte la fecha a texto si está seleccionada
    String fechaProgramadaTexto = _fechaProgramada != null
        ? _fechaProgramada!.toLocal().toString().split(' ')[0] // Obtiene la fecha en formato YYYY-MM-DD
        : '';

    final Map<String, dynamic> datos = {
      'NumeroCapacitacion': _numeroCapacitacionController.text,
      'Tema': _temaController.text,
      'ClaveRegion': _claveRegionController.text,
      'Region': _regionController.text,
      'ClaveMicroregion': _claveMicroregionController.text,
      'NombreMicroregion': _nombreMicroregionController.text,
      'FechaProgramada': fechaProgramadaTexto,  // Pasa la fecha como texto
      'Estado': 'Activo',
      'Reporte': '',
    };

    // Insertar los datos en la base de datos
    insertarDatosActCAP(datos);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Datos asignados con éxito')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario Matriz Act'),
      ),
      body: SingleChildScrollView(
        // Previene desbordamiento
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _numeroCapacitacionController,
                  decoration: const InputDecoration(
                      labelText: 'Número de Capacitación'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un número';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _temaController,
                  decoration: const InputDecoration(labelText: 'Tema'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un tema';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _claveRegionController,
                  decoration: const InputDecoration(labelText: 'Clave Región'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una clave de región';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _regionController,
                  decoration: const InputDecoration(labelText: 'Región'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una región';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _claveMicroregionController,
                  decoration:
                      const InputDecoration(labelText: 'Clave Microregión'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa una clave de microregión';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _nombreMicroregionController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre Microregión'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre de microregión';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _fechaProgramada == null
                            ? 'Fecha Programada: No seleccionada'
                            : 'Fecha Programada: ${_fechaProgramada!.toLocal()}'
                                .split(' ')[0],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _fechaProgramada = selectedDate;
                          });
                        }
                      },
                      child: const Text('Seleccionar Fecha'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _asignar,
                  child: const Text('Asignar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
