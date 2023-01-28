import 'package:data_provider/data_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDataProvider extends DataProvider {
  SqliteDataProvider({
    required this.dbFactory,
    required this.tableName,
    required this.specificationMapper,
    required this.sorterMapper,
    required this.dataConverter,
  });

  final Future<Database> Function() dbFactory;
  final String tableName;
  final SqliteSpecificationMapper specificationMapper;
  final SqliteSorterMapper sorterMapper;
  final DataConverter dataConverter;
  Database? _db;

  @override
  Future<EntityMap?> findById(String id) async {
    final db = await _getDb();
    final field = dataConverter.convertFieldToData('id');
    final result = await db.query(
      tableName,
      where: '$field = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return dataConverter.convertFromData(result[0]);
  }

  @override
  Future<EntityMap?> findOne({
    required Specification specification,
    Sorter? sorter,
  }) async {
    final db = await _getDb();
    final whereExpr = specificationMapper.map(specification);
    final orderBy = sorterMapper.map(sorter);
    final result = await db.query(
      tableName,
      where: whereExpr.expression,
      whereArgs: whereExpr.args,
      orderBy: orderBy,
      limit: 1,
    );
    if (result.isEmpty) {
      return null;
    }
    return dataConverter.convertFromData(result[0]);
  }

  @override
  Future<List<EntityMap>> findAll({
    Specification? specification,
    Sorter? sorter,
    int? limit,
    int? offset,
  }) async {
    final db = await _getDb();
    final whereExpr = specificationMapper.map(specification);
    final orderBy = sorterMapper.map(sorter);
    final data = await db.query(
      tableName,
      where: whereExpr.expression,
      whereArgs: whereExpr.args,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    return data.map(dataConverter.convertFromData).toList();
  }

  @override
  Future<void> saveOne(EntityMap map) async {
    final db = await _getDb();
    final row = dataConverter.convertToData(map);
    await db.insert(tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> saveAll(List<EntityMap> maps) async {
    if (maps.isEmpty) {
      return;
    }
    final db = await _getDb();
    final batch = db.batch();
    for (final map in maps) {
      final row = dataConverter.convertToData(map);
      batch.insert(tableName, row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }

  @override
  Future<void> deleteById(String id) async {
    final db = await _getDb();
    final field = dataConverter.convertFieldToData('id');
    await db.delete(
      tableName,
      where: '$field = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAll(Specification specification) async {
    final db = await _getDb();
    final whereExpr = specificationMapper.map(specification);
    await db.delete(
      tableName,
      where: whereExpr.expression,
      whereArgs: whereExpr.args,
    );
  }

  Future<Database> _getDb() async {
    return _db ??= await dbFactory();
  }
}

class SqliteExpression {
  SqliteExpression(this.expression, this.args);

  final String expression;
  final List<String> args;
}

typedef SqliteUnaryOperator = SqliteExpression Function(SqliteExpression);
typedef SqliteBinaryOperator = SqliteExpression Function(
    SqliteExpression, SqliteExpression);

class SqliteValueConverter implements ValueConverter {
  const SqliteValueConverter();

  final numConverter = const NumToStringValueConverter();
  final boolConverter = const BoolToStringValueConverter();
  final dateTimeConverter = const DateTimeToStringValueConverter();
  final jsonConverter = const JsonToStringValueConverter();

  @override
  String convertToData(Object? value) {
    if (value is String) {
      return value;
    }
    if (value is num) {
      return numConverter.convertToData(value);
    }
    if (value is bool) {
      return boolConverter.convertToData(value);
    }
    if (value is DateTime) {
      return dateTimeConverter.convertToData(value);
    }
    if (value is List || value is Map) {
      return jsonConverter.convertToData(value);
    }
    throw TypeNotSupportedException('SqliteDataProvider does not support '
        'value type ${value.runtimeType}.');
  }

  @override
  Object? convertFromData(Object? value) => value;
}

class SqliteUnaryOperatorMapper
    implements UnaryOperatorMapper<SqliteUnaryOperator> {
  const SqliteUnaryOperatorMapper();

  @override
  SqliteUnaryOperator map(UnaryOperator operator) {
    if (operator is UnaryMinus) {
      return (SqliteExpression e) =>
          SqliteExpression('-(${e.expression})', e.args);
    }
    if (operator is Substring) {
      final start = operator.start;
      final end = operator.end;
      if (end == null) {
        return (SqliteExpression e) =>
            SqliteExpression('SUBSTR(${e.expression}, $start)', e.args);
      }
      final length = end - start;
      return (SqliteExpression e) =>
          SqliteExpression('SUBSTR(${e.expression}, $start, $length)', e.args);
    }
    throw TypeNotSupportedException(
      'SqliteDataProvider does not support '
      'operator type ${operator.runtimeType}.',
    );
  }
}

class SqliteBinaryOperatorMapper
    implements BinaryOperatorMapper<SqliteBinaryOperator> {
  const SqliteBinaryOperatorMapper();

  final operatorMap = const {
    '==': '=',
    '<': '<',
    '<=': '<=',
    '>': '>',
    '>=': '>=',
    '+': '+',
    '-': '-',
    '*': '*',
    '/': '/',
    '~/': '/',
    '%': '%',
  };

  @override
  SqliteBinaryOperator map(BinaryOperator operator) {
    final symbol = operator.toString();
    if (operatorMap.containsKey(symbol)) {
      var op = operatorMap[symbol];
      return (SqliteExpression e1, SqliteExpression e2) {
        final expr1 = symbol == '/'
            ? 'CAST(${e1.expression} AS FLOAT)'
            : '(${e1.expression})';
        final expr2 = '(${e2.expression})';
        final args = List<String>.from(e1.args)..addAll(e2.args);
        return SqliteExpression('$expr1 $op $expr2', args);
      };
    }
    if (operator is Concat) {
      return (SqliteExpression e1, SqliteExpression e2) {
        final args = List<String>.from(e1.args)..addAll(e2.args);
        return SqliteExpression(
            'CONCAT(${e1.expression}, ${e2.expression})', args);
      };
    }
    throw TypeNotSupportedException(
      'SqliteDataProvider does not support '
      'operator type ${operator.runtimeType}.',
    );
  }
}

class SqliteProjectorMapper implements ProjectorMapper<SqliteExpression> {
  const SqliteProjectorMapper({
    required this.dataConverter,
    required this.valueConverter,
    required this.unaryOperatorMapper,
    required this.binaryOperatorMapper,
  });

  final DataConverter dataConverter;
  final SqliteValueConverter valueConverter;
  final SqliteUnaryOperatorMapper unaryOperatorMapper;
  final SqliteBinaryOperatorMapper binaryOperatorMapper;

  @override
  SqliteExpression map(Projector projector) {
    if (projector is ConstValue) {
      return SqliteExpression(
          '?', [valueConverter.convertToData(projector.value)]);
    }
    if (projector is FieldValue) {
      final field = dataConverter.convertFieldToData(projector.field);
      return SqliteExpression(field, []);
    }
    if (projector is UnaryExpression) {
      final p = map(projector.p);
      final operator = unaryOperatorMapper.map(projector.operator);
      return operator(p);
    }
    if (projector is BinaryExpression) {
      final p1 = map(projector.p1);
      final p2 = map(projector.p2);
      final operator = binaryOperatorMapper.map(projector.operator);
      return operator(p1, p2);
    }
    throw TypeNotSupportedException(
      'SqliteDataProvider does not support '
      'projector type ${projector.runtimeType}.',
    );
  }
}

class SqliteSpecificationMapper
    implements SpecificationMapper<SqliteExpression> {
  const SqliteSpecificationMapper({
    required this.projectorMapper,
    required this.binaryOperatorMapper,
  });

  final SqliteProjectorMapper projectorMapper;
  final SqliteBinaryOperatorMapper binaryOperatorMapper;

  @override
  SqliteExpression map(Specification? specification) {
    if (specification == null) {
      return SqliteExpression('1', <String>[]);
    }
    if (specification is True) {
      return SqliteExpression('1', <String>[]);
    }
    if (specification is False) {
      return SqliteExpression('0', <String>[]);
    }
    if (specification is Not) {
      final child = map(specification.child);
      return SqliteExpression('NOT (${child.expression})', child.args);
    }
    if (specification is CompositeSpecification) {
      final operator;
      if (specification is And) {
        if (specification.children.isEmpty) {
          return SqliteExpression('1', []);
        }
        operator = 'AND';
      } else if (specification is Or) {
        if (specification.children.isEmpty) {
          return SqliteExpression('0', []);
        }
        operator = 'OR';
      } else {
        throw TypeNotSupportedException('SqliteDataProvider does not support '
            'specification type ${specification.runtimeType}.');
      }
      final List<String> expressions = [];
      final List<String> args = <String>[];
      for (final child in specification.children) {
        final expression = map(child);
        expressions.add(expression.expression);
        args.addAll(expression.args);
      }
      return SqliteExpression('(${expressions.join(') $operator (')})', args);
    }
    if (specification is Compare) {
      final p1 = projectorMapper.map(specification.projector1);
      final p2 = projectorMapper.map(specification.projector2);
      final operator = binaryOperatorMapper.map(specification.operator);
      return operator(p1, p2);
    }
    if (specification is CustomSpecification) {
      return map(specification.normalize());
    }
    throw TypeNotSupportedException('SqliteDataProvider does not support '
        'specification type ${specification.runtimeType}.');
  }
}

class SqliteSorterMapper implements SorterMapper<String?> {
  const SqliteSorterMapper({required this.projectorMapper});

  final SqliteProjectorMapper projectorMapper;

  @override
  String? map(Sorter? sorter) {
    if (sorter == null) {
      return null;
    }
    if (sorter is CustomSorter) {
      return map(sorter.normalize());
    }
    if (sorter is CompositeSorter) {
      return sorter.children.map(map).where((s) => s != null).join(', ');
    }
    if (sorter is ValueSorter) {
      final expression = projectorMapper.map(sorter.projector);
      final asc = sorter.isAsc ? 'ASC' : 'DESC';
      if (expression.args.isNotEmpty) {
        throw DataProviderException('SqliteDataProvider does not support '
            'sorting with parameters.');
      }
      return '${expression.expression} $asc';
    }
    throw TypeNotSupportedException('SqliteDataProvider does not support '
        'sorter type ${sorter.runtimeType}.');
  }
}

SqliteDataProvider buildSqliteDataProvider<T>(
  Map config,
  List<String> migrations,
) {
  final dbName = config['db'];
  final entity = config['entities'][T.toString()];
  if (entity == null) {
    throw Exception('Config for entity ${T.toString()} not found.');
  }
  final tableName = entity['table'];
  final fields = entity['fields'];
  final fieldMap = <String, String>{};
  final valueMap = <String, ValueConverter>{};
  for (final field in fields.keys) {
    fieldMap[field] = fields[field]['column'];
    valueMap[field] = fields[field]['converter'];
  }
  final dataConverter = DataConverter(
    fieldMap: fieldMap,
    valueMap: valueMap,
  );
  final valueConverter = SqliteValueConverter();
  final unaryOperatorMapper = SqliteUnaryOperatorMapper();
  final binaryOperatorMapper = SqliteBinaryOperatorMapper();
  final projectorMapper = SqliteProjectorMapper(
    dataConverter: dataConverter,
    valueConverter: valueConverter,
    unaryOperatorMapper: unaryOperatorMapper,
    binaryOperatorMapper: binaryOperatorMapper,
  );
  final specificationMapper = SqliteSpecificationMapper(
    projectorMapper: projectorMapper,
    binaryOperatorMapper: binaryOperatorMapper,
  );
  final sorterMapper = SqliteSorterMapper(
    projectorMapper: projectorMapper,
  );
  return SqliteDataProvider(
    dbFactory: () async => _buildDb(dbName, migrations),
    tableName: tableName,
    dataConverter: dataConverter,
    specificationMapper: specificationMapper,
    sorterMapper: sorterMapper,
  );
}

Future<Database> _buildDb(String dbName, List<String> migrations) async {
  return openDatabase(
    join(await getDatabasesPath(), dbName),
    onCreate: (db, version) => _migrate(db, 0, version, migrations),
    onUpgrade: (db, oldVer, newVer) => _migrate(db, oldVer, newVer, migrations),
    version: migrations.length,
  );
}

Future<void> _migrate(
  Database db,
  int oldVersion,
  int newVersion,
  List<String> migrations,
) async {
  if (newVersion <= oldVersion) {
    return;
  }
  migrations
      .sublist(oldVersion)
      .forEach((migration) async => await db.execute(migration));
}
