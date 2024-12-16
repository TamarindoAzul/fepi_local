import 'package:fepi_local/prueba/alumnosAltabd.dart';
import 'package:fepi_local/widgets/fecha.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fepi_local/constansts/app_buttons.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';

class FormRegistroAlumno extends StatefulWidget {
  @override
  _FormRegistroAlumnoState createState() => _FormRegistroAlumnoState();
}

class _FormRegistroAlumnoState extends State<FormRegistroAlumno> {
  // Controladores de texto
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController lugarNacimientoController = TextEditingController();
  TextEditingController domicilioController = TextEditingController();
  TextEditingController municipioController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController nombrePadreController = TextEditingController();
  TextEditingController curpController = TextEditingController();
  TextEditingController ocupacionPadreController = TextEditingController();
  TextEditingController telefonoPadreController = TextEditingController();

  // Variables para los documentos
  File? actaNacimiento;
  File? certificadoEstudios;
  File? cartillaVacunacion;

  // Variables para las fotos
  File? fotoVacunacion;

  // Variables para los selectores
  String? nivelEducativo;
  String? gradoEscolar;

 Future<void> _pickActaNacimiento() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
  );

  if (result != null && result.files.single.path != null) {
    File file = File(result.files.single.path!);

    if (await file.exists()) {
      setState(() {
        actaNacimiento = file;
      });
      print("Archivo seleccionado: ${file.path}");
    } else {
      print("El archivo no existe en la ruta seleccionada.");
    }
  } else {
    print("No se seleccionó ningún archivo.");
  }
}


  // Método para seleccionar un archivo específico para PDFs
  Future<void> _pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: type == 'pdf' ? ['pdf'] : ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        if (type == 'pdf') {
          certificadoEstudios = File(result.files.single.path!);
        } else if (type == 'vacunacion') {
          fotoVacunacion = File(result.files.single.path!);
        }
      });
    }
  }

  // Función para crear el mapa con la información
  Map<String, dynamic> obtenerDatosFormulario() {
    return {
      'actaNacimiento': actaNacimiento,
      'curp': curpController.text, // CURP como texto
      'fechaNacimiento': fechaNacimientoController.text,
      'lugarNacimiento': lugarNacimientoController.text,
      'domicilio': domicilioController.text,
      'municipio': municipioController.text,
      'estado': estadoController.text,
      'nivelEducativo': nivelEducativo,
      'gradoEscolar': gradoEscolar,
      'certificadoEstudios': certificadoEstudios,
      'nombrePadre': nombrePadreController.text,
      'ocupacionPadre': ocupacionPadreController.text,
      'telefonoPadre': telefonoPadreController.text,
      'fotoVacunacion': fotoVacunacion,
      'state': 'pendiente',
      'nota':' '
    };
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de carga de documentos
            Container(
                foregroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: AppColors.color2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("Documentos de Identidad",
                          style: AppTextStyles.secondBold(
                              color: AppColors.color2)),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(actaNacimiento == null
                              ? Icons.note_add_sharp
                              : Icons.file_copy),
                          onPressed: _pickActaNacimiento,
                          style: AppButtons.btnFORM(
                              backgroundColor: actaNacimiento == null
                                  ? AppColors.color3
                                  : AppColors.color2),
                          label: Text(actaNacimiento == null
                              ? 'Cargar Acta de Nacimiento'
                              : 'Acta de Nacimiento Cargada'),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColors.color2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Datos Personales",
                      style: AppTextStyles.secondBold(color: AppColors.color2),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: curpController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe tu CURP',
                        labelText: 'CURP',
                        prefixIcon: Icon(Icons.assignment_ind_outlined),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DateTextField(
                      controller: fechaNacimientoController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'DD/MM/AAAA',
                        labelText: 'Fecha de Nacimiento',
                        prefixIcon: Icon(Icons.calendar_month),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: lugarNacimientoController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe el lugar de Nacimiento',
                        labelText: 'Lugar de Nacimiento',
                        prefixIcon: Icon(Icons.add_location_rounded),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: domicilioController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe tu Domicilio',
                        labelText: 'Domicilio',
                        prefixIcon: Icon(Icons.house),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: municipioController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe tu Municipio',
                        labelText: 'Municipio',
                        prefixIcon: Icon(Icons.map),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: estadoController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe tu Estado',
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            // Sección de datos académicos
            Container(
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColors.color2)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Datos Académicos",
                      style: AppTextStyles.secondBold(color: AppColors.color2),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      value: nivelEducativo,
                      decoration: AppButtons.dropdownButtonStyle(
                        hintText:
                            'Nivel Educativo', // Personaliza el texto de hint
                        labelText:
                            'Nivel Educativo', // Personaliza el texto de label
                      ),
                      items: ['Preescolar', 'Primaria', 'Secundaria']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          nivelEducativo = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      value: gradoEscolar,
                      decoration: AppButtons.dropdownButtonStyle(
                        hintText:
                            'Grado Escolar', // Personaliza el texto de hint
                        labelText:
                            'Grado Escolar', // Personaliza el texto de label
                      ),
                      items: ['1ro', '2do', '3ro', '4to', '5to', '6to']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          gradoEscolar = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(certificadoEstudios == null
                          ? Icons.file_present_sharp
                          : Icons.file_copy),
                      style: AppButtons.btnFORM(
                          backgroundColor: certificadoEstudios == null
                              ? AppColors.color3
                              : AppColors.color2),
                      onPressed: () => _pickFile('pdf'),
                      label: Text(certificadoEstudios == null
                          ? 'Cargar Certificado'
                          : 'Certificado Cargado'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            // Sección de identidad de los padres
            Container(
              foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColors.color2)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Identidad de los Padres/Tutores",
                      style: AppTextStyles.secondBold(color: AppColors.color2),
                    ),
                    TextField(
                      controller: nombrePadreController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe el nombre',
                        labelText: 'Nombre del Padre/Tutor',
                        prefixIcon: Icon(Icons.supervised_user_circle),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: ocupacionPadreController,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe la ocupación',
                        labelText: 'Ocupación del Padre/Tutor',
                        prefixIcon: Icon(Icons.business_center),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: telefonoPadreController,
                      keyboardType: TextInputType.phone,
                      decoration: AppButtons.textFieldStyle(
                        hintText: 'Escribe el telefono',
                        labelText: 'Teléfono del Padre/Tutor',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () => _pickFile('vacunacion'),
              icon: Icon(fotoVacunacion == null
                  ? Icons.add_photo_alternate_rounded
                  : Icons.file_copy),
              style: AppButtons.btnFORM(
                  backgroundColor: fotoVacunacion == null
                      ? AppColors.color3
                      : AppColors.color2),
              label: Text(fotoVacunacion == null
                  ? 'Cargar cartilla de vacunación'
                  : 'Cartilla Cargada'),
            ),
            fotoVacunacion != null ? SizedBox.shrink() : SizedBox.shrink(),

            // Botón para finalizar el formulario
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  style: AppButtons.btnFORM(backgroundColor: AppColors.color2),
                  onPressed: () async {
                    final Map<String, dynamic> data = obtenerDatosFormulario();
                    final db = AlumnosDB(); // Instancia de la base de datos
                          
                    try {
                      // Asegúrate de que las rutas a los archivos estén incluidas en `data`
                      await insertarAlumnoConArchivos(
                          data); // Usa la función con soporte para archivos
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Registro guardado exitosamente.',
                            style: AppTextStyles.secondRegular(
                                color: AppColors.color1),
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error al guardar el registro: $e',
                            style: AppTextStyles.secondRegular(
                                color: AppColors.color1),
                          ),
                        ),
                      );
                    }
                  
                  },
                  child: Text('Enviar Registro'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
