import 'package:fepi_local/constansts/app_buttons.dart';
import 'package:flutter/material.dart';
import 'package:fepi_local/constansts/app_colors.dart';
import 'package:fepi_local/constansts/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class ScreenPantallaEq00301 extends StatefulWidget {
  static const String routeName = '/screen_pantalla_eq00301';
  const ScreenPantallaEq00301({super.key});

  @override
  _ScreenPantallaEq00301State createState() => _ScreenPantallaEq00301State();
}

class _ScreenPantallaEq00301State extends State<ScreenPantallaEq00301> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _formulariosMobiliario = [];
  final String _periodoEscolar = '2023-2024'; // Esto podría generarse dinámicamente.
  bool _registroExitoso = false;

  void _agregarFormulario() {
    setState(() {
      _formulariosMobiliario.add({
        'nombre': '',
        'cantidad': 0,
        'condicion': 'Nuevo',
        'comentarios': '',
        'periodo': '2023-2024',
      });
    });
  }

  void _eliminarFormulario(int index) {
    setState(() {
      _formulariosMobiliario.removeAt(index);
    });
  }

  void _registrarMobiliarios() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _registroExitoso = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Todos los registros se enviaron correctamente.')),
      );
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: AppColors.color1,),onPressed:(){context.pop();}),
        title: const Text('REGISTRO DE MOBILIARIO POR EC'),
        titleTextStyle: AppTextStyles.primaryRegular(color: AppColors.color1),
        backgroundColor: AppColors.color3,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Periodo Escolar: $_periodoEscolar',
                style: AppTextStyles.secondMedium(color: AppColors.color2)),
            const SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView.builder(
                  itemCount: _formulariosMobiliario.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: AppColors.color1,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Mobiliario',style: AppTextStyles.secondRegular(color: AppColors.color3),),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: AppColors.color3),
                                  onPressed: () => _eliminarFormulario(index),
                                ),
                              ],
                            ),
                            TextFormField(
                              
                              decoration:
                              AppButtons.textFieldStyle(labelText: 'Nombre del mobiliario',
                                ),
                              
                              onSaved: (value) => _formulariosMobiliario[index]['nombre'] = value!,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese el nombre del mobiliario.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: AppButtons.textFieldStyle(
                                labelText: 'Cantidad de unidades',
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => _formulariosMobiliario[index]['cantidad'] = int.parse(value!),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese la cantidad de unidades.';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Ingrese un número válido.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              decoration:  AppButtons.dropdownButtonStyle(
                                labelText: 'Condición del mobiliario',
                              ),
                              value: _formulariosMobiliario[index]['condicion'],
                              items: const [
                                DropdownMenuItem(
                                  value: 'Nuevo',
                                  child: Text('Nuevo'),
                                ),
                                DropdownMenuItem(
                                  value: 'Usado',
                                  child: Text('Usado'),
                                ),
                                DropdownMenuItem(
                                  value: 'Dañado',
                                  child: Text('Dañado'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _formulariosMobiliario[index]['condicion'] = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: AppButtons.textFieldStyle(
                                labelText: 'Comentarios adicionales (opcional)',
                              ),
                              onSaved: (value) => _formulariosMobiliario[index]['comentarios'] = value,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _agregarFormulario,
                  style: AppButtons.btnFORM(backgroundColor: AppColors.color2),
                  child: Text('Agregar Mobiliario', style: AppTextStyles.secondRegular(color: AppColors.color1, fontSize: 10)),
                ),
                ElevatedButton(
                  onPressed: _registrarMobiliarios,
                  style: AppButtons.btnFORM(
                    backgroundColor: AppColors.color3,
                  ),
                  child: Text('Enviar Todo', style: AppTextStyles.secondRegular(color: AppColors.color1,fontSize: 10),),
                ),
              ],
            ),
            if (_registroExitoso)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    '¡Todos los registros se enviaron correctamente!',
                    style: AppTextStyles.primaryRegular(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
