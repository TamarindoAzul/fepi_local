import 'dart:typed_data';
import 'package:fepi_local/database/database_gestor.dart';
import 'package:flutter/services.dart'; // Necesario para rootBundle

Future<Uint8List> loadPdfFromAssets(String filename) async {

  final ByteData data = await rootBundle.load('lib/assets/ReciboMateriales.pdf');
  return data.buffer.asUint8List();
}

Future<Uint8List> loadImageFromAssets(String filename) async {
  final ByteData data = await rootBundle.load('lib/assets/logo.png');
  return data.buffer.asUint8List();
}

Future<void> insertMassiveDataForAllTables() async {
  final dbhelper = DatabaseHelper();
  final db = await dbhelper.database;

  // Función auxiliar para formatear fechas
  String formatDate(int year, int month, int day) {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');
    return '$year-$formattedMonth-$formattedDay';
  }

  // 1. Insertar datos en Comunidad
  for (int i = 1; i <= 5; i++) {
    await db.insert('Comunidad', {
      'claveMicroRegion': 'CMR00$i',
      'Nombre': 'Comunidad $i',
    });
  }

  // 2. Insertar datos en DatosUsuarios
  for (int i = 1; i <= 20; i++) {
    await db.insert('DatosUsuarios', {
      'id_Comunidad': (i % 5) + 1,
      'nombreCompleto': 'Nombre Completo $i',
      'situacion_Educativa': 'Nivel $i',
      'tipoServicio': 'Servicio $i',
      'contexto': 'Contexto $i',
      'Estado': i % 2 == 0 ? 1 : 0,
    });
  }

  // 3. Insertar datos en Usuarios
  List<String> roles = ['APEC', 'ECAR', 'ECA', 'EC'];
  List<int> apecUsers = [];
  List<int> ecarUsers = [];
  List<int> ecaUsers = [];
  List<int> ecUsers = [];

  for (int i = 1; i <= 20; i++) {
    String role = roles[i % roles.length];
    int userId = await db.insert('Usuarios', {
      'usuario': 'usuario$i',
      'password': 'password$i',
      'rol': role,
      'id_Datos': i,
    });

    if (role == 'APEC') apecUsers.add(userId);
    if (role == 'ECAR') ecarUsers.add(userId);
    if (role == 'ECA') ecaUsers.add(userId);
    if (role == 'EC') ecUsers.add(userId);
  }

  // 4. Insertar datos en Dependencias
  for (int ecarId in ecarUsers) {
    for (int ecaId in ecaUsers) {
      await db.insert('Dependencias', {
        'id_Dependiente': ecaId,
        'id_Responsable': ecarId,
      });
    }
  }

  for (int ecaId in ecaUsers) {
    for (int ecId in ecUsers) {
      await db.insert('Dependencias', {
        'id_Dependiente': ecId,
        'id_Responsable': ecaId,
      });
    }
  }

  for (int ecId in ecUsers) {
    for (int apecId in apecUsers) {
      await db.insert('Dependencias', {
        'id_Dependiente': ecId,
        'id_Responsable': apecId,
      });
    }
  }

  // 5. Insertar datos en Alumnos
  for (int i = 1; i <= 20; i++) {
    await db.insert('Alumnos', {
      'actaNacimiento': await loadPdfFromAssets('acta_nacimiento.pdf'),
      'curp': 'CURP${1000 + i}',
      'fechaNacimiento': formatDate(2010, 1, (i % 28) + 1),
      'lugarNacimiento': 'Lugar $i',
      'domicilio': 'Domicilio $i',
      'municipio': 'Municipio $i',
      'estado': i % 2 == 0 ? 'activo' : 'inactivo',
      'nivelEducativo': 'Primaria',
      'gradoEscolar': 'Grado ${(i % 6) + 1}',
      'certificadoEstudios': await loadPdfFromAssets('certificado_estudios.pdf'),
      'nombrePadre': 'Padre $i',
      'ocupacionPadre': 'Ocupación $i',
      'telefonoPadre': '123456789$i',
      'fotoVacunacion': await loadImageFromAssets('foto_vacunacion.png'),
      'state': ['pendiente', 'aprobado', 'rechazado'][i % 3],
      'nota': 'Nota $i',
      'id_Maestro': ecUsers[i % ecUsers.length],
    });
  }

  // 6. Insertar fechas de pago
  for (int userId in [...apecUsers, ...ecarUsers, ...ecaUsers, ...ecUsers]) {
    for (int i = 1; i <= 5; i++) {
      await db.insert('PagosFechas', {
        'fecha': formatDate(2022, 1, (i % 28) + 1),
        'tipoPago': 'Mensual',
        'monto': (i * 1000).toDouble(),
        'id_Usuario': userId,
      });

      await db.insert('PagosFechas', {
        'fecha': formatDate(2025, 2, (i)),
        'tipoPago': 'Mensual',
        'monto': (i * 1000).toDouble(),
        'id_Usuario': userId,
      });
    }
  }

  // 7. ActCAP
  for (int i = 1; i <= 10; i++) {
    int creatorId = (i % 2 == 0) ? ecarUsers[i % ecarUsers.length] : ecaUsers[i % ecaUsers.length];
    await db.insert('ActCAP', {
      'id_Usuario': creatorId,
      'NumCapacitacion': i,
      'TEMA': 'Tema Capacitación $i',
      'ClaveRegion': 'CR${i}',
      'NombreRegion': 'Región Capacitación $i',
      'FechaProgramada': formatDate(2023, 5, (i % 28) + 1),
      'Estado': ['Pendiente', 'Aprobado', 'Completado'][i % 3],
      'Reporte': 'Reporte de Capacitación $i',
    });
  }

  // 8. Recibo
  for (int i = 1; i <= 20; i++) {
    await db.insert('Recibo', {
      'id_Usuario': ecUsers[i % ecUsers.length],
      'recibo': await loadPdfFromAssets('recibo.pdf'),
      'tipoRecibo': ['Mensual', 'Anual', 'Especial'][i % 3],
    });
  }

  // 9. RegistroMoviliario
  for (int i = 1; i <= 10; i++) {
    await db.insert('RegistroMoviliario', {
      'id_Comunidad': (i % 5) + 1,
      'nombre': 'Mobiliario $i',
      'cantidad': (i % 10) + 1,
      'condicion': ['Bueno', 'Regular', 'Malo'][i % 3],
      'comentarios': 'Comentario sobre el mobiliario $i',
      'periodo': '2023',
      'id_Usuario': apecUsers[i % apecUsers.length],
    });
  }

  // 10. ActividadAcomp
  for (int i = 1; i <= 20; i++) {
    int creatorId = (i % 2 == 0) ? ecarUsers[i % ecarUsers.length] : ecaUsers[i % ecaUsers.length];
    await db.insert('ActividadAcomp', {
      'id_Usuario': creatorId,
      'fecha': formatDate(2023, 2, (i % 28) + 1),
      'hora': '10:00:00',
      'nombreEC': 'Educador Comunitario $i',
      'descripcion': 'Descripción de actividad acompañamiento $i',
      'estado': i % 2 == 0 ? 'activo' : 'inactivo',
    });
  }

  // 11. ReportesAcomp
  for (int i = 1; i <= 20; i++) {
    int creatorId = (i % 2 == 0) ? ecarUsers[i % ecarUsers.length] : ecaUsers[i % ecaUsers.length];
    await db.insert('ReportesAcomp', {
      'reporte': await loadPdfFromAssets('reporte_acomp.pdf'),
      'id_ActividadAcomp': i,
      'fecha': formatDate(2023, 3, (i % 28) + 1),
      'figuraEducativa': 'Figura Educativa $i',
      'id_Usuario': creatorId,
    });
  }

  // 12. Asistencia
  for (int i = 1; i <= 20; i++) {
    int profesorId = apecUsers[i % apecUsers.length];
    await db.insert('Asistencia', {
      'id_Profesor': profesorId,
      'fecha': formatDate(2023, 4, (i % 28) + 1),
      'usuario': 'usuario$i',
      'horaEntrada': '08:${i % 60}:00',
      'horaSalida': '16:${i % 60}:00',
      'Asistencia': i % 2 == 0 ? 1 : 0,
    });
  }

  // 13. Actividad_Alumnos
  for (int i = 1; i <= 20; i++) {
    await db.insert('Actividad_Alumnos', {
      'titulo': 'Actividad $i',
      'descripcion': 'Descripción actividad $i',
      'periodo': '2023-${(i % 12) + 1}-15',
      'materia': 'Materia $i',
      'estado': ['pendiente', 'aprobado', 'rechazado'][i % 3],
    });
  }

  // 14. Calificaciones
  for (int i = 1; i <= 20; i++) {
    await db.insert('Calificaciones', {
      'id_ActAlum': i,
      'id_Alumno': i,
      'calificacion': (i % 10) + 1,
      'observacion': 'Observación $i',
    });
  }

  // 15. Reportes
  for (int i = 1; i <= 20; i++) {
    await db.insert('Reportes', {
      'periodo': 'Periodo $i',
      'estado': ['pendiente', 'aprobado', 'rechazado'][i % 3],
      'reporte': await loadPdfFromAssets('reporte.pdf'),
      'id_usuario': ecUsers[i % ecUsers.length],
    });
  }

  // 16. PromocionFechas
  for (int i = 1; i <= 10; i++) {
    await db.insert('PromocionFechas', {
      'promocionPDF': await loadPdfFromAssets('promocion.pdf'),
      'fechas': '2023-${(i % 12) + 1}-${(i % 28) + 1}',
    });
  }
}
