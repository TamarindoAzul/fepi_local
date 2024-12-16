import 'package:fepi_local/constansts/app_buttons.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:flutter/material.dart';

class ScreenPantallaSe00401 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_se00401';

  const ScreenPantallaSe00401({super.key});

  @override
  _ScreenPantallaSe00401State createState() => _ScreenPantallaSe00401State();
}

class _ScreenPantallaSe00401State extends State<ScreenPantallaSe00401>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Datos iniciales
  Map<String, String> alumnos = {
    "001": "Juan Pérez",
    "002": "Ana López",
    "003": "Carlos Gómez"
  };

  List<Map<String, dynamic>> actividades = [];
  List<Map<String, dynamic>> evaluaciones = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _crearActividad(BuildContext context) {
    String periodo = '';
    String materia = '';
    String titulo = '';
    String descripcion = '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Crear Actividad"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Periodo'),
              onChanged: (value) => periodo = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Materia'),
              onChanged: (value) => materia = value,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Título (Obligatorio)'),
              onChanged: (value) => titulo = value,
            ),
            TextField(
              decoration:
                  const InputDecoration(labelText: 'Descripción (Opcional)'),
              onChanged: (value) => descripcion = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (titulo.isNotEmpty) {
                setState(() {
                  actividades.add({
                    "id": actividades.length + 1,
                    "periodo": periodo,
                    "materia": materia,
                    "titulo": titulo,
                    "descripcion": descripcion,
                    "estado": "Activo"
                  });
                  for (var id in alumnos.keys) {
                    evaluaciones.add({
                      "idActividad": actividades.length,
                      "idAlumno": id,
                      "calf": null,
                      "observaciones": '',
                      "estado": "Pendiente"
                    });
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Crear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _guardarEvaluaciones() {
    bool allFilled = evaluaciones.every(
        (eval) => eval["calf"] != null && eval["observaciones"].isNotEmpty);

    if (allFilled) {
      setState(() {
        for (var actividad in actividades) {
          if (actividad["estado"] == "Activo") {
            actividad["estado"] = "Finalizado";
          }
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Evaluaciones enviadas correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Completa todos los campos antes de enviar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evaluación de alumnos'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Lista Alumnos'),
          Tab(text: 'Evaluar'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña Lista Alumnos
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: AppButtons.btnFORM(),
                  onPressed: () => _crearActividad(context),
                  child: Text(
                    'Crear Actividad',
                    style: AppTextStyles.secondBold(color: AppColors.color1),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: alumnos.length,
                  itemBuilder: (context, index) {
                    String id = alumnos.keys.elementAt(index);
                    return Card(
                      color: AppColors.color2,
                      child: ListTile(
                        title: Text(
                          alumnos[id]!,
                          style: AppTextStyles.secondMedium(
                              color: AppColors.color1),
                        ),
                        subtitle: Text(
                          "ID: $id",
                          style: AppTextStyles.secondRegular(
                              color: AppColors.color4),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Pestaña Evaluar
          Column(
            children: [
              DropdownButton<int>(
                hint: Text(
                  'Selecciona Actividad',
                  style: AppTextStyles.secondMedium(),
                ),
                onChanged: (value) {
                  setState(() {
                    evaluaciones = evaluaciones
                        .where((eval) => eval["idActividad"] == value)
                        .toList();
                  });
                },
                items: actividades
                    .where((actividad) => actividad["estado"] == "Activo")
                    .map((actividad) {
                  return DropdownMenuItem<int>(
                    value: actividad["id"],
                    child: Text(actividad["titulo"]),
                  );
                }).toList(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: evaluaciones.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> evaluacion = evaluaciones[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          "Alumno: ${alumnos[evaluacion["idAlumno"]]}",
                          style: AppTextStyles.secondMedium(
                              color: AppColors.color2),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  'Calificación',
                                  style: AppTextStyles.secondRegular(
                                      color: AppColors.color2),
                                ),
                                subtitle: DropdownButton<double>(
                                  style: AppTextStyles.secondMedium(
                                      color: AppColors.color3),
                                  value: evaluacion["calf"],
                                  items: const [
                                    DropdownMenuItem(
                                        value: 0, child: Text('0')),
                                    DropdownMenuItem(
                                        value: 1, child: Text('1')),
                                    DropdownMenuItem(
                                        value: 2, child: Text('2')),
                                    DropdownMenuItem(
                                        value: 3, child: Text('3')),
                                    DropdownMenuItem(
                                        value: 4, child: Text('4')),
                                    DropdownMenuItem(
                                        value: 5, child: Text('5')),
                                    DropdownMenuItem(
                                        value: 6, child: Text('6')),
                                    DropdownMenuItem(
                                        value: 7, child: Text('7')),
                                    DropdownMenuItem(
                                        value: 8, child: Text('8')),
                                    DropdownMenuItem(
                                        value: 9, child: Text('9')),
                                    DropdownMenuItem(
                                        value: 10, child: Text('10')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      evaluacion["calf"] = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    16), // Espacio entre el Dropdown y el TextField
                            Expanded(
                              child: TextField(
                                style: AppTextStyles.secondRegular(
                                    color: AppColors.color2),
                                decoration: InputDecoration(
                                  labelStyle: AppTextStyles.secondRegular(
                                      color: AppColors.color3),
                                  labelText: 'Observacion',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    evaluacion["observaciones"] = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _guardarEvaluaciones,
                style: AppButtons.btnFORM(backgroundColor: AppColors.color2),
                child: Text(
                  'Guardar Evaluaciones',
                  style: AppTextStyles.secondMedium(color: AppColors.color1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
