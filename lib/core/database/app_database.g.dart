// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriasTable extends Categorias
    with TableInfo<$CategoriasTable, Categoria> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconoMeta = const VerificationMeta('icono');
  @override
  late final GeneratedColumn<String> icono = GeneratedColumn<String>(
    'icono',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($CategoriasTable.$convertertipo);
  static const VerificationMeta _archivadaMeta = const VerificationMeta(
    'archivada',
  );
  @override
  late final GeneratedColumn<bool> archivada = GeneratedColumn<bool>(
    'archivada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archivada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nombre,
    icono,
    color,
    tipo,
    archivada,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categorias';
  @override
  VerificationContext validateIntegrity(
    Insertable<Categoria> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('icono')) {
      context.handle(
        _iconoMeta,
        icono.isAcceptableOrUnknown(data['icono']!, _iconoMeta),
      );
    } else if (isInserting) {
      context.missing(_iconoMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('archivada')) {
      context.handle(
        _archivadaMeta,
        archivada.isAcceptableOrUnknown(data['archivada']!, _archivadaMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Categoria map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Categoria(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      icono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icono'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      tipo: $CategoriasTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      archivada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archivada'],
      )!,
    );
  }

  @override
  $CategoriasTable createAlias(String alias) {
    return $CategoriasTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, String, String> $convertertipo =
      const EnumNameConverter<TipoMovimiento>(TipoMovimiento.values);
}

class Categoria extends DataClass implements Insertable<Categoria> {
  final int id;
  final String nombre;
  final String icono;
  final int color;
  final TipoMovimiento tipo;
  final bool archivada;
  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.color,
    required this.tipo,
    required this.archivada,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nombre'] = Variable<String>(nombre);
    map['icono'] = Variable<String>(icono);
    map['color'] = Variable<int>(color);
    {
      map['tipo'] = Variable<String>(
        $CategoriasTable.$convertertipo.toSql(tipo),
      );
    }
    map['archivada'] = Variable<bool>(archivada);
    return map;
  }

  CategoriasCompanion toCompanion(bool nullToAbsent) {
    return CategoriasCompanion(
      id: Value(id),
      nombre: Value(nombre),
      icono: Value(icono),
      color: Value(color),
      tipo: Value(tipo),
      archivada: Value(archivada),
    );
  }

  factory Categoria.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Categoria(
      id: serializer.fromJson<int>(json['id']),
      nombre: serializer.fromJson<String>(json['nombre']),
      icono: serializer.fromJson<String>(json['icono']),
      color: serializer.fromJson<int>(json['color']),
      tipo: $CategoriasTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      archivada: serializer.fromJson<bool>(json['archivada']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nombre': serializer.toJson<String>(nombre),
      'icono': serializer.toJson<String>(icono),
      'color': serializer.toJson<int>(color),
      'tipo': serializer.toJson<String>(
        $CategoriasTable.$convertertipo.toJson(tipo),
      ),
      'archivada': serializer.toJson<bool>(archivada),
    };
  }

  Categoria copyWith({
    int? id,
    String? nombre,
    String? icono,
    int? color,
    TipoMovimiento? tipo,
    bool? archivada,
  }) => Categoria(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    icono: icono ?? this.icono,
    color: color ?? this.color,
    tipo: tipo ?? this.tipo,
    archivada: archivada ?? this.archivada,
  );
  Categoria copyWithCompanion(CategoriasCompanion data) {
    return Categoria(
      id: data.id.present ? data.id.value : this.id,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      icono: data.icono.present ? data.icono.value : this.icono,
      color: data.color.present ? data.color.value : this.color,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      archivada: data.archivada.present ? data.archivada.value : this.archivada,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Categoria(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('archivada: $archivada')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nombre, icono, color, tipo, archivada);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Categoria &&
          other.id == this.id &&
          other.nombre == this.nombre &&
          other.icono == this.icono &&
          other.color == this.color &&
          other.tipo == this.tipo &&
          other.archivada == this.archivada);
}

class CategoriasCompanion extends UpdateCompanion<Categoria> {
  final Value<int> id;
  final Value<String> nombre;
  final Value<String> icono;
  final Value<int> color;
  final Value<TipoMovimiento> tipo;
  final Value<bool> archivada;
  const CategoriasCompanion({
    this.id = const Value.absent(),
    this.nombre = const Value.absent(),
    this.icono = const Value.absent(),
    this.color = const Value.absent(),
    this.tipo = const Value.absent(),
    this.archivada = const Value.absent(),
  });
  CategoriasCompanion.insert({
    this.id = const Value.absent(),
    required String nombre,
    required String icono,
    required int color,
    required TipoMovimiento tipo,
    this.archivada = const Value.absent(),
  }) : nombre = Value(nombre),
       icono = Value(icono),
       color = Value(color),
       tipo = Value(tipo);
  static Insertable<Categoria> custom({
    Expression<int>? id,
    Expression<String>? nombre,
    Expression<String>? icono,
    Expression<int>? color,
    Expression<String>? tipo,
    Expression<bool>? archivada,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (icono != null) 'icono': icono,
      if (color != null) 'color': color,
      if (tipo != null) 'tipo': tipo,
      if (archivada != null) 'archivada': archivada,
    });
  }

  CategoriasCompanion copyWith({
    Value<int>? id,
    Value<String>? nombre,
    Value<String>? icono,
    Value<int>? color,
    Value<TipoMovimiento>? tipo,
    Value<bool>? archivada,
  }) {
    return CategoriasCompanion(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      color: color ?? this.color,
      tipo: tipo ?? this.tipo,
      archivada: archivada ?? this.archivada,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (icono.present) {
      map['icono'] = Variable<String>(icono.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $CategoriasTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (archivada.present) {
      map['archivada'] = Variable<bool>(archivada.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriasCompanion(')
          ..write('id: $id, ')
          ..write('nombre: $nombre, ')
          ..write('icono: $icono, ')
          ..write('color: $color, ')
          ..write('tipo: $tipo, ')
          ..write('archivada: $archivada')
          ..write(')'))
        .toString();
  }
}

class $RecurrentesTable extends Recurrentes
    with TableInfo<$RecurrentesTable, Recurrente> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrentesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($RecurrentesTable.$convertertipo);
  static const VerificationMeta _montoCentimosMeta = const VerificationMeta(
    'montoCentimos',
  );
  @override
  late final GeneratedColumn<int> montoCentimos = GeneratedColumn<int>(
    'monto_centimos',
    aliasedName,
    false,
    check: () => CustomExpression('monto_centimos > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Frecuencia, String> frecuencia =
      GeneratedColumn<String>(
        'frecuencia',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Frecuencia>($RecurrentesTable.$converterfrecuencia);
  static const VerificationMeta _diaMeta = const VerificationMeta('dia');
  @override
  late final GeneratedColumn<int> dia = GeneratedColumn<int>(
    'dia',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaInicioMeta = const VerificationMeta(
    'fechaInicio',
  );
  @override
  late final GeneratedColumn<DateTime> fechaInicio = GeneratedColumn<DateTime>(
    'fecha_inicio',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ultimaGeneracionMeta = const VerificationMeta(
    'ultimaGeneracion',
  );
  @override
  late final GeneratedColumn<DateTime> ultimaGeneracion =
      GeneratedColumn<DateTime>(
        'ultima_generacion',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    montoCentimos,
    categoriaId,
    nota,
    frecuencia,
    dia,
    fechaInicio,
    ultimaGeneracion,
    activo,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrentes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recurrente> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monto_centimos')) {
      context.handle(
        _montoCentimosMeta,
        montoCentimos.isAcceptableOrUnknown(
          data['monto_centimos']!,
          _montoCentimosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentimosMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('dia')) {
      context.handle(
        _diaMeta,
        dia.isAcceptableOrUnknown(data['dia']!, _diaMeta),
      );
    } else if (isInserting) {
      context.missing(_diaMeta);
    }
    if (data.containsKey('fecha_inicio')) {
      context.handle(
        _fechaInicioMeta,
        fechaInicio.isAcceptableOrUnknown(
          data['fecha_inicio']!,
          _fechaInicioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fechaInicioMeta);
    }
    if (data.containsKey('ultima_generacion')) {
      context.handle(
        _ultimaGeneracionMeta,
        ultimaGeneracion.isAcceptableOrUnknown(
          data['ultima_generacion']!,
          _ultimaGeneracionMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    } else if (isInserting) {
      context.missing(_activoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recurrente map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recurrente(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: $RecurrentesTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      montoCentimos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centimos'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      frecuencia: $RecurrentesTable.$converterfrecuencia.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frecuencia'],
        )!,
      ),
      dia: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dia'],
      )!,
      fechaInicio: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha_inicio'],
      )!,
      ultimaGeneracion: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ultima_generacion'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
    );
  }

  @override
  $RecurrentesTable createAlias(String alias) {
    return $RecurrentesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, String, String> $convertertipo =
      const EnumNameConverter<TipoMovimiento>(TipoMovimiento.values);
  static JsonTypeConverter2<Frecuencia, String, String> $converterfrecuencia =
      const EnumNameConverter<Frecuencia>(Frecuencia.values);
}

class Recurrente extends DataClass implements Insertable<Recurrente> {
  final int id;
  final TipoMovimiento tipo;
  final int montoCentimos;
  final int categoriaId;
  final String? nota;
  final Frecuencia frecuencia;
  final int dia;
  final DateTime fechaInicio;
  final DateTime? ultimaGeneracion;
  final bool activo;
  const Recurrente({
    required this.id,
    required this.tipo,
    required this.montoCentimos,
    required this.categoriaId,
    this.nota,
    required this.frecuencia,
    required this.dia,
    required this.fechaInicio,
    this.ultimaGeneracion,
    required this.activo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<String>(
        $RecurrentesTable.$convertertipo.toSql(tipo),
      );
    }
    map['monto_centimos'] = Variable<int>(montoCentimos);
    map['categoria_id'] = Variable<int>(categoriaId);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    {
      map['frecuencia'] = Variable<String>(
        $RecurrentesTable.$converterfrecuencia.toSql(frecuencia),
      );
    }
    map['dia'] = Variable<int>(dia);
    map['fecha_inicio'] = Variable<DateTime>(fechaInicio);
    if (!nullToAbsent || ultimaGeneracion != null) {
      map['ultima_generacion'] = Variable<DateTime>(ultimaGeneracion);
    }
    map['activo'] = Variable<bool>(activo);
    return map;
  }

  RecurrentesCompanion toCompanion(bool nullToAbsent) {
    return RecurrentesCompanion(
      id: Value(id),
      tipo: Value(tipo),
      montoCentimos: Value(montoCentimos),
      categoriaId: Value(categoriaId),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      frecuencia: Value(frecuencia),
      dia: Value(dia),
      fechaInicio: Value(fechaInicio),
      ultimaGeneracion: ultimaGeneracion == null && nullToAbsent
          ? const Value.absent()
          : Value(ultimaGeneracion),
      activo: Value(activo),
    );
  }

  factory Recurrente.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recurrente(
      id: serializer.fromJson<int>(json['id']),
      tipo: $RecurrentesTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      montoCentimos: serializer.fromJson<int>(json['montoCentimos']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      nota: serializer.fromJson<String?>(json['nota']),
      frecuencia: $RecurrentesTable.$converterfrecuencia.fromJson(
        serializer.fromJson<String>(json['frecuencia']),
      ),
      dia: serializer.fromJson<int>(json['dia']),
      fechaInicio: serializer.fromJson<DateTime>(json['fechaInicio']),
      ultimaGeneracion: serializer.fromJson<DateTime?>(
        json['ultimaGeneracion'],
      ),
      activo: serializer.fromJson<bool>(json['activo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(
        $RecurrentesTable.$convertertipo.toJson(tipo),
      ),
      'montoCentimos': serializer.toJson<int>(montoCentimos),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'nota': serializer.toJson<String?>(nota),
      'frecuencia': serializer.toJson<String>(
        $RecurrentesTable.$converterfrecuencia.toJson(frecuencia),
      ),
      'dia': serializer.toJson<int>(dia),
      'fechaInicio': serializer.toJson<DateTime>(fechaInicio),
      'ultimaGeneracion': serializer.toJson<DateTime?>(ultimaGeneracion),
      'activo': serializer.toJson<bool>(activo),
    };
  }

  Recurrente copyWith({
    int? id,
    TipoMovimiento? tipo,
    int? montoCentimos,
    int? categoriaId,
    Value<String?> nota = const Value.absent(),
    Frecuencia? frecuencia,
    int? dia,
    DateTime? fechaInicio,
    Value<DateTime?> ultimaGeneracion = const Value.absent(),
    bool? activo,
  }) => Recurrente(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    montoCentimos: montoCentimos ?? this.montoCentimos,
    categoriaId: categoriaId ?? this.categoriaId,
    nota: nota.present ? nota.value : this.nota,
    frecuencia: frecuencia ?? this.frecuencia,
    dia: dia ?? this.dia,
    fechaInicio: fechaInicio ?? this.fechaInicio,
    ultimaGeneracion: ultimaGeneracion.present
        ? ultimaGeneracion.value
        : this.ultimaGeneracion,
    activo: activo ?? this.activo,
  );
  Recurrente copyWithCompanion(RecurrentesCompanion data) {
    return Recurrente(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCentimos: data.montoCentimos.present
          ? data.montoCentimos.value
          : this.montoCentimos,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      nota: data.nota.present ? data.nota.value : this.nota,
      frecuencia: data.frecuencia.present
          ? data.frecuencia.value
          : this.frecuencia,
      dia: data.dia.present ? data.dia.value : this.dia,
      fechaInicio: data.fechaInicio.present
          ? data.fechaInicio.value
          : this.fechaInicio,
      ultimaGeneracion: data.ultimaGeneracion.present
          ? data.ultimaGeneracion.value
          : this.ultimaGeneracion,
      activo: data.activo.present ? data.activo.value : this.activo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recurrente(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentimos: $montoCentimos, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nota: $nota, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('dia: $dia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('ultimaGeneracion: $ultimaGeneracion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    montoCentimos,
    categoriaId,
    nota,
    frecuencia,
    dia,
    fechaInicio,
    ultimaGeneracion,
    activo,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recurrente &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.montoCentimos == this.montoCentimos &&
          other.categoriaId == this.categoriaId &&
          other.nota == this.nota &&
          other.frecuencia == this.frecuencia &&
          other.dia == this.dia &&
          other.fechaInicio == this.fechaInicio &&
          other.ultimaGeneracion == this.ultimaGeneracion &&
          other.activo == this.activo);
}

class RecurrentesCompanion extends UpdateCompanion<Recurrente> {
  final Value<int> id;
  final Value<TipoMovimiento> tipo;
  final Value<int> montoCentimos;
  final Value<int> categoriaId;
  final Value<String?> nota;
  final Value<Frecuencia> frecuencia;
  final Value<int> dia;
  final Value<DateTime> fechaInicio;
  final Value<DateTime?> ultimaGeneracion;
  final Value<bool> activo;
  const RecurrentesCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCentimos = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.nota = const Value.absent(),
    this.frecuencia = const Value.absent(),
    this.dia = const Value.absent(),
    this.fechaInicio = const Value.absent(),
    this.ultimaGeneracion = const Value.absent(),
    this.activo = const Value.absent(),
  });
  RecurrentesCompanion.insert({
    this.id = const Value.absent(),
    required TipoMovimiento tipo,
    required int montoCentimos,
    required int categoriaId,
    this.nota = const Value.absent(),
    required Frecuencia frecuencia,
    required int dia,
    required DateTime fechaInicio,
    this.ultimaGeneracion = const Value.absent(),
    required bool activo,
  }) : tipo = Value(tipo),
       montoCentimos = Value(montoCentimos),
       categoriaId = Value(categoriaId),
       frecuencia = Value(frecuencia),
       dia = Value(dia),
       fechaInicio = Value(fechaInicio),
       activo = Value(activo);
  static Insertable<Recurrente> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<int>? montoCentimos,
    Expression<int>? categoriaId,
    Expression<String>? nota,
    Expression<String>? frecuencia,
    Expression<int>? dia,
    Expression<DateTime>? fechaInicio,
    Expression<DateTime>? ultimaGeneracion,
    Expression<bool>? activo,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (montoCentimos != null) 'monto_centimos': montoCentimos,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (nota != null) 'nota': nota,
      if (frecuencia != null) 'frecuencia': frecuencia,
      if (dia != null) 'dia': dia,
      if (fechaInicio != null) 'fecha_inicio': fechaInicio,
      if (ultimaGeneracion != null) 'ultima_generacion': ultimaGeneracion,
      if (activo != null) 'activo': activo,
    });
  }

  RecurrentesCompanion copyWith({
    Value<int>? id,
    Value<TipoMovimiento>? tipo,
    Value<int>? montoCentimos,
    Value<int>? categoriaId,
    Value<String?>? nota,
    Value<Frecuencia>? frecuencia,
    Value<int>? dia,
    Value<DateTime>? fechaInicio,
    Value<DateTime?>? ultimaGeneracion,
    Value<bool>? activo,
  }) {
    return RecurrentesCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      montoCentimos: montoCentimos ?? this.montoCentimos,
      categoriaId: categoriaId ?? this.categoriaId,
      nota: nota ?? this.nota,
      frecuencia: frecuencia ?? this.frecuencia,
      dia: dia ?? this.dia,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      ultimaGeneracion: ultimaGeneracion ?? this.ultimaGeneracion,
      activo: activo ?? this.activo,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $RecurrentesTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (montoCentimos.present) {
      map['monto_centimos'] = Variable<int>(montoCentimos.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (frecuencia.present) {
      map['frecuencia'] = Variable<String>(
        $RecurrentesTable.$converterfrecuencia.toSql(frecuencia.value),
      );
    }
    if (dia.present) {
      map['dia'] = Variable<int>(dia.value);
    }
    if (fechaInicio.present) {
      map['fecha_inicio'] = Variable<DateTime>(fechaInicio.value);
    }
    if (ultimaGeneracion.present) {
      map['ultima_generacion'] = Variable<DateTime>(ultimaGeneracion.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrentesCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentimos: $montoCentimos, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nota: $nota, ')
          ..write('frecuencia: $frecuencia, ')
          ..write('dia: $dia, ')
          ..write('fechaInicio: $fechaInicio, ')
          ..write('ultimaGeneracion: $ultimaGeneracion, ')
          ..write('activo: $activo')
          ..write(')'))
        .toString();
  }
}

class $MovimientosTable extends Movimientos
    with TableInfo<$MovimientosTable, Movimiento> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovimientosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TipoMovimiento, String> tipo =
      GeneratedColumn<String>(
        'tipo',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<TipoMovimiento>($MovimientosTable.$convertertipo);
  static const VerificationMeta _montoCentimosMeta = const VerificationMeta(
    'montoCentimos',
  );
  @override
  late final GeneratedColumn<int> montoCentimos = GeneratedColumn<int>(
    'monto_centimos',
    aliasedName,
    false,
    check: () => CustomExpression('monto_centimos > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<DateTime> fecha = GeneratedColumn<DateTime>(
    'fecha',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categorias (id)',
    ),
  );
  static const VerificationMeta _notaMeta = const VerificationMeta('nota');
  @override
  late final GeneratedColumn<String> nota = GeneratedColumn<String>(
    'nota',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenteIdMeta = const VerificationMeta(
    'recurrenteId',
  );
  @override
  late final GeneratedColumn<int> recurrenteId = GeneratedColumn<int>(
    'recurrente_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recurrentes (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _creadoEnMeta = const VerificationMeta(
    'creadoEn',
  );
  @override
  late final GeneratedColumn<DateTime> creadoEn = GeneratedColumn<DateTime>(
    'creado_en',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tipo,
    montoCentimos,
    fecha,
    categoriaId,
    nota,
    recurrenteId,
    creadoEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'movimientos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Movimiento> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('monto_centimos')) {
      context.handle(
        _montoCentimosMeta,
        montoCentimos.isAcceptableOrUnknown(
          data['monto_centimos']!,
          _montoCentimosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentimosMeta);
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoriaIdMeta);
    }
    if (data.containsKey('nota')) {
      context.handle(
        _notaMeta,
        nota.isAcceptableOrUnknown(data['nota']!, _notaMeta),
      );
    }
    if (data.containsKey('recurrente_id')) {
      context.handle(
        _recurrenteIdMeta,
        recurrenteId.isAcceptableOrUnknown(
          data['recurrente_id']!,
          _recurrenteIdMeta,
        ),
      );
    }
    if (data.containsKey('creado_en')) {
      context.handle(
        _creadoEnMeta,
        creadoEn.isAcceptableOrUnknown(data['creado_en']!, _creadoEnMeta),
      );
    } else if (isInserting) {
      context.missing(_creadoEnMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Movimiento map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Movimiento(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tipo: $MovimientosTable.$convertertipo.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tipo'],
        )!,
      ),
      montoCentimos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centimos'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fecha'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      )!,
      nota: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nota'],
      ),
      recurrenteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrente_id'],
      ),
      creadoEn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}creado_en'],
      )!,
    );
  }

  @override
  $MovimientosTable createAlias(String alias) {
    return $MovimientosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TipoMovimiento, String, String> $convertertipo =
      const EnumNameConverter<TipoMovimiento>(TipoMovimiento.values);
}

class Movimiento extends DataClass implements Insertable<Movimiento> {
  final int id;
  final TipoMovimiento tipo;
  final int montoCentimos;
  final DateTime fecha;
  final int categoriaId;
  final String? nota;
  final int? recurrenteId;
  final DateTime creadoEn;
  const Movimiento({
    required this.id,
    required this.tipo,
    required this.montoCentimos,
    required this.fecha,
    required this.categoriaId,
    this.nota,
    this.recurrenteId,
    required this.creadoEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['tipo'] = Variable<String>(
        $MovimientosTable.$convertertipo.toSql(tipo),
      );
    }
    map['monto_centimos'] = Variable<int>(montoCentimos);
    map['fecha'] = Variable<DateTime>(fecha);
    map['categoria_id'] = Variable<int>(categoriaId);
    if (!nullToAbsent || nota != null) {
      map['nota'] = Variable<String>(nota);
    }
    if (!nullToAbsent || recurrenteId != null) {
      map['recurrente_id'] = Variable<int>(recurrenteId);
    }
    map['creado_en'] = Variable<DateTime>(creadoEn);
    return map;
  }

  MovimientosCompanion toCompanion(bool nullToAbsent) {
    return MovimientosCompanion(
      id: Value(id),
      tipo: Value(tipo),
      montoCentimos: Value(montoCentimos),
      fecha: Value(fecha),
      categoriaId: Value(categoriaId),
      nota: nota == null && nullToAbsent ? const Value.absent() : Value(nota),
      recurrenteId: recurrenteId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenteId),
      creadoEn: Value(creadoEn),
    );
  }

  factory Movimiento.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Movimiento(
      id: serializer.fromJson<int>(json['id']),
      tipo: $MovimientosTable.$convertertipo.fromJson(
        serializer.fromJson<String>(json['tipo']),
      ),
      montoCentimos: serializer.fromJson<int>(json['montoCentimos']),
      fecha: serializer.fromJson<DateTime>(json['fecha']),
      categoriaId: serializer.fromJson<int>(json['categoriaId']),
      nota: serializer.fromJson<String?>(json['nota']),
      recurrenteId: serializer.fromJson<int?>(json['recurrenteId']),
      creadoEn: serializer.fromJson<DateTime>(json['creadoEn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tipo': serializer.toJson<String>(
        $MovimientosTable.$convertertipo.toJson(tipo),
      ),
      'montoCentimos': serializer.toJson<int>(montoCentimos),
      'fecha': serializer.toJson<DateTime>(fecha),
      'categoriaId': serializer.toJson<int>(categoriaId),
      'nota': serializer.toJson<String?>(nota),
      'recurrenteId': serializer.toJson<int?>(recurrenteId),
      'creadoEn': serializer.toJson<DateTime>(creadoEn),
    };
  }

  Movimiento copyWith({
    int? id,
    TipoMovimiento? tipo,
    int? montoCentimos,
    DateTime? fecha,
    int? categoriaId,
    Value<String?> nota = const Value.absent(),
    Value<int?> recurrenteId = const Value.absent(),
    DateTime? creadoEn,
  }) => Movimiento(
    id: id ?? this.id,
    tipo: tipo ?? this.tipo,
    montoCentimos: montoCentimos ?? this.montoCentimos,
    fecha: fecha ?? this.fecha,
    categoriaId: categoriaId ?? this.categoriaId,
    nota: nota.present ? nota.value : this.nota,
    recurrenteId: recurrenteId.present ? recurrenteId.value : this.recurrenteId,
    creadoEn: creadoEn ?? this.creadoEn,
  );
  Movimiento copyWithCompanion(MovimientosCompanion data) {
    return Movimiento(
      id: data.id.present ? data.id.value : this.id,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      montoCentimos: data.montoCentimos.present
          ? data.montoCentimos.value
          : this.montoCentimos,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      nota: data.nota.present ? data.nota.value : this.nota,
      recurrenteId: data.recurrenteId.present
          ? data.recurrenteId.value
          : this.recurrenteId,
      creadoEn: data.creadoEn.present ? data.creadoEn.value : this.creadoEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Movimiento(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentimos: $montoCentimos, ')
          ..write('fecha: $fecha, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nota: $nota, ')
          ..write('recurrenteId: $recurrenteId, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tipo,
    montoCentimos,
    fecha,
    categoriaId,
    nota,
    recurrenteId,
    creadoEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Movimiento &&
          other.id == this.id &&
          other.tipo == this.tipo &&
          other.montoCentimos == this.montoCentimos &&
          other.fecha == this.fecha &&
          other.categoriaId == this.categoriaId &&
          other.nota == this.nota &&
          other.recurrenteId == this.recurrenteId &&
          other.creadoEn == this.creadoEn);
}

class MovimientosCompanion extends UpdateCompanion<Movimiento> {
  final Value<int> id;
  final Value<TipoMovimiento> tipo;
  final Value<int> montoCentimos;
  final Value<DateTime> fecha;
  final Value<int> categoriaId;
  final Value<String?> nota;
  final Value<int?> recurrenteId;
  final Value<DateTime> creadoEn;
  const MovimientosCompanion({
    this.id = const Value.absent(),
    this.tipo = const Value.absent(),
    this.montoCentimos = const Value.absent(),
    this.fecha = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.nota = const Value.absent(),
    this.recurrenteId = const Value.absent(),
    this.creadoEn = const Value.absent(),
  });
  MovimientosCompanion.insert({
    this.id = const Value.absent(),
    required TipoMovimiento tipo,
    required int montoCentimos,
    required DateTime fecha,
    required int categoriaId,
    this.nota = const Value.absent(),
    this.recurrenteId = const Value.absent(),
    required DateTime creadoEn,
  }) : tipo = Value(tipo),
       montoCentimos = Value(montoCentimos),
       fecha = Value(fecha),
       categoriaId = Value(categoriaId),
       creadoEn = Value(creadoEn);
  static Insertable<Movimiento> custom({
    Expression<int>? id,
    Expression<String>? tipo,
    Expression<int>? montoCentimos,
    Expression<DateTime>? fecha,
    Expression<int>? categoriaId,
    Expression<String>? nota,
    Expression<int>? recurrenteId,
    Expression<DateTime>? creadoEn,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tipo != null) 'tipo': tipo,
      if (montoCentimos != null) 'monto_centimos': montoCentimos,
      if (fecha != null) 'fecha': fecha,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (nota != null) 'nota': nota,
      if (recurrenteId != null) 'recurrente_id': recurrenteId,
      if (creadoEn != null) 'creado_en': creadoEn,
    });
  }

  MovimientosCompanion copyWith({
    Value<int>? id,
    Value<TipoMovimiento>? tipo,
    Value<int>? montoCentimos,
    Value<DateTime>? fecha,
    Value<int>? categoriaId,
    Value<String?>? nota,
    Value<int?>? recurrenteId,
    Value<DateTime>? creadoEn,
  }) {
    return MovimientosCompanion(
      id: id ?? this.id,
      tipo: tipo ?? this.tipo,
      montoCentimos: montoCentimos ?? this.montoCentimos,
      fecha: fecha ?? this.fecha,
      categoriaId: categoriaId ?? this.categoriaId,
      nota: nota ?? this.nota,
      recurrenteId: recurrenteId ?? this.recurrenteId,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(
        $MovimientosTable.$convertertipo.toSql(tipo.value),
      );
    }
    if (montoCentimos.present) {
      map['monto_centimos'] = Variable<int>(montoCentimos.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<DateTime>(fecha.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (nota.present) {
      map['nota'] = Variable<String>(nota.value);
    }
    if (recurrenteId.present) {
      map['recurrente_id'] = Variable<int>(recurrenteId.value);
    }
    if (creadoEn.present) {
      map['creado_en'] = Variable<DateTime>(creadoEn.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MovimientosCompanion(')
          ..write('id: $id, ')
          ..write('tipo: $tipo, ')
          ..write('montoCentimos: $montoCentimos, ')
          ..write('fecha: $fecha, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('nota: $nota, ')
          ..write('recurrenteId: $recurrenteId, ')
          ..write('creadoEn: $creadoEn')
          ..write(')'))
        .toString();
  }
}

class $PresupuestosTable extends Presupuestos
    with TableInfo<$PresupuestosTable, Presupuesto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PresupuestosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoriaIdMeta = const VerificationMeta(
    'categoriaId',
  );
  @override
  late final GeneratedColumn<int> categoriaId = GeneratedColumn<int>(
    'categoria_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES categorias (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _montoCentimosMeta = const VerificationMeta(
    'montoCentimos',
  );
  @override
  late final GeneratedColumn<int> montoCentimos = GeneratedColumn<int>(
    'monto_centimos',
    aliasedName,
    false,
    check: () => CustomExpression('monto_centimos > 0'),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, categoriaId, montoCentimos];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'presupuestos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Presupuesto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('categoria_id')) {
      context.handle(
        _categoriaIdMeta,
        categoriaId.isAcceptableOrUnknown(
          data['categoria_id']!,
          _categoriaIdMeta,
        ),
      );
    }
    if (data.containsKey('monto_centimos')) {
      context.handle(
        _montoCentimosMeta,
        montoCentimos.isAcceptableOrUnknown(
          data['monto_centimos']!,
          _montoCentimosMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_montoCentimosMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Presupuesto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Presupuesto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoriaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}categoria_id'],
      ),
      montoCentimos: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monto_centimos'],
      )!,
    );
  }

  @override
  $PresupuestosTable createAlias(String alias) {
    return $PresupuestosTable(attachedDatabase, alias);
  }
}

class Presupuesto extends DataClass implements Insertable<Presupuesto> {
  final int id;
  final int? categoriaId;
  final int montoCentimos;
  const Presupuesto({
    required this.id,
    this.categoriaId,
    required this.montoCentimos,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoriaId != null) {
      map['categoria_id'] = Variable<int>(categoriaId);
    }
    map['monto_centimos'] = Variable<int>(montoCentimos);
    return map;
  }

  PresupuestosCompanion toCompanion(bool nullToAbsent) {
    return PresupuestosCompanion(
      id: Value(id),
      categoriaId: categoriaId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoriaId),
      montoCentimos: Value(montoCentimos),
    );
  }

  factory Presupuesto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Presupuesto(
      id: serializer.fromJson<int>(json['id']),
      categoriaId: serializer.fromJson<int?>(json['categoriaId']),
      montoCentimos: serializer.fromJson<int>(json['montoCentimos']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoriaId': serializer.toJson<int?>(categoriaId),
      'montoCentimos': serializer.toJson<int>(montoCentimos),
    };
  }

  Presupuesto copyWith({
    int? id,
    Value<int?> categoriaId = const Value.absent(),
    int? montoCentimos,
  }) => Presupuesto(
    id: id ?? this.id,
    categoriaId: categoriaId.present ? categoriaId.value : this.categoriaId,
    montoCentimos: montoCentimos ?? this.montoCentimos,
  );
  Presupuesto copyWithCompanion(PresupuestosCompanion data) {
    return Presupuesto(
      id: data.id.present ? data.id.value : this.id,
      categoriaId: data.categoriaId.present
          ? data.categoriaId.value
          : this.categoriaId,
      montoCentimos: data.montoCentimos.present
          ? data.montoCentimos.value
          : this.montoCentimos,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Presupuesto(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentimos: $montoCentimos')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoriaId, montoCentimos);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Presupuesto &&
          other.id == this.id &&
          other.categoriaId == this.categoriaId &&
          other.montoCentimos == this.montoCentimos);
}

class PresupuestosCompanion extends UpdateCompanion<Presupuesto> {
  final Value<int> id;
  final Value<int?> categoriaId;
  final Value<int> montoCentimos;
  const PresupuestosCompanion({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    this.montoCentimos = const Value.absent(),
  });
  PresupuestosCompanion.insert({
    this.id = const Value.absent(),
    this.categoriaId = const Value.absent(),
    required int montoCentimos,
  }) : montoCentimos = Value(montoCentimos);
  static Insertable<Presupuesto> custom({
    Expression<int>? id,
    Expression<int>? categoriaId,
    Expression<int>? montoCentimos,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoriaId != null) 'categoria_id': categoriaId,
      if (montoCentimos != null) 'monto_centimos': montoCentimos,
    });
  }

  PresupuestosCompanion copyWith({
    Value<int>? id,
    Value<int?>? categoriaId,
    Value<int>? montoCentimos,
  }) {
    return PresupuestosCompanion(
      id: id ?? this.id,
      categoriaId: categoriaId ?? this.categoriaId,
      montoCentimos: montoCentimos ?? this.montoCentimos,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoriaId.present) {
      map['categoria_id'] = Variable<int>(categoriaId.value);
    }
    if (montoCentimos.present) {
      map['monto_centimos'] = Variable<int>(montoCentimos.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PresupuestosCompanion(')
          ..write('id: $id, ')
          ..write('categoriaId: $categoriaId, ')
          ..write('montoCentimos: $montoCentimos')
          ..write(')'))
        .toString();
  }
}

class $AlertasEnviadasTable extends AlertasEnviadas
    with TableInfo<$AlertasEnviadasTable, AlertaEnviada> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertasEnviadasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _presupuestoIdMeta = const VerificationMeta(
    'presupuestoId',
  );
  @override
  late final GeneratedColumn<int> presupuestoId = GeneratedColumn<int>(
    'presupuesto_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES presupuestos (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _mesMeta = const VerificationMeta('mes');
  @override
  late final GeneratedColumn<String> mes = GeneratedColumn<String>(
    'mes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _umbralMeta = const VerificationMeta('umbral');
  @override
  late final GeneratedColumn<int> umbral = GeneratedColumn<int>(
    'umbral',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [presupuestoId, mes, umbral];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alertas_enviadas';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertaEnviada> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('presupuesto_id')) {
      context.handle(
        _presupuestoIdMeta,
        presupuestoId.isAcceptableOrUnknown(
          data['presupuesto_id']!,
          _presupuestoIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_presupuestoIdMeta);
    }
    if (data.containsKey('mes')) {
      context.handle(
        _mesMeta,
        mes.isAcceptableOrUnknown(data['mes']!, _mesMeta),
      );
    } else if (isInserting) {
      context.missing(_mesMeta);
    }
    if (data.containsKey('umbral')) {
      context.handle(
        _umbralMeta,
        umbral.isAcceptableOrUnknown(data['umbral']!, _umbralMeta),
      );
    } else if (isInserting) {
      context.missing(_umbralMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {presupuestoId, mes, umbral};
  @override
  AlertaEnviada map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertaEnviada(
      presupuestoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}presupuesto_id'],
      )!,
      mes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mes'],
      )!,
      umbral: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}umbral'],
      )!,
    );
  }

  @override
  $AlertasEnviadasTable createAlias(String alias) {
    return $AlertasEnviadasTable(attachedDatabase, alias);
  }
}

class AlertaEnviada extends DataClass implements Insertable<AlertaEnviada> {
  final int presupuestoId;
  final String mes;
  final int umbral;
  const AlertaEnviada({
    required this.presupuestoId,
    required this.mes,
    required this.umbral,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['presupuesto_id'] = Variable<int>(presupuestoId);
    map['mes'] = Variable<String>(mes);
    map['umbral'] = Variable<int>(umbral);
    return map;
  }

  AlertasEnviadasCompanion toCompanion(bool nullToAbsent) {
    return AlertasEnviadasCompanion(
      presupuestoId: Value(presupuestoId),
      mes: Value(mes),
      umbral: Value(umbral),
    );
  }

  factory AlertaEnviada.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertaEnviada(
      presupuestoId: serializer.fromJson<int>(json['presupuestoId']),
      mes: serializer.fromJson<String>(json['mes']),
      umbral: serializer.fromJson<int>(json['umbral']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'presupuestoId': serializer.toJson<int>(presupuestoId),
      'mes': serializer.toJson<String>(mes),
      'umbral': serializer.toJson<int>(umbral),
    };
  }

  AlertaEnviada copyWith({int? presupuestoId, String? mes, int? umbral}) =>
      AlertaEnviada(
        presupuestoId: presupuestoId ?? this.presupuestoId,
        mes: mes ?? this.mes,
        umbral: umbral ?? this.umbral,
      );
  AlertaEnviada copyWithCompanion(AlertasEnviadasCompanion data) {
    return AlertaEnviada(
      presupuestoId: data.presupuestoId.present
          ? data.presupuestoId.value
          : this.presupuestoId,
      mes: data.mes.present ? data.mes.value : this.mes,
      umbral: data.umbral.present ? data.umbral.value : this.umbral,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertaEnviada(')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('mes: $mes, ')
          ..write('umbral: $umbral')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(presupuestoId, mes, umbral);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertaEnviada &&
          other.presupuestoId == this.presupuestoId &&
          other.mes == this.mes &&
          other.umbral == this.umbral);
}

class AlertasEnviadasCompanion extends UpdateCompanion<AlertaEnviada> {
  final Value<int> presupuestoId;
  final Value<String> mes;
  final Value<int> umbral;
  final Value<int> rowid;
  const AlertasEnviadasCompanion({
    this.presupuestoId = const Value.absent(),
    this.mes = const Value.absent(),
    this.umbral = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertasEnviadasCompanion.insert({
    required int presupuestoId,
    required String mes,
    required int umbral,
    this.rowid = const Value.absent(),
  }) : presupuestoId = Value(presupuestoId),
       mes = Value(mes),
       umbral = Value(umbral);
  static Insertable<AlertaEnviada> custom({
    Expression<int>? presupuestoId,
    Expression<String>? mes,
    Expression<int>? umbral,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (presupuestoId != null) 'presupuesto_id': presupuestoId,
      if (mes != null) 'mes': mes,
      if (umbral != null) 'umbral': umbral,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertasEnviadasCompanion copyWith({
    Value<int>? presupuestoId,
    Value<String>? mes,
    Value<int>? umbral,
    Value<int>? rowid,
  }) {
    return AlertasEnviadasCompanion(
      presupuestoId: presupuestoId ?? this.presupuestoId,
      mes: mes ?? this.mes,
      umbral: umbral ?? this.umbral,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (presupuestoId.present) {
      map['presupuesto_id'] = Variable<int>(presupuestoId.value);
    }
    if (mes.present) {
      map['mes'] = Variable<String>(mes.value);
    }
    if (umbral.present) {
      map['umbral'] = Variable<int>(umbral.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertasEnviadasCompanion(')
          ..write('presupuestoId: $presupuestoId, ')
          ..write('mes: $mes, ')
          ..write('umbral: $umbral, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriasTable categorias = $CategoriasTable(this);
  late final $RecurrentesTable recurrentes = $RecurrentesTable(this);
  late final $MovimientosTable movimientos = $MovimientosTable(this);
  late final $PresupuestosTable presupuestos = $PresupuestosTable(this);
  late final $AlertasEnviadasTable alertasEnviadas = $AlertasEnviadasTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categorias,
    recurrentes,
    movimientos,
    presupuestos,
    alertasEnviadas,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recurrentes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('movimientos', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categorias',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('presupuestos', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'presupuestos',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('alertas_enviadas', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriasTableCreateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      required String nombre,
      required String icono,
      required int color,
      required TipoMovimiento tipo,
      Value<bool> archivada,
    });
typedef $$CategoriasTableUpdateCompanionBuilder =
    CategoriasCompanion Function({
      Value<int> id,
      Value<String> nombre,
      Value<String> icono,
      Value<int> color,
      Value<TipoMovimiento> tipo,
      Value<bool> archivada,
    });

final class $$CategoriasTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriasTable, Categoria> {
  $$CategoriasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecurrentesTable, List<Recurrente>>
  _recurrentesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recurrentes,
    aliasName: 'categorias__id__recurrentes__categoria_id',
  );

  $$RecurrentesTableProcessedTableManager get recurrentesRefs {
    final manager = $$RecurrentesTableTableManager(
      $_db,
      $_db.recurrentes,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recurrentesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<Movimiento>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: 'categorias__id__movimientos__categoria_id',
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PresupuestosTable, List<Presupuesto>>
  _presupuestosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.presupuestos,
    aliasName: 'categorias__id__presupuestos__categoria_id',
  );

  $$PresupuestosTableProcessedTableManager get presupuestosRefs {
    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.categoriaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_presupuestosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriasTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get archivada => $composableBuilder(
    column: $table.archivada,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recurrentesRefs(
    Expression<bool> Function($$RecurrentesTableFilterComposer f) f,
  ) {
    final $$RecurrentesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrentes,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrentesTableFilterComposer(
            $db: $db,
            $table: $db.recurrentes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> presupuestosRefs(
    Expression<bool> Function($$PresupuestosTableFilterComposer f) f,
  ) {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icono => $composableBuilder(
    column: $table.icono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archivada => $composableBuilder(
    column: $table.archivada,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriasTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriasTable> {
  $$CategoriasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get icono =>
      $composableBuilder(column: $table.icono, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<bool> get archivada =>
      $composableBuilder(column: $table.archivada, builder: (column) => column);

  Expression<T> recurrentesRefs<T extends Object>(
    Expression<T> Function($$RecurrentesTableAnnotationComposer a) f,
  ) {
    final $$RecurrentesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recurrentes,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrentesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrentes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> presupuestosRefs<T extends Object>(
    Expression<T> Function($$PresupuestosTableAnnotationComposer a) f,
  ) {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.categoriaId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriasTable,
          Categoria,
          $$CategoriasTableFilterComposer,
          $$CategoriasTableOrderingComposer,
          $$CategoriasTableAnnotationComposer,
          $$CategoriasTableCreateCompanionBuilder,
          $$CategoriasTableUpdateCompanionBuilder,
          (Categoria, $$CategoriasTableReferences),
          Categoria,
          PrefetchHooks Function({
            bool recurrentesRefs,
            bool movimientosRefs,
            bool presupuestosRefs,
          })
        > {
  $$CategoriasTableTableManager(_$AppDatabase db, $CategoriasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String> icono = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<bool> archivada = const Value.absent(),
              }) => CategoriasCompanion(
                id: id,
                nombre: nombre,
                icono: icono,
                color: color,
                tipo: tipo,
                archivada: archivada,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String nombre,
                required String icono,
                required int color,
                required TipoMovimiento tipo,
                Value<bool> archivada = const Value.absent(),
              }) => CategoriasCompanion.insert(
                id: id,
                nombre: nombre,
                icono: icono,
                color: color,
                tipo: tipo,
                archivada: archivada,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriasTable, Categoria>(table),
                  $$CategoriasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recurrentesRefs = false,
                movimientosRefs = false,
                presupuestosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recurrentesRefs) db.recurrentes,
                    if (movimientosRefs) db.movimientos,
                    if (presupuestosRefs) db.presupuestos,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recurrentesRefs)
                        await $_getPrefetchedDataByColumns<
                          Categoria,
                          $CategoriasTable,
                          Recurrente,
                          $RecurrentesTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._recurrentesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).recurrentesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                      if (movimientosRefs)
                        await $_getPrefetchedDataByColumns<
                          Categoria,
                          $CategoriasTable,
                          Movimiento,
                          $MovimientosTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                      if (presupuestosRefs)
                        await $_getPrefetchedDataByColumns<
                          Categoria,
                          $CategoriasTable,
                          Presupuesto,
                          $PresupuestosTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriasTableReferences
                              ._presupuestosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriasTableReferences(
                                db,
                                table,
                                p0,
                              ).presupuestosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'categoria_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriasTable,
      Categoria,
      $$CategoriasTableFilterComposer,
      $$CategoriasTableOrderingComposer,
      $$CategoriasTableAnnotationComposer,
      $$CategoriasTableCreateCompanionBuilder,
      $$CategoriasTableUpdateCompanionBuilder,
      (Categoria, $$CategoriasTableReferences),
      Categoria,
      PrefetchHooks Function({
        bool recurrentesRefs,
        bool movimientosRefs,
        bool presupuestosRefs,
      })
    >;
typedef $$RecurrentesTableCreateCompanionBuilder =
    RecurrentesCompanion Function({
      Value<int> id,
      required TipoMovimiento tipo,
      required int montoCentimos,
      required int categoriaId,
      Value<String?> nota,
      required Frecuencia frecuencia,
      required int dia,
      required DateTime fechaInicio,
      Value<DateTime?> ultimaGeneracion,
      required bool activo,
    });
typedef $$RecurrentesTableUpdateCompanionBuilder =
    RecurrentesCompanion Function({
      Value<int> id,
      Value<TipoMovimiento> tipo,
      Value<int> montoCentimos,
      Value<int> categoriaId,
      Value<String?> nota,
      Value<Frecuencia> frecuencia,
      Value<int> dia,
      Value<DateTime> fechaInicio,
      Value<DateTime?> ultimaGeneracion,
      Value<bool> activo,
    });

final class $$RecurrentesTableReferences
    extends BaseReferences<_$AppDatabase, $RecurrentesTable, Recurrente> {
  $$RecurrentesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('recurrentes__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MovimientosTable, List<Movimiento>>
  _movimientosRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.movimientos,
    aliasName: 'recurrentes__id__movimientos__recurrente_id',
  );

  $$MovimientosTableProcessedTableManager get movimientosRefs {
    final manager = $$MovimientosTableTableManager(
      $_db,
      $_db.movimientos,
    ).filter((f) => f.recurrenteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_movimientosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecurrentesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrentesTable> {
  $$RecurrentesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Frecuencia, Frecuencia, String>
  get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get ultimaGeneracion => $composableBuilder(
    column: $table.ultimaGeneracion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> movimientosRefs(
    Expression<bool> Function($$MovimientosTableFilterComposer f) f,
  ) {
    final $$MovimientosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.recurrenteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableFilterComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurrentesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrentesTable> {
  $$RecurrentesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frecuencia => $composableBuilder(
    column: $table.frecuencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dia => $composableBuilder(
    column: $table.dia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get ultimaGeneracion => $composableBuilder(
    column: $table.ultimaGeneracion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurrentesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrentesTable> {
  $$RecurrentesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frecuencia, String> get frecuencia =>
      $composableBuilder(
        column: $table.frecuencia,
        builder: (column) => column,
      );

  GeneratedColumn<int> get dia =>
      $composableBuilder(column: $table.dia, builder: (column) => column);

  GeneratedColumn<DateTime> get fechaInicio => $composableBuilder(
    column: $table.fechaInicio,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get ultimaGeneracion => $composableBuilder(
    column: $table.ultimaGeneracion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> movimientosRefs<T extends Object>(
    Expression<T> Function($$MovimientosTableAnnotationComposer a) f,
  ) {
    final $$MovimientosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.movimientos,
      getReferencedColumn: (t) => t.recurrenteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MovimientosTableAnnotationComposer(
            $db: $db,
            $table: $db.movimientos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecurrentesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrentesTable,
          Recurrente,
          $$RecurrentesTableFilterComposer,
          $$RecurrentesTableOrderingComposer,
          $$RecurrentesTableAnnotationComposer,
          $$RecurrentesTableCreateCompanionBuilder,
          $$RecurrentesTableUpdateCompanionBuilder,
          (Recurrente, $$RecurrentesTableReferences),
          Recurrente,
          PrefetchHooks Function({bool categoriaId, bool movimientosRefs})
        > {
  $$RecurrentesTableTableManager(_$AppDatabase db, $RecurrentesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrentesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurrentesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurrentesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<int> montoCentimos = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<Frecuencia> frecuencia = const Value.absent(),
                Value<int> dia = const Value.absent(),
                Value<DateTime> fechaInicio = const Value.absent(),
                Value<DateTime?> ultimaGeneracion = const Value.absent(),
                Value<bool> activo = const Value.absent(),
              }) => RecurrentesCompanion(
                id: id,
                tipo: tipo,
                montoCentimos: montoCentimos,
                categoriaId: categoriaId,
                nota: nota,
                frecuencia: frecuencia,
                dia: dia,
                fechaInicio: fechaInicio,
                ultimaGeneracion: ultimaGeneracion,
                activo: activo,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TipoMovimiento tipo,
                required int montoCentimos,
                required int categoriaId,
                Value<String?> nota = const Value.absent(),
                required Frecuencia frecuencia,
                required int dia,
                required DateTime fechaInicio,
                Value<DateTime?> ultimaGeneracion = const Value.absent(),
                required bool activo,
              }) => RecurrentesCompanion.insert(
                id: id,
                tipo: tipo,
                montoCentimos: montoCentimos,
                categoriaId: categoriaId,
                nota: nota,
                frecuencia: frecuencia,
                dia: dia,
                fechaInicio: fechaInicio,
                ultimaGeneracion: ultimaGeneracion,
                activo: activo,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecurrentesTable, Recurrente>(table),
                  $$RecurrentesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoriaId = false, movimientosRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (movimientosRefs) db.movimientos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$RecurrentesTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$RecurrentesTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (movimientosRefs)
                        await $_getPrefetchedDataByColumns<
                          Recurrente,
                          $RecurrentesTable,
                          Movimiento,
                          $MovimientosTable
                        >(
                          currentTable: table,
                          referencedTable: $$RecurrentesTableReferences
                              ._movimientosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecurrentesTableReferences(
                                db,
                                table,
                                p0,
                              ).movimientosRefs,
                          currentColumn: 'id',
                          referencedColumn: 'recurrente_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecurrentesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrentesTable,
      Recurrente,
      $$RecurrentesTableFilterComposer,
      $$RecurrentesTableOrderingComposer,
      $$RecurrentesTableAnnotationComposer,
      $$RecurrentesTableCreateCompanionBuilder,
      $$RecurrentesTableUpdateCompanionBuilder,
      (Recurrente, $$RecurrentesTableReferences),
      Recurrente,
      PrefetchHooks Function({bool categoriaId, bool movimientosRefs})
    >;
typedef $$MovimientosTableCreateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      required TipoMovimiento tipo,
      required int montoCentimos,
      required DateTime fecha,
      required int categoriaId,
      Value<String?> nota,
      Value<int?> recurrenteId,
      required DateTime creadoEn,
    });
typedef $$MovimientosTableUpdateCompanionBuilder =
    MovimientosCompanion Function({
      Value<int> id,
      Value<TipoMovimiento> tipo,
      Value<int> montoCentimos,
      Value<DateTime> fecha,
      Value<int> categoriaId,
      Value<String?> nota,
      Value<int?> recurrenteId,
      Value<DateTime> creadoEn,
    });

final class $$MovimientosTableReferences
    extends BaseReferences<_$AppDatabase, $MovimientosTable, Movimiento> {
  $$MovimientosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('movimientos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id')!;

    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecurrentesTable _recurrenteIdTable(_$AppDatabase db) =>
      db.recurrentes.createAlias('movimientos__recurrente_id__recurrentes__id');

  $$RecurrentesTableProcessedTableManager? get recurrenteId {
    final $_column = $_itemColumn<int>('recurrente_id');
    if ($_column == null) return null;
    final manager = $$RecurrentesTableTableManager(
      $_db,
      $_db.recurrentes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurrenteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MovimientosTableFilterComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TipoMovimiento, TipoMovimiento, String>
  get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrentesTableFilterComposer get recurrenteId {
    final $$RecurrentesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenteId,
      referencedTable: $db.recurrentes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrentesTableFilterComposer(
            $db: $db,
            $table: $db.recurrentes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableOrderingComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nota => $composableBuilder(
    column: $table.nota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get creadoEn => $composableBuilder(
    column: $table.creadoEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrentesTableOrderingComposer get recurrenteId {
    final $$RecurrentesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenteId,
      referencedTable: $db.recurrentes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrentesTableOrderingComposer(
            $db: $db,
            $table: $db.recurrentes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovimientosTable> {
  $$MovimientosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TipoMovimiento, String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get nota =>
      $composableBuilder(column: $table.nota, builder: (column) => column);

  GeneratedColumn<DateTime> get creadoEn =>
      $composableBuilder(column: $table.creadoEn, builder: (column) => column);

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecurrentesTableAnnotationComposer get recurrenteId {
    final $$RecurrentesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurrenteId,
      referencedTable: $db.recurrentes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecurrentesTableAnnotationComposer(
            $db: $db,
            $table: $db.recurrentes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MovimientosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MovimientosTable,
          Movimiento,
          $$MovimientosTableFilterComposer,
          $$MovimientosTableOrderingComposer,
          $$MovimientosTableAnnotationComposer,
          $$MovimientosTableCreateCompanionBuilder,
          $$MovimientosTableUpdateCompanionBuilder,
          (Movimiento, $$MovimientosTableReferences),
          Movimiento,
          PrefetchHooks Function({bool categoriaId, bool recurrenteId})
        > {
  $$MovimientosTableTableManager(_$AppDatabase db, $MovimientosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovimientosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovimientosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovimientosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<TipoMovimiento> tipo = const Value.absent(),
                Value<int> montoCentimos = const Value.absent(),
                Value<DateTime> fecha = const Value.absent(),
                Value<int> categoriaId = const Value.absent(),
                Value<String?> nota = const Value.absent(),
                Value<int?> recurrenteId = const Value.absent(),
                Value<DateTime> creadoEn = const Value.absent(),
              }) => MovimientosCompanion(
                id: id,
                tipo: tipo,
                montoCentimos: montoCentimos,
                fecha: fecha,
                categoriaId: categoriaId,
                nota: nota,
                recurrenteId: recurrenteId,
                creadoEn: creadoEn,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required TipoMovimiento tipo,
                required int montoCentimos,
                required DateTime fecha,
                required int categoriaId,
                Value<String?> nota = const Value.absent(),
                Value<int?> recurrenteId = const Value.absent(),
                required DateTime creadoEn,
              }) => MovimientosCompanion.insert(
                id: id,
                tipo: tipo,
                montoCentimos: montoCentimos,
                fecha: fecha,
                categoriaId: categoriaId,
                nota: nota,
                recurrenteId: recurrenteId,
                creadoEn: creadoEn,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MovimientosTable, Movimiento>(table),
                  $$MovimientosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoriaId = false, recurrenteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (categoriaId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoriaId,
                                referencedTable: $$MovimientosTableReferences
                                    ._categoriaIdTable(db),
                                referencedColumn: $$MovimientosTableReferences
                                    ._categoriaIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (recurrenteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recurrenteId,
                                referencedTable: $$MovimientosTableReferences
                                    ._recurrenteIdTable(db),
                                referencedColumn: $$MovimientosTableReferences
                                    ._recurrenteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MovimientosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MovimientosTable,
      Movimiento,
      $$MovimientosTableFilterComposer,
      $$MovimientosTableOrderingComposer,
      $$MovimientosTableAnnotationComposer,
      $$MovimientosTableCreateCompanionBuilder,
      $$MovimientosTableUpdateCompanionBuilder,
      (Movimiento, $$MovimientosTableReferences),
      Movimiento,
      PrefetchHooks Function({bool categoriaId, bool recurrenteId})
    >;
typedef $$PresupuestosTableCreateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> id,
      Value<int?> categoriaId,
      required int montoCentimos,
    });
typedef $$PresupuestosTableUpdateCompanionBuilder =
    PresupuestosCompanion Function({
      Value<int> id,
      Value<int?> categoriaId,
      Value<int> montoCentimos,
    });

final class $$PresupuestosTableReferences
    extends BaseReferences<_$AppDatabase, $PresupuestosTable, Presupuesto> {
  $$PresupuestosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriasTable _categoriaIdTable(_$AppDatabase db) =>
      db.categorias.createAlias('presupuestos__categoria_id__categorias__id');

  $$CategoriasTableProcessedTableManager? get categoriaId {
    final $_column = $_itemColumn<int>('categoria_id');
    if ($_column == null) return null;
    final manager = $$CategoriasTableTableManager(
      $_db,
      $_db.categorias,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoriaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AlertasEnviadasTable, List<AlertaEnviada>>
  _alertasEnviadasRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.alertasEnviadas,
    aliasName: 'presupuestos__id__alertas_enviadas__presupuesto_id',
  );

  $$AlertasEnviadasTableProcessedTableManager get alertasEnviadasRefs {
    final manager = $$AlertasEnviadasTableTableManager(
      $_db,
      $_db.alertasEnviadas,
    ).filter((f) => f.presupuestoId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _alertasEnviadasRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PresupuestosTableFilterComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriasTableFilterComposer get categoriaId {
    final $$CategoriasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableFilterComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> alertasEnviadasRefs(
    Expression<bool> Function($$AlertasEnviadasTableFilterComposer f) f,
  ) {
    final $$AlertasEnviadasTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alertasEnviadas,
      getReferencedColumn: (t) => t.presupuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertasEnviadasTableFilterComposer(
            $db: $db,
            $table: $db.alertasEnviadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PresupuestosTableOrderingComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriasTableOrderingComposer get categoriaId {
    final $$CategoriasTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableOrderingComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PresupuestosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PresupuestosTable> {
  $$PresupuestosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get montoCentimos => $composableBuilder(
    column: $table.montoCentimos,
    builder: (column) => column,
  );

  $$CategoriasTableAnnotationComposer get categoriaId {
    final $$CategoriasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoriaId,
      referencedTable: $db.categorias,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriasTableAnnotationComposer(
            $db: $db,
            $table: $db.categorias,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> alertasEnviadasRefs<T extends Object>(
    Expression<T> Function($$AlertasEnviadasTableAnnotationComposer a) f,
  ) {
    final $$AlertasEnviadasTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.alertasEnviadas,
      getReferencedColumn: (t) => t.presupuestoId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AlertasEnviadasTableAnnotationComposer(
            $db: $db,
            $table: $db.alertasEnviadas,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PresupuestosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PresupuestosTable,
          Presupuesto,
          $$PresupuestosTableFilterComposer,
          $$PresupuestosTableOrderingComposer,
          $$PresupuestosTableAnnotationComposer,
          $$PresupuestosTableCreateCompanionBuilder,
          $$PresupuestosTableUpdateCompanionBuilder,
          (Presupuesto, $$PresupuestosTableReferences),
          Presupuesto,
          PrefetchHooks Function({bool categoriaId, bool alertasEnviadasRefs})
        > {
  $$PresupuestosTableTableManager(_$AppDatabase db, $PresupuestosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PresupuestosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PresupuestosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PresupuestosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                Value<int> montoCentimos = const Value.absent(),
              }) => PresupuestosCompanion(
                id: id,
                categoriaId: categoriaId,
                montoCentimos: montoCentimos,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> categoriaId = const Value.absent(),
                required int montoCentimos,
              }) => PresupuestosCompanion.insert(
                id: id,
                categoriaId: categoriaId,
                montoCentimos: montoCentimos,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PresupuestosTable, Presupuesto>(table),
                  $$PresupuestosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoriaId = false, alertasEnviadasRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (alertasEnviadasRefs) db.alertasEnviadas,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoriaId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoriaId,
                                    referencedTable:
                                        $$PresupuestosTableReferences
                                            ._categoriaIdTable(db),
                                    referencedColumn:
                                        $$PresupuestosTableReferences
                                            ._categoriaIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (alertasEnviadasRefs)
                        await $_getPrefetchedDataByColumns<
                          Presupuesto,
                          $PresupuestosTable,
                          AlertaEnviada,
                          $AlertasEnviadasTable
                        >(
                          currentTable: table,
                          referencedTable: $$PresupuestosTableReferences
                              ._alertasEnviadasRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PresupuestosTableReferences(
                                db,
                                table,
                                p0,
                              ).alertasEnviadasRefs,
                          currentColumn: 'id',
                          referencedColumn: 'presupuesto_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PresupuestosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PresupuestosTable,
      Presupuesto,
      $$PresupuestosTableFilterComposer,
      $$PresupuestosTableOrderingComposer,
      $$PresupuestosTableAnnotationComposer,
      $$PresupuestosTableCreateCompanionBuilder,
      $$PresupuestosTableUpdateCompanionBuilder,
      (Presupuesto, $$PresupuestosTableReferences),
      Presupuesto,
      PrefetchHooks Function({bool categoriaId, bool alertasEnviadasRefs})
    >;
typedef $$AlertasEnviadasTableCreateCompanionBuilder =
    AlertasEnviadasCompanion Function({
      required int presupuestoId,
      required String mes,
      required int umbral,
      Value<int> rowid,
    });
typedef $$AlertasEnviadasTableUpdateCompanionBuilder =
    AlertasEnviadasCompanion Function({
      Value<int> presupuestoId,
      Value<String> mes,
      Value<int> umbral,
      Value<int> rowid,
    });

final class $$AlertasEnviadasTableReferences
    extends
        BaseReferences<_$AppDatabase, $AlertasEnviadasTable, AlertaEnviada> {
  $$AlertasEnviadasTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PresupuestosTable _presupuestoIdTable(_$AppDatabase db) => db
      .presupuestos
      .createAlias('alertas_enviadas__presupuesto_id__presupuestos__id');

  $$PresupuestosTableProcessedTableManager get presupuestoId {
    final $_column = $_itemColumn<int>('presupuesto_id')!;

    final manager = $$PresupuestosTableTableManager(
      $_db,
      $_db.presupuestos,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_presupuestoIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AlertasEnviadasTableFilterComposer
    extends Composer<_$AppDatabase, $AlertasEnviadasTable> {
  $$AlertasEnviadasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get mes => $composableBuilder(
    column: $table.mes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get umbral => $composableBuilder(
    column: $table.umbral,
    builder: (column) => ColumnFilters(column),
  );

  $$PresupuestosTableFilterComposer get presupuestoId {
    final $$PresupuestosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableFilterComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertasEnviadasTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertasEnviadasTable> {
  $$AlertasEnviadasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get mes => $composableBuilder(
    column: $table.mes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get umbral => $composableBuilder(
    column: $table.umbral,
    builder: (column) => ColumnOrderings(column),
  );

  $$PresupuestosTableOrderingComposer get presupuestoId {
    final $$PresupuestosTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableOrderingComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertasEnviadasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertasEnviadasTable> {
  $$AlertasEnviadasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get mes =>
      $composableBuilder(column: $table.mes, builder: (column) => column);

  GeneratedColumn<int> get umbral =>
      $composableBuilder(column: $table.umbral, builder: (column) => column);

  $$PresupuestosTableAnnotationComposer get presupuestoId {
    final $$PresupuestosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.presupuestoId,
      referencedTable: $db.presupuestos,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PresupuestosTableAnnotationComposer(
            $db: $db,
            $table: $db.presupuestos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AlertasEnviadasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertasEnviadasTable,
          AlertaEnviada,
          $$AlertasEnviadasTableFilterComposer,
          $$AlertasEnviadasTableOrderingComposer,
          $$AlertasEnviadasTableAnnotationComposer,
          $$AlertasEnviadasTableCreateCompanionBuilder,
          $$AlertasEnviadasTableUpdateCompanionBuilder,
          (AlertaEnviada, $$AlertasEnviadasTableReferences),
          AlertaEnviada,
          PrefetchHooks Function({bool presupuestoId})
        > {
  $$AlertasEnviadasTableTableManager(
    _$AppDatabase db,
    $AlertasEnviadasTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertasEnviadasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertasEnviadasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertasEnviadasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> presupuestoId = const Value.absent(),
                Value<String> mes = const Value.absent(),
                Value<int> umbral = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlertasEnviadasCompanion(
                presupuestoId: presupuestoId,
                mes: mes,
                umbral: umbral,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int presupuestoId,
                required String mes,
                required int umbral,
                Value<int> rowid = const Value.absent(),
              }) => AlertasEnviadasCompanion.insert(
                presupuestoId: presupuestoId,
                mes: mes,
                umbral: umbral,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AlertasEnviadasTable, AlertaEnviada>(table),
                  $$AlertasEnviadasTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({presupuestoId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (presupuestoId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.presupuestoId,
                                referencedTable:
                                    $$AlertasEnviadasTableReferences
                                        ._presupuestoIdTable(db),
                                referencedColumn:
                                    $$AlertasEnviadasTableReferences
                                        ._presupuestoIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AlertasEnviadasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertasEnviadasTable,
      AlertaEnviada,
      $$AlertasEnviadasTableFilterComposer,
      $$AlertasEnviadasTableOrderingComposer,
      $$AlertasEnviadasTableAnnotationComposer,
      $$AlertasEnviadasTableCreateCompanionBuilder,
      $$AlertasEnviadasTableUpdateCompanionBuilder,
      (AlertaEnviada, $$AlertasEnviadasTableReferences),
      AlertaEnviada,
      PrefetchHooks Function({bool presupuestoId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriasTableTableManager get categorias =>
      $$CategoriasTableTableManager(_db, _db.categorias);
  $$RecurrentesTableTableManager get recurrentes =>
      $$RecurrentesTableTableManager(_db, _db.recurrentes);
  $$MovimientosTableTableManager get movimientos =>
      $$MovimientosTableTableManager(_db, _db.movimientos);
  $$PresupuestosTableTableManager get presupuestos =>
      $$PresupuestosTableTableManager(_db, _db.presupuestos);
  $$AlertasEnviadasTableTableManager get alertasEnviadas =>
      $$AlertasEnviadasTableTableManager(_db, _db.alertasEnviadas);
}
