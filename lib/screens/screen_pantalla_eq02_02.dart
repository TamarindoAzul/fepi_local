import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart'; // Paquete para la firma
import 'package:pdf/widgets.dart' as pw; // Paquete para generar PDF
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FormularioEntrega extends StatefulWidget {
  static const String routeName = '/screen_pantalla_eq02_02';
  const FormularioEntrega({super.key});

  @override
  _FormularioEntregaState createState() => _FormularioEntregaState();
}

class _FormularioEntregaState extends State<FormularioEntrega> {
  final Map<String, dynamic> formData = {};
  final List<Map<String, dynamic>> materials = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey _firma1Key = GlobalKey();
  final GlobalKey _firma2Key = GlobalKey();
  final GlobalKey _firma3Key = GlobalKey();

  Uint8List? firma1;
  Uint8List? firma2;
  Uint8List? firma3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Entrega'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('Num Recibo', 'numRecibo'),
              _buildTextField('Clave de Centros de Trabajo', 'claveCentro'),
              _buildTextField('Entidad', 'entidad'),
              _buildTextField('Municipio', 'municipio'),
              _buildTextField('Comunidad', 'comunidad'),
              _buildDateField('Fecha de Entrega', 'fechaEntrega'),
              const SizedBox(height: 16),
              _buildMaterialsTable(),
              const Divider(),
              _buildSignatureSection1(),
              const Divider(),
              _buildSignatureSection2(),
              const Divider(),
              _buildSignatureSection3(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveData,
                child: const Text('Guardar y Generar PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      onSaved: (value) {
        formData[key] = value;
      },
    );
  }

  Widget _buildDateField(String label, String key) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            formData[key] = pickedDate.toIso8601String();
          });
        }
      },
    );
  }

  Widget _buildMaterialsTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Materiales', style: TextStyle(fontWeight: FontWeight.bold)),
        ...materials.map((material) => ListTile(
              title: Text(material['Material']),
              subtitle: Text('Cantidad: ${material['Cantidad']}, Observaciones: ${material['Observaciones']}'),
            )),
        ElevatedButton(
          onPressed: _addMaterial,
          child: const Text('Agregar Material'),
        ),
      ],
    );
  }

  void _addMaterial() {
    final materialOptions = [
      'Acta Constitutiva de la APEC y Convenio CONAFE-APEC',
      'Manual para la APEC',
      'Cuaderno de trabajo del Comité de Contraloría Social 2022-2023',
      'Cartel de Contraloría Social para el Conafe',
    ];

    showDialog(
      context: context,
      builder: (context) {
        String? selectedMaterial;
        String? quantity;
        String? observations;

        return AlertDialog(
          title: const Text('Agregar Material'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Material'),
                items: materialOptions
                    .map((material) => DropdownMenuItem(value: material, child: Text(material)))
                    .toList(),
                onChanged: (value) {
                  selectedMaterial = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Observaciones'),
                onChanged: (value) {
                  observations = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedMaterial != null && quantity != null) {
                  setState(() {
                    materials.add({
                      'Material': selectedMaterial,
                      'Cantidad': quantity,
                      'Observaciones': observations,
                    });
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSignatureSection1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sesión de Firma 1', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nombre Completo'),
          onSaved: (value) {
            formData['firma1Nombre'] = value;
          },
        ),
        CheckboxListTile(
          title: const Text('Presidente'),
          value: formData['cargoPresidente'] ?? false,
          onChanged: (value) {
            setState(() {
              formData['cargoPresidente'] = value;
            });
          },
        ),
        Signature(key: _firma1Key, color: Colors.black),
      ],
    );
  }

  Widget _buildSignatureSection2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sesión de Firma 2', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nombre Completo'),
          onSaved: (value) {
            formData['firma2Nombre'] = value;
          },
        ),
        Signature(key: _firma2Key, color: Colors.black),
      ],
    );
  }

  Widget _buildSignatureSection3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sesión de Firma 3', style: TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Nombre Completo'),
          onSaved: (value) {
            formData['firma3Nombre'] = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Cargo que Ocupa'),
          onSaved: (value) {
            formData['firma3Cargo'] = value;
          },
        ),
        Signature(key: _firma3Key, color: Colors.black),
      ],
    );
  }

  Future<void> _saveData() async {
    _formKey.currentState?.save();
    formData['materials'] = materials;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Formulario de Entrega (Ejemplo)'),
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/formulario_entrega.pdf");
    await file.writeAsBytes(await pdf.save());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PDF generado en: ${file.path}')),
    );
  }
}
