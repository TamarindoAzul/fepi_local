import 'package:mysql1/mysql1.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  // Configuración para conectarse a la base de datos MySQL en la nube
  static final ConnectionSettings settings = ConnectionSettings(
    host: '34.118.149.167', // IP pública de Google Cloud
    port: 3306,             // Puerto configurado
    user: 'root',           // Usuario de la base de datos
    password: '1234567890', // Contraseña
    db: 'conafe_motor',     // Nombre de la base de datos
  );

  static const Map<String, String> tableMapping = {
  'Alumnos': 'alumnos_movil',
  'Comunidad': 'comunidad_movil',
  'Usuarios': 'usuarios_movil',
  'Dependencias': 'dependencias_movil',
  'DatosUsuarios': 'datos_usuarios_movil',
  'Reportes': 'reportes_movil',
  'ActividadAcomp': 'actividad_acomp_movil',
  'ReportesAcomp': 'reportes_acomp_movil',
  'Asistencia': 'asistencia_movil',
  'Actividad_Alumnos': 'actividad_alumnos_movil',
  'Calificaciones': 'calificaciones_movil',
  'RegistroMoviliario': 'registro_moviliario_movil',
  'Recibo': 'recibo_movil',
  'ActCAP': 'act_cap_movil',
  'PromocionFechas': 'promocion_fechas_movil',
  'PagosFechas': 'pagos_fechas_movil',
};


  // Base de datos local SQLite
  static Database? _localDb;

  Future<Database> get localDb async {
    if (_localDb != null) return _localDb!;
    _localDb = await _initLocalDatabase();
    return _localDb!;
  }

  Future<Database> _initLocalDatabase() async {
    String path = join(await getDatabasesPath(), 'Conafe.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''CREATE TABLE Alumnos (
      id_Alumno INTEGER PRIMARY KEY AUTOINCREMENT,
      id_Maestro INTEGER,
      actaNacimiento BLOB,
      curp TEXT,
      fechaNacimiento TEXT,
      lugarNacimiento TEXT,
      domicilio TEXT,
      municipio TEXT,
      estado TEXT,
      nivelEducativo TEXT,
      gradoEscolar TEXT,
      certificadoEstudios BLOB,
      nombrePadre TEXT,
      ocupacionPadre TEXT,
      telefonoPadre TEXT,
      fotoVacunacion BLOB,
      state TEXT,
      nota TEXT,
      FOREIGN KEY (id_Maestro) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE Comunidad (
      id_Comunidad INTEGER PRIMARY KEY AUTOINCREMENT,
      claveMicroRegion TEXT,
      Nombre TEXT
    )''');
    await db.execute('''CREATE TABLE Usuarios (
      id_Usuario INTEGER PRIMARY KEY AUTOINCREMENT,
      usuario TEXT,
      password TEXT,
      rol TEXT,
      id_Datos INTEGER,
      FOREIGN KEY (id_Datos) REFERENCES DatosUsuarios(id_Datos)
    )''');
    await db.execute('''CREATE TABLE Dependencias (
      id_Dependencias INTEGER PRIMARY KEY AUTOINCREMENT,
      id_Dependiente INTEGER,
      id_Responsable INTEGER,
      FOREIGN KEY (id_Dependiente) REFERENCES Usuarios(id_Usuario),
      FOREIGN KEY (id_Responsable) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE DatosUsuarios (
      id_Datos INTEGER PRIMARY KEY AUTOINCREMENT,
      nombreCompleto TEXT,
      id_Comunidad INTEGER,
      situacion_Educativa TEXT,
      tipoServicio TEXT,
      contexto TEXT,
      Estado BOOLEAN,
      FOREIGN KEY (id_Comunidad) REFERENCES Comunidad(id_Comunidad)
    )''');
    await db.execute('''CREATE TABLE Reportes (
      id_Reporte INTEGER PRIMARY KEY AUTOINCREMENT,
      periodo TEXT,
      estado TEXT,
      reporte BLOB,
      id_usuario INTEGER,
      FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE ActividadAcomp (
      id_ActividadAcomp INTEGER PRIMARY KEY AUTOINCREMENT,
      id_Usuario INTEGER,
      fecha DATE,
      hora TIME,
      nombreEC TEXT,
      descripcion TEXT,
      estado TEXT,
      FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE ReportesAcomp (
      id_ReporteAcomp INTEGER PRIMARY KEY AUTOINCREMENT,
      reporte BLOB,
      id_ActividadAcomp INTEGER,
      fecha DATE,
      figuraEducativa TEXT,
      id_Usuario INTEGER,
      FOREIGN KEY (id_ActividadAcomp) REFERENCES ActividadAcomp(id_ActividadAcomp),
      FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE Asistencia (
      id_Asistencia INTEGER PRIMARY KEY AUTOINCREMENT,
      id_Profesor INTEGER,
      fecha DATE,
      usuario TEXT,
      horaEntrada TIME,
      horaSalida TIME,
      Asistencia BOOLEAN,
      FOREIGN KEY (id_Profesor) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE Actividad_Alumnos (
      id_ActAlum INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo TEXT,
      descripcion TEXT,
      periodo TEXT,
      materia TEXT,
      estado TEXT
    )''');
    await db.execute('''CREATE TABLE Calificaciones (
      id_Calf INTEGER PRIMARY KEY AUTOINCREMENT,
      id_ActAlum INTEGER,
      id_Alumno INTEGER,
      calificacion INTEGER,
      observacion TEXT,
      FOREIGN KEY (id_ActAlum) REFERENCES Actividad_Alumnos(id_ActAlum),
      FOREIGN KEY (id_Alumno) REFERENCES Alumnos(id_Alumno)
    )''');
    await db.execute('''CREATE TABLE RegistroMoviliario (
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
    )''');
    await db.execute('''CREATE TABLE Recibo (
      id_Recibo INTEGER PRIMARY KEY AUTOINCREMENT,
      id_Usuario INTEGER,
      recibo BLOB,
      tipoRecibo TEXT,
      FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
    )''');
    await db.execute('''CREATE TABLE ActCAP (
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
    )''');
    await db.execute('''CREATE TABLE PromocionFechas (
      id_PromoFechas INTEGER PRIMARY KEY AUTOINCREMENT,
      promocionPDF BLOB,
      fechas TEXT
    )''');
    await db.execute('''CREATE TABLE PagosFechas (
      id_PagoFecha INTEGER PRIMARY KEY AUTOINCREMENT,
      fecha DATE,
      tipoPago TEXT,
      monto REAL,
      id_Usuario INTEGER,
      FOREIGN KEY (id_Usuario) REFERENCES Usuarios(id_Usuario)
    )''');
  }

  // Verificar conexión a internet
  Future<bool> _isConnectedToInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Descargar datos desde la nube y actualizar SQLite local
  Future<void> _syncFromCloud(String localTable) async {
  final db = await localDb;
  final cloudTable = tableMapping[localTable] ?? localTable;

  if (await _isConnectedToInternet()) {
    final conn = await MySqlConnection.connect(settings);
    try {
      final results = await conn.query('SELECT * FROM $cloudTable');
      await db.transaction((txn) async {
        // Borrar y reemplazar datos (si es necesario)
        await txn.delete(localTable);

        for (var row in results) {
          // Convertir los datos a un formato compatible con SQLite
          Map<String, dynamic> mappedRow = {};

          row.fields.forEach((key, value) {
            // Transformación de datos según el tipo
            if (value is DateTime) {
              // Convertir fechas a formato texto (ISO 8601)
              
              mappedRow[key] = value.toIso8601String().toString().substring(0, 10);
            } else if (value is int || value is double || value is String) {
              // Dejar int, double y string tal cual
              mappedRow[key] = value;
            } else if (value is bool) {
              // Convertir booleanos a 0 (false) o 1 (true)
              mappedRow[key] = value ? 1 : 0;
            } else if (value == null) {
              // Manejar valores nulos
              mappedRow[key] = null;
            } else {
              // Para tipos desconocidos, convertir a String
              mappedRow[key] = value.toString();
            }
          });

          // Insertar el registro en la base de datos local
          await txn.insert(localTable, mappedRow);
        }
      });
      print('Datos sincronizados desde la nube para tabla $localTable.');
    } catch (e) {
      print('Error al sincronizar desde la nube: $e');
    } finally {
      await conn.close();
    }
  } else {
    print('Sin conexión a internet. Sincronización no realizada para $localTable.');
  }
}


// Subir datos de SQLite local a la nube
Future<void> _syncToCloud(String localTable) async {
  final db = await localDb;
  final cloudTable = tableMapping[localTable] ?? localTable;

  if (await _isConnectedToInternet()) {
    final conn = await MySqlConnection.connect(settings);
    try {
      final localData = await db.rawQuery('SELECT * FROM $localTable');
      for (var row in localData) {
        final columns = row.keys.toList();
        final values = row.values.toList();
        final placeholders = List.generate(columns.length, (_) => '?').join(',');

        final query = '''
          INSERT INTO $cloudTable (${columns.join(',')}) 
          VALUES ($placeholders)
          ON DUPLICATE KEY UPDATE ${columns.map((col) => '$col = VALUES($col)').join(',')}
        ''';

        await conn.query(query, values);
      }
      print('Datos sincronizados a la nube para tabla $localTable.');
    } catch (e) {
      print('Error al sincronizar hacia la nube: $e');
    } finally {
      await conn.close();
    }
  } else {
    print('Sin conexión a internet. Sincronización no realizada para $localTable.');
  }
}



  // Sincronizar tabla específica (bidireccionalmente)
  Future<void> syncTable(String tableName) async {
    print('Sincronizando tabla $tableName...');
    await _syncToCloud(tableName);
    await _syncFromCloud(tableName);
    
    print('Sincronización de tabla $tableName completada.');
  }

  // Sincronizar todas las tablas
  Future<void> syncAllTables() async {
    print('Iniciando sincronización bidireccional de todas las tablas...');
    await syncTable('Comunidad');
    await syncTable('DatosUsuarios');
    await syncTable('Usuarios');
    await syncTable('Dependencias');
    await syncTable('Alumnos');
    await syncTable('ActividadAcomp');
    await syncTable('Reportes');
    await syncTable('Calificaciones');
    await syncTable('RegistroMoviliario');
    await syncTable('ReportesAcomp');
    await syncTable('Asistencia');
    await syncTable('Actividad_Alumnos');
    await syncTable('Recibo');
    await syncTable('ActCAP');
    await syncTable('PromocionFechas');
    await syncTable('PagosFechas');
    
    print('Sincronización bidireccional completada.');
  }
}
