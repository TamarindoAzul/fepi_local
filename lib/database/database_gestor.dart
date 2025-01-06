import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Conafe.db');

    // Si la base de datos no existe, la crea
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Método que crea las tablas
  Future<void> _onCreate(Database db, int version) async {
    await _createAlumnosTable(db);
    await _createComunidadTable(db);
    await _createUsuariosTable(db);
    await _createDependenciasTable(db);
    await _createDatosUsuariosTable(db);
    await _createReportesTable(db);
    await _createActividadAcompTable(db);
    await _createReportesAcompTable(db);
    await _createAsistenciaTable(db);
    await _createActividadAlumnosTable(db);
    await _createCalificacionesTable(db);
    await _createRegistroMoviliarioTable(db);
    await _createReciboTable(db);
    await _createActCAPTable(db);
    await _createPromocionFechasTable(db);
    await _createFechasPagoTable(db);
    await insertMassiveDataForAllTables(db);
    await printAllTables(db);
  }

  Future<void> _createAlumnosTable(Database db) async {
    await db.execute('''
      CREATE TABLE Alumnos (
        id_Alumno INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Maestro INTEGER,
        actaNacimiento BLOB, -- Archivo PDF
        curp TEXT,
        fechaNacimiento TEXT,
        lugarNacimiento TEXT,
        domicilio TEXT,
        municipio TEXT,
        estado TEXT,
        nivelEducativo TEXT,
        gradoEscolar TEXT,
        certificadoEstudios BLOB, -- Archivo PDF
        nombrePadre TEXT,
        ocupacionPadre TEXT,
        telefonoPadre TEXT,
        fotoVacunacion BLOB, -- Imagen
        state TEXT,
        nota TEXT,
        FOREIGN KEY (id_Maestro) REFERENCES Usuarios(id_Usuario) -- >NO olvides que agregaste este campo papu
      );
    ''');
  }

  Future<void> _createComunidadTable(Database db) async {
    await db.execute('''
      CREATE TABLE Comunidad (
        id_Comunidad INTEGER PRIMARY KEY AUTOINCREMENT,
        claveMicroRegion TEXT,
        Nombre TEXT
      );
    ''');
  }

  Future<void> _createUsuariosTable(Database db) async {
    await db.execute('''
      CREATE TABLE Usuarios (
        id_Usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario TEXT,
        password TEXT,
        rol TEXT,
        id_Datos INTEGER,  -- Columna agregada para la clave foránea
        FOREIGN KEY (id_Datos) REFERENCES DatosUsuarios(id_Datos)
      );
    ''');
  }

  Future<void> _createDependenciasTable(Database db) async {
    await db.execute('''
      CREATE TABLE Dependencias (
        id_Dependencias INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Dependiente INTEGER,
        id_Responsable INTEGER,
        FOREIGN KEY (id_Dependiente) REFERENCES Usuarios(id_Usuario),
        FOREIGN KEY (id_Responsable) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createDatosUsuariosTable(Database db) async {
    await db.execute('''
      CREATE TABLE DatosUsuarios (
        id_Datos INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreCompleto TEXT,
        id_Comunidad INTEGER,
        situacion_Educativa TEXT,
        tipoServicio TEXT,
        contexto TEXT,
        Estado BOOLEAN,
        FOREIGN KEY (id_Comunidad) REFERENCES Comunidad(id_Comunidad)
      );
    ''');
  }

  Future<void> _createReportesTable(Database db) async {
    await db.execute('''
      CREATE TABLE Reportes (
        id_Reporte INTEGER PRIMARY KEY AUTOINCREMENT,
        periodo TEXT,
        estado TEXT,
        reporte BLOB,
        id_usuario INTEGER,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createActividadAcompTable(Database db) async {
    await db.execute('''
      CREATE TABLE ActividadAcomp (
        id_ActividadAcomp INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Usuario INTEGER,
        fecha DATE,
        hora TIME,
        nombreEC TEXT,
        descripcion TEXT,
        estado TEXT,
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createReportesAcompTable(Database db) async {
    await db.execute('''
      CREATE TABLE ReportesAcomp (
        id_ReporteAcomp INTEGER PRIMARY KEY AUTOINCREMENT,
        reporte BLOB,
        id_ActividadAcomp INTEGER,
        fecha DATE,
        figuraEducativa TEXT,
        id_Usuario INTEGER,
        FOREIGN KEY (id_ActividadAcomp) REFERENCES ActividadAcomp(id_ActividadAcomp),
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createAsistenciaTable(Database db) async {
    await db.execute('''
      CREATE TABLE Asistencia (
        id_Asistencia INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Profesor INTEGER,
        fecha DATE,
        usuario TEXT,
        horaEntrada TIME,
        horaSalida TIME,
        Asistencia BOOLEAN,
        FOREIGN KEY (id_Profesor) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createActividadAlumnosTable(Database db) async {
    await db.execute('''
      CREATE TABLE Actividad_Alumnos (
        id_ActAlum INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descripcion TEXT,
        periodo TEXT,
        materia TEXT,
        estado TEXT
      );
    ''');
  }

  Future<void> _createCalificacionesTable(Database db) async {
    await db.execute('''
      CREATE TABLE Calificaciones (
        id_Calf INTEGER PRIMARY KEY AUTOINCREMENT,
        id_ActAlum INTEGER,
        id_Alumno INTEGER,
        calificacion INTEGER,
        observacion TEXT,
        FOREIGN KEY (id_ActAlum) REFERENCES Actividad_Alumnos(id_ActAlum),
        FOREIGN KEY (id_Alumno) REFERENCES Alumnos(id_Alumno)
      );
    ''');
  }

  Future<void> _createRegistroMoviliarioTable(Database db) async {
    await db.execute('''
      CREATE TABLE RegistroMoviliario (
        id_RMoviliario INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Comunidad INTEGER,
        nombre TEXT,
        cantidad INTEGER,
        condicion TEXT,
        comentarios TEXT,
        periodo TEXT,
        id_Usuario INTEGER,
        FOREIGN KEY (id_Comunidad) REFERENCES Comunidad(id_Comunidad),
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createReciboTable(Database db) async {
    await db.execute('''
      CREATE TABLE Recibo (
        id_Recibo INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Usuario INTEGER,
        recibo BLOB,
        tipoRecibo TEXT,
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createActCAPTable(Database db) async {
    await db.execute('''
      CREATE TABLE ActCAP (
        id_ActCAP INTEGER PRIMARY KEY AUTOINCREMENT,
        id_Usuario INTEGER,
        NumCapacitacion INTEGER,
        TEMA TEXT,
        ClaveRegion TEXT,
        NombreRegion TEXT,
        FechaProgramada DATE,
        Estado TEXT,
        Reporte TEXT,
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
      );
    ''');
  }

  Future<void> _createPromocionFechasTable(Database db) async {
    await db.execute('''
      CREATE TABLE PromocionFechas (
        id_PromoFechas INTEGER PRIMARY KEY AUTOINCREMENT,
        promocionPDF BLOB,
        fechas TEXT
      );
    ''');
  }

  Future<void> _createFechasPagoTable(Database db) async {
    await db.execute('''
      CREATE TABLE PagosFechas (
        id_PagoFecha INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha DATE,
        tipoPago TEXT,
        monto real,
        id_Usuario INTEGER,
        FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario) 
      );
    ''');
  }

  Future<void> insertMassiveDataForAllTables(Database db) async {
    // 1. Insertar datos en Comunidad
    for (int i = 1; i <= 5; i++) {
      await db.insert('Comunidad', {
        'claveMicroRegion': 'CMR00$i',
        'Nombre': 'Comunidad $i',
      });
    }

    for (int i = 1; i <= 20; i++) {
      await db.insert('PagosFechas', {
        'fecha': i > 9 ? '2025-01-$i' : '2025-01-0$i',
        'tipoPago': 'a',
        'monto': '2000.20',
        'id_Usuario': 1,
      });
    }

    // 2. Insertar datos en DatosUsuarios
    for (int i = 1; i <= 20; i++) {
      await db.insert('DatosUsuarios', {
        'id_Comunidad': (i % 5) + 1,
        'nombreCompleto': 'Nombre Personal $i',
        'situacion_Educativa': 'Situación $i',
        'tipoServicio': 'Servicio $i',
        'contexto': 'Contexto $i',
        'Estado': i % 2 == 0 ? 1 : 0,
      });
    }

    // 3. Insertar datos en Usuarios
    List<String> roles = ['EC', 'ECAR', 'ECA', 'APEC'];
    List<int> ecUsers = [];
    List<int> ecarUsers = [];
    for (int i = 1; i <= 20; i++) {
      String role = roles[i % roles.length];
      int userId = await db.insert('Usuarios', {
        'usuario': 'usuario$i',
        'password': 'password$i',
        'rol': role,
        'id_Datos': i,
      });

      if (role == 'EC') ecUsers.add(userId);
      if (role == 'ECAR') ecarUsers.add(userId);
    }

    // 4. Insertar datos en Dependencias
    for (int ecId in ecUsers) {
      for (int ecarId in ecarUsers) {
        await db.insert('Dependencias', {
          'id_Dependiente': ecId,
          'id_Responsable': ecarId,
        });
      }
    }

    for (int ecaId in ecarUsers) {
      await db.insert('Dependencias', {
        'id_Dependiente': ecaId,
        'id_Responsable': ecUsers[ecaId % ecUsers.length],
      });
    }

    // 5. Insertar datos en Alumnos
    for (int i = 1; i <= 20; i++) {
      await db.insert('Alumnos', {
        'actaNacimiento': null,
        'curp': 'CURP$i',
        'fechaNacimiento': '200$i-01-01',
        'lugarNacimiento': 'Lugar $i',
        'domicilio': 'Domicilio $i',
        'municipio': 'Municipio $i',
        'estado': 'Estado $i',
        'nivelEducativo': 'Nivel $i',
        'gradoEscolar': 'Grado $i',
        'certificadoEstudios': null,
        'nombrePadre': 'Padre $i',
        'ocupacionPadre': 'Ocupación $i',
        'telefonoPadre': '12345678$i',
        'fotoVacunacion': null,
        'state': 'Activo',
        'nota': 'Nota $i',
        'id_Maestro': (i % 20) + 1,
      });
    }

    // 6. Insertar datos en ActividadAcomp
    for (int i = 1; i <= 20; i++) {
      await db.insert('ActividadAcomp', {
        'id_Usuario': (i % 20) + 1,
        'fecha': '2024-01-01',
        'hora': '10:00:00',
        'nombreEC': 'Educador Comunitario $i',
        'descripcion': 'Actividad $i',
        'estado': i % 2 == 0 ? 'activo' : 'inactivo',
      });
    }

    // 7. Insertar datos en Reportes
    for (int i = 1; i <= 20; i++) {
      await db.insert('Reportes', {
        'periodo': 'Periodo $i',
        'estado': i % 2 == 0 ? 'Aprobado' : 'Pendiente',
        'reporte': null,
        'id_usuario': i,
      });
    }

    // 8. Insertar datos en Calificaciones
    for (int i = 1; i <= 20; i++) {
      await db.insert('Calificaciones', {
        'id_ActAlum': (i % 10) + 1,
        'id_Alumno': (i % 20) + 1,
        'calificacion': (i % 10) + 1,
        'observacion': 'Observación $i',
      });
    }

    // 9. Insertar datos en RegistroMoviliario
    for (int i = 1; i <= 10; i++) {
      await db.insert('RegistroMoviliario', {
        'id_Comunidad': (i % 5) + 1,
        'nombre': 'Mobiliario $i',
        'cantidad': i * 10,
        'condicion': i % 2 == 0 ? 'Bueno' : 'Regular',
        'comentarios': 'Comentario $i',
        'periodo': '2024',
        'id_Usuario': (i % 20) + 1,
      });
    }

    // 10. Insertar datos en ReportesAcomp
    for (int i = 1; i <= 20; i++) {
      await db.insert('ReportesAcomp', {
        'reporte': 'Juan',
        'id_ActividadAcomp': (i % 20) + 1,
        'fecha': i<9? '2024-02-0$i':'2024-02-$i',
        'figuraEducativa': 'Figura $i',
        'id_Usuario': (i % 20) + 1,
      });
    }

    // 11. Insertar datos en Asistencia
    for (int i = 1; i <= 10; i++) {
      await db.insert('Asistencia', {
        'id_Profesor': (i % 20) + 1,
        'fecha': '2024-01-0$i',
        'usuario': 'usuario$i',
        'horaEntrada': '08:0$i:00',
        'horaSalida': '16:0$i:00',
        'Asistencia': i % 2 == 0 ? 1 : 0,
      });
    }

    // 12. Insertar datos en Actividad_Alumnos
    for (int i = 1; i <= 10; i++) {
      await db.insert('Actividad_Alumnos', {
        'titulo': 'Actividad $i',
        'descripcion': 'Descripción de actividad $i',
        'periodo': '2024',
        'materia': 'Materia $i',
        'estado': i % 2 == 0 ? 'Completado' : 'Pendiente',
      });
    }

    // 13. Insertar datos en Recibo
    for (int i = 1; i <= 10; i++) {
      await db.insert('Recibo', {
        'id_Usuario': (i % 20) + 1,
        'recibo': null,
        'tipoRecibo': 'Tipo $i',
      });
    }

    // 14. Insertar datos en ActCAP
    for (int i = 1; i <= 10; i++) {
      await db.insert('ActCAP', {
        'id_Usuario': (i % 20) + 1,
        'NumCapacitacion': i,
        'TEMA': 'Tema $i',
        'ClaveRegion': 'CR$i',
        'NombreRegion': 'Región $i',
        'FechaProgramada': i<9? '2024-02-0$i':'2024-02-$i',
        'Estado': 'Pendiente',
        'Reporte': 'Reporte $i',
      });
    }
    // 15. Insertar datos en PEPE
    for (int i = 1; i <= 20; i++) {
      await db.insert('PromocionFechas', {
        'promocionPDF':Uint8List.fromList(utf8.encode('Archivo')),
        'fechas': '2025-01-01,2025-01-02,2025-01-03,2025-01-04,'
      });
    }
    }

  Future<void> printAllTables(Database db) async {
    // Obtener el nombre de todas las tablas en la base de datos
    List<Map<String, dynamic>> tables = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");

    for (var table in tables) {
      String tableName = table['name'];

      // Obtener los registros de la tabla
      List<Map<String, dynamic>> rows = await db.query(tableName);

      print('=== Tabla: $tableName ===');
      if (rows.isEmpty) {
        print('No hay datos en esta tabla.');
      } else {
        for (var row in rows) {
          print(row);
        }
      }
      print('\n');
    }
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /// Valida el usuario y contraseña
  Future<Map<String, dynamic>?> validarUsuario(
      String usuario, String password) async {
    final db = await database;

    // Consulta a la base de datos
    final List<Map<String, dynamic>> result = await db.query(
      'Usuarios',
      columns: ['id_Usuario', 'rol'],
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password],
      limit: 1,
    );

    // Si hay un resultado, retornamos el id_Usuario y rol
    if (result.isNotEmpty) {
      print(result);
      return {
        'id_Usuario': result.first['id_Usuario'],
        'rol': result.first['rol'],
      };
    }

    // Si no se encuentra nada, retornamos null
    return null;
  }

  /// Obtiene la ubicación (municipio y estado) de un usuario por su ID
  Future<Map<String, String>?> getUbicacionPorUsuario(int idUsuario) async {
    final db =
        await database; // Carga la base de datos a través de la propiedad `database`

    // Realiza la consulta para obtener la ubicación del usuario
    final List<Map<String, dynamic>> result = await db.rawQuery('''
    SELECT 
      Comunidad.claveMicroRegion,
      Comunidad.Nombre
    FROM Usuarios
    INNER JOIN DatosUsuarios ON Usuarios.id_Datos = DatosUsuarios.id_Datos
    INNER JOIN Comunidad ON DatosUsuarios.id_Comunidad = Comunidad.id_Comunidad
    WHERE Usuarios.id_Usuario = ?
  ''', [idUsuario]);

    // Si no hay resultados, retorna null
    if (result.isEmpty) {
      return null;
    }

    // Retorna el municipio y estado como un mapa
    return {
      'clave': result.first['claveMicroRegion'] as String,
      'nombre': result.first['Nombre'] as String,
    };
  }

  Future<List<Map<String, dynamic>>> getResponsablesPorUsuario(
      int idUsuario) async {
    // Obtén una referencia a la base de datos
    final db = await database;

    // Paso 1: Consulta los IDs de los responsables
    final List<Map<String, dynamic>> dependencias = await db.rawQuery('''
    SELECT id_Responsable
    FROM Dependencias
    WHERE id_Dependiente = ?
  ''', [idUsuario]);

    if (dependencias.isEmpty) {
      return []; // Retorna lista vacía si no hay responsables
    }

    // Extrae los IDs de los responsables como una lista
    final List<int> responsablesIds =
        dependencias.map((e) => e['id_Responsable'] as int).toList();

    // Verifica que la lista no esté vacía antes de construir la consulta
    if (responsablesIds.isEmpty) {
      return [];
    }

    // Paso 2: Construcción de la consulta para obtener los datos de los responsables
    final List<Map<String, dynamic>> responsablesData = await db.rawQuery('''
    SELECT 
      Usuarios.id_Usuario AS id,
      DatosUsuarios.nombreCompleto AS Nombre, -- Asegúrate de que el nombre es correcto
      Usuarios.rol AS Rol,
      Comunidad.claveMicroRegion AS Ubicacion,
      DatosUsuarios.situacion_Educativa AS Situacion,
      DatosUsuarios.tipoServicio AS tipoServicio,
      DatosUsuarios.contexto AS Contexto,
      CASE DatosUsuarios.Estado WHEN 1 THEN 'Activo' ELSE 'Inactivo' END AS Estatus
    FROM Usuarios
    INNER JOIN DatosUsuarios ON Usuarios.id_Datos = DatosUsuarios.id_Datos
    INNER JOIN Comunidad ON DatosUsuarios.id_Comunidad = Comunidad.id_Comunidad
    WHERE Usuarios.id_Usuario IN (${responsablesIds.join(', ')})
  ''');

    // Retorna los datos de los responsables
    return responsablesData;
  }

  Future<List<Map<String, dynamic>>> cargarAlumnosPorMaestro(
      int idMaestro) async {
    final db = await database;

    final List<Map<String, dynamic>> alumnos = await db.query(
      'Alumnos',
      where: 'id_Maestro = ?',
      whereArgs: [idMaestro],
    );

    return alumnos;
  }

  Future<List<Map<String, dynamic>>> cargarAlumnosDeResponsables(
      int idUsuario) async {
    final db = await database;

    // Obtener los usuarios dependientes del maestro
    final List<Map<String, dynamic>> dependientes = await db.query(
      'Dependencias',
      columns: ['id_Dependiente'],
      where: 'id_Responsable = ?',
      whereArgs: [idUsuario],
    );

    if (dependientes.isEmpty) {
      return []; // Si no hay dependientes, retorna una lista vacía
    }

    // Extraer los IDs de los usuarios dependientes
    final List<int> idsDependientes =
        dependientes.map((e) => e['id_Dependiente'] as int).toList();

    // Crear una consulta para obtener los datos de los alumnos relacionados
    final List<Map<String, dynamic>> alumnos = await db.query(
      'Alumnos',
      where: 'id_Maestro IN (${idsDependientes.map((_) => '?').join(', ')})',
      whereArgs: idsDependientes,
    );

    return alumnos;
  }

  // Método para actualizar un solo parámetro en la tabla AlumnosAlta según su CURP
  Future<int> actualizarParametroAlumnoPorCURP(
      String curp, String parametro, dynamic valor) async {
    final db = await database;
    return await db.update(
      'Alumnos',
      {parametro: valor},
      where: 'curp = ?',
      whereArgs: [curp],
    );
  }

  Future<void> insertarAlumno(Map<String, dynamic> alumno) async {
    final db = await database;

    // Procesar y convertir archivos a bytes si existen
    Uint8List? actaNacimientoBytes =
        await _leerArchivoComoBytes(alumno['actaNacimiento']);
    Uint8List? certificadoEstudiosBytes =
        await _leerArchivoComoBytes(alumno['certificadoEstudios']);
    Uint8List? fotoVacunacionBytes =
        await _leerArchivoComoBytes(alumno['fotoVacunacion']);

    // Preparar los datos para insertar
    final Map<String, dynamic> datosAlumno = {
      'actaNacimiento': actaNacimientoBytes,
      'curp': alumno['curp'] ?? '',
      'fechaNacimiento': alumno['fechaNacimiento'] ?? '',
      'lugarNacimiento': alumno['lugarNacimiento'] ?? '',
      'domicilio': alumno['domicilio'] ?? '',
      'municipio': alumno['municipio'] ?? '',
      'estado': alumno['estado'] ?? '',
      'nivelEducativo': alumno['nivelEducativo'] ?? '',
      'gradoEscolar': alumno['gradoEscolar'] ?? '',
      'certificadoEstudios': certificadoEstudiosBytes,
      'nombrePadre': alumno['nombrePadre'] ?? '',
      'ocupacionPadre': alumno['ocupacionPadre'] ?? '',
      'telefonoPadre': alumno['telefonoPadre'] ?? '',
      'fotoVacunacion': fotoVacunacionBytes,
      'state': alumno['state'],
      'nota': alumno['nota'],
      'id_Maestro': alumno['id_Maestro']
    };

    // Insertar en la base de datos
    await db.insert('Alumnos', datosAlumno);
  }

  Future<Uint8List?> _leerArchivoComoBytes(dynamic archivo) async {
    if (archivo == null) return null;
    if (archivo is File) {
      return await archivo.readAsBytes();
    } else {
      throw ArgumentError('El archivo debe ser de tipo File o null');
    }
  }






  Future<List<Map<String, dynamic>>> obtenerHistorialEnviosPorUsuario(
      int idUsuario) async {
    // Abre la base de datos
    final db = await database;

    // Realiza la consulta a la tabla Reportes
    final List<Map<String, dynamic>> resultado = await db.query(
      'Reportes',
      columns: ['periodo', 'reporte', 'estado'],
      where: 'id_usuario = ?',
      whereArgs: [idUsuario],
    );

    // Transforma los datos para que sean compatibles con historialEnvios
    final List<Map<String, dynamic>> historialEnvios = resultado.map((fila) {
      return {
        'Periodo': fila['periodo'] as String,
        'Reporte': fila['reporte'] ,
        'Estado': fila['estado'] as String,
      };
    }).toList();
    print('************************************************$historialEnvios');
    return historialEnvios;
  }

  Future<void> insertarReporte(Map<String, dynamic> reporte) async {
    final db = await database;
    // Prepara los valores que se insertarán en la tabla Reportes
    final Map<String, dynamic> valores = {
      'Periodo': reporte['Periodo'],
      'Estado': reporte['Estado'],
      'Reporte': reporte['Reporte'],
      'id_usuario': reporte['id_usuario'],
    };

    // Inserta el registro en la tabla Reportes
    await db.insert(
      'Reportes',
      valores,
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Para manejar conflictos si el ID ya existe
    );
    print(">>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< jalo pau");
  }

  Future<Map<String, List<Map<String, dynamic>>>> obtenerPagosPorUsuario(
      int idUsuario) async {
    final db = await database;
    // Realizamos la consulta a la base de datos buscando las fechas de pago por usuario
    final List<Map<String, dynamic>> results = await db.query(
      'PagosFechas',
      where: 'id_Usuario = ?',
      whereArgs: [idUsuario],
    );

    // Creamos el Map que contendrá las fechas de pago organizadas por fecha
    Map<String, List<Map<String, dynamic>>> pagosPorFecha = {};

    // Iteramos sobre los resultados y organizamos los pagos por fecha
    for (var row in results) {
      String fecha =
          row['fecha']; // La fecha es un String en formato 'yyyy-MM-dd'
      String tipoPago = row['tipoPago'];
      double monto = row['monto'];

      // Si no existe la fecha en el Map, la inicializamos con una lista vacía
      if (!pagosPorFecha.containsKey(fecha)) {
        pagosPorFecha[fecha] = [];
      }

      // Agregamos el pago correspondiente a esa fecha
      pagosPorFecha[fecha]?.add({
        'tipopago': tipoPago,
        'monto': monto,
      });
    }

    // Devolvemos el mapa con los pagos organizados por fecha
    return pagosPorFecha;
  }

  Future<void> insertarDatosActCAP(Map<String, dynamic> datos) async {
    // Obtén la referencia a la base de datos
    final db = await database;

    // Asegúrate de que el mapa de datos contenga los valores correctos
    final Map<String, dynamic> dataToInsert = {
      'id_Usuario':
          datos['id_Usuario'], // Asegúrate de pasar el id_Usuario correspondiente
      'NumCapacitacion': datos['NumCapacitacion'],
      'TEMA': datos['TEMA'],
      'ClaveRegion': datos['ClaveRegion'],
      'NombreRegion':
          datos['NombreRegion'], // Asumí que 'Region' es 'NombreRegion' en la tabla
      'FechaProgramada': datos['FechaProgramada'],
      'Estado': datos['Estado'],
      'Reporte': datos['Reporte'],
    };
    print(dataToInsert);
    // Realiza la inserción en la tabla ActCAP
    await db.insert(
      'ActCAP',
      dataToInsert,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Define el comportamiento ante conflictos
    );
    print('SI jala x2');
  }

  Future<List<Map<String, dynamic>>> obtenerActividadesCAPPorUsuario(
      int idUsuario) async {
    final db = await database; // Aquí debes usar tu base de datos

    // Ejecuta la consulta para obtener los registros que coincidan con el id_Usuario
    final List<Map<String, dynamic>> resultado = await db.rawQuery('''
    SELECT * FROM ActCAP WHERE id_Usuario = ?;
  ''', [idUsuario]);

    return resultado;
  }

Future<int> editarActividad(Map<String, dynamic> actividad) async {
  final db = await database;

  // Actualizamos solo los campos que recibimos
  return await db.update(
    'ActCAP',
    {
      'Estado': actividad['Estado'], // Actualiza el estado
      'Reporte': actividad['Reporte'], // Actualiza el reporte
    },
    where: 'id_ActCAP = ?', 
    whereArgs: [actividad['id_ActCAP']], // Filtra por id_ActCAP
  );
}

  
 Future<Map<String, Map<String, dynamic>>> obtenerDependientesPorUsuario(int idUsuario) async {
  final db = await database;

  // Ajustamos la consulta SQL para incluir la tabla Usuarios y su relación con DatosUsuarios
  final dependientes = await db.rawQuery('''
    SELECT du.nombreCompleto, d.id_Dependiente
    FROM Dependencias d
    INNER JOIN Usuarios u ON u.id_Usuario = d.id_Dependiente
    INNER JOIN DatosUsuarios du ON du.id_Datos = u.id_Datos
    WHERE d.id_Responsable = ?
  ''', [idUsuario]);

  Map<String, Map<String, dynamic>> dependientesMap = {};

  for (var dependiente in dependientes) {
    String? nombreCompleto = dependiente['nombreCompleto'] as String?;
    if (nombreCompleto != null) {
      dependientesMap[nombreCompleto] = {
        'id_Maestro': dependiente['id_Dependiente'], // Se mantiene el ID del dependiente
        'asistencia': false,
        'entrada': null,
        'salida': null,
      };
    }
  }

  return dependientesMap;
}


Future<void> insertarAsistencia(List<Map<String, dynamic>> registrosAsistencia, String usuario) async {
  final db = await database;
  for (var registro in registrosAsistencia) {
    await db.insert(
      'Asistencia',
      {
        'id_Profesor': registro['id_Profesor'],
        'fecha': registro['fecha'], // Solo fecha (YYYY-MM-DD)
        'usuario': usuario,
        'horaEntrada': registro['entrada'] ?? null,
        'horaSalida': registro['salida'] ?? null,
        'Asistencia': registro['asistencia'] ? 1 : 0, // Convertimos el booleano a entero
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

Future<Map<String, List<Map<String, dynamic>>>> obtenerActividadesPorUsuario(int idUsuario) async {
   final db= await database;
    // Realizar la consulta para obtener las actividades relacionadas con el id_Usuario
    final List<Map<String, dynamic>> actividades = await db.query(
      'ActividadAcomp',
      where: 'id_Usuario = ?',
      whereArgs: [idUsuario],
    );

    // Crear un Map<String, List<Map<String, dynamic>>> con los datos obtenidos
    Map<String, List<Map<String, dynamic>>> eventos = {};

    for (var actividad in actividades) {
      String fecha = actividad['fecha'] ?? '';
      if (eventos[fecha] == null) {
        eventos[fecha] = [];
      }

      eventos[fecha]!.add({
        'id_ActividadAcomp': actividad['id_ActividadAcomp'],
        'fecha': actividad['fecha'],
        'hora': actividad['hora'],
        'nombreEC': actividad['nombreEC'],
        'descripcion': actividad['descripcion'],
        'estado': actividad['estado'],
      });
    }

    return eventos;
  }

  Future<void> insertarActividad(Map<String, dynamic> actividad) async {
  // Obtener la instancia de la base de datos
  final Database db = await database;

  // Insertar la nueva actividad en la tabla 'ActividadAcomp'
  await db.insert(
    'ActividadAcomp',
    actividad,
    conflictAlgorithm: ConflictAlgorithm.replace, // Reemplazar en caso de conflicto
  );

  print("Actividad insertada: $actividad");
}

Future<void> eliminarActividad(int idActividad) async {
  // Obtener la instancia de la base de datos
  final Database db = await database;

  // Eliminar la actividad de la tabla 'ActividadAcomp' basada en el id_Actividad
  await db.delete(
    'ActividadAcomp',
    where: 'id_ActividadAcomp = ?',
    whereArgs: [idActividad],
  );

  print("Actividad eliminada con id: $idActividad");
}
  

Future<void> editarActividadAcomp(Map<String, dynamic> actividad) async {
  // Obtener la instancia de la base de datos
  final Database db = await database;

  // Verificar que 'id_ActividadAcomp' no sea null
  final idActividad = actividad['id_ActividadAcomp'];
  if (idActividad == null) {
    print('Error: id_ActividadAcomp es null, no se puede editar la actividad');
    return;
  }

  // Actualizar la actividad en la tabla 'ActividadAcomp'
  await db.update(
    'ActividadAcomp',
    {
      'fecha': actividad['fecha'],
      'hora': actividad['hora'],
      'nombreEC': actividad['nombreEC'],
      'descripcion': actividad['descripcion'],
      'estado': actividad['estado'],
    },
    where: 'id_ActividadAcomp = ?',
    whereArgs: [idActividad],
  );

  print("Actividad editada: $actividad");
}

Future<void> cambiarEstadoYRegistrarReporte( int idActividad, int idUsuario, String reporte, String figura) async {
  final db= await database;
  try {
    // 1. Cambiar el estado de la actividad a "inactivo"
    await db.update(
      'ActividadAcomp',
      {'estado': 'inactivo'},  // Se actualiza el estado a 'inactivo'
      where: 'id_ActividadAcomp = ?',
      whereArgs: [idActividad],  // Pasamos el id de la actividad
    );

    // 2. Insertar un nuevo reporte en la tabla ReportesAcomp
    await db.insert(
      'ReportesAcomp',
      {
        'reporte': reporte,  // El contenido del reporte
        'id_ActividadAcomp': idActividad,  // Relacionamos el reporte con la actividad
        'fecha': DateTime.now().toIso8601String(),  // Fecha del reporte
        'figuraEducativa': figura,  // Esto puede ser personalizado
        'id_Usuario': idUsuario,  // Usuario que genera el reporte
      },
      conflictAlgorithm: ConflictAlgorithm.replace,  // En caso de conflicto, se reemplaza el registro
    );

    print('Estado de la actividad actualizado y reporte agregado exitosamente.');
  } catch (e) {
    print('Error al cambiar el estado o agregar el reporte: $e');
  }
}

Future<Map<String, Map<String, String>>> obtenerActividadesPorNombreEC(String nombreEC) async {
  final db = await database;

  // Realizar la consulta para obtener las actividades relacionadas con el nombreEC
  final List<Map<String, dynamic>> actividades = await db.query(
    'ActividadAcomp',
    where: 'nombreEC = ?',
    whereArgs: [nombreEC],
  );

  // Crear un Map<String, Map<String, String>> con las actividades
  Map<String, Map<String, String>> actividadesMap = {};

  // Iterar sobre las actividades y agregar al Map con una clave genérica
  for (int i = 0; i < actividades.length; i++) {
    actividadesMap['Actividad ${i + 1}'] = {
      'Descripcion': actividades[i]['descripcion'] ?? '',
      'Fecha': actividades[i]['fecha'] ?? '',
      'Estado': actividades[i]['estado'] ?? '',
    };
  }

  return actividadesMap;
}



Future<Map<String, Map<String, String>>> obtenerReportesPorUsuario(int idUsuario) async {
  // Obtener la instancia de la base de datos
  final Database db = await database;

  // Consultar los reportes de los usuarios dependientes del usuario dado
  final List<Map<String, dynamic>> resultados = await db.rawQuery('''
    SELECT 
      ReportesAcomp.id_ReporteAcomp AS idReporte,
      ReportesAcomp.reporte AS reporte,
      ActividadAcomp.descripcion AS actividad,
      ReportesAcomp.figuraEducativa AS figuraEducativa,
      ReportesAcomp.fecha AS fecha
    FROM 
      ReportesAcomp
    INNER JOIN 
      Dependencias ON Dependencias.id_Dependiente = ReportesAcomp.id_Usuario
    INNER JOIN 
      Usuarios ON Usuarios.id_Usuario = Dependencias.id_Dependiente
    INNER JOIN 
      ActividadAcomp ON ActividadAcomp.id_ActividadAcomp = ReportesAcomp.id_ActividadAcomp
    WHERE 
      Dependencias.id_Responsable = ?
  ''', [idUsuario]);

  // Convertir los resultados en el mapa deseado
  Map<String, Map<String, String>> reportesMap = {};
  for (var resultado in resultados) {
    String id = resultado['idReporte'].toString();
    reportesMap[id] = {
      'Reporte': resultado['reporte'],
      'Actividad': resultado['actividad'],
      'Fe': resultado['figuraEducativa'],
      'Fecha': resultado['fecha']
    };
  }

  return reportesMap;
}


Future<Map<String, dynamic>> getPromocionFechasById(int idPromoFechas) async {
  final db= await database;
  // Realiza la consulta para obtener los datos de la tabla 'PromocionFechas' basado en 'id_PromoFechas'
  List<Map<String, dynamic>> result = await db.query(
    'PromocionFechas',
    where: 'id_PromoFechas = ?',
    whereArgs: [idPromoFechas],
  );

  // Si se encuentra el resultado, retorna el primer registro (ya que se espera que sea único por ID)
  if (result.isNotEmpty) {
    return result.first; // Retorna el primer mapa con los datos
  } else {
    throw Exception('No se encontró la promoción con id_PromoFechas: $idPromoFechas');
  }
}


}
