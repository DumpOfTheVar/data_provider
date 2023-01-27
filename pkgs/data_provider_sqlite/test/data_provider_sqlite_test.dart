import 'package:data_provider/data_provider.dart';
import 'package:data_provider_sqlite/data_provider_sqlite.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
@GenerateNiceMocks([MockSpec<Database>(), MockSpec<Batch>()])
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'data_provider_sqlite_test.mocks.dart';

void main() {
  group('sqlite unary operator mapper', () {
    test('maps unary minus', () {
      final mapper = SqliteUnaryOperatorMapper();
      final operator = UnaryMinus();
      final x = SqliteExpression('42', []);
      final y = SqliteExpression('some_field + ?', ['42']);
      final z = SqliteExpression('? + ?', ['42', '100']);

      final mappedOperator = mapper.map(operator);
      final expression1 = mappedOperator(x);
      final expression2 = mappedOperator(y);
      final expression3 = mappedOperator(z);

      expect(expression1.expression, '-(${x.expression})');
      expect(expression1.args, x.args);
      expect(expression2.expression, '-(${y.expression})');
      expect(expression2.args, y.args);
      expect(expression3.expression, '-(${z.expression})');
      expect(expression3.args, z.args);
    });

    test('maps unary minus', () {
      final mapper = SqliteUnaryOperatorMapper();
      final operator1 = Substring(3);
      final operator2 = Substring(2, 5);
      final x = SqliteExpression('"Test"', []);
      final y = SqliteExpression('CONCAT(some_field, ?)', ['Test']);
      final z = SqliteExpression('CONCAT(?, ?)', ['Test', 'Test_2']);

      final mappedOperator1 = mapper.map(operator1);
      final mappedOperator2 = mapper.map(operator2);
      final expression1 = mappedOperator1(x);
      final expression2 = mappedOperator1(y);
      final expression3 = mappedOperator1(z);
      final expression4 = mappedOperator2(x);
      final expression5 = mappedOperator2(y);
      final expression6 = mappedOperator2(z);

      expect(expression1.expression, 'SUBSTR(${x.expression}, 3)');
      expect(expression1.args, x.args);
      expect(expression2.expression, 'SUBSTR(${y.expression}, 3)');
      expect(expression2.args, y.args);
      expect(expression3.expression, 'SUBSTR(${z.expression}, 3)');
      expect(expression3.args, z.args);
      expect(expression4.expression, 'SUBSTR(${x.expression}, 2, 3)');
      expect(expression4.args, x.args);
      expect(expression5.expression, 'SUBSTR(${y.expression}, 2, 3)');
      expect(expression5.args, y.args);
      expect(expression6.expression, 'SUBSTR(${z.expression}, 2, 3)');
      expect(expression6.args, z.args);
    });

    test('throws exception on not supported unary operator', () {
      final mapper = SqliteUnaryOperatorMapper();
      final operator = NotSupportedUnaryOperator();

      expect(() => mapper.map(operator), throwsException);
    });
  });

  group('sqlite binary operator mapper', () {
    test('maps equals operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Equals();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) = (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps less operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Less();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) < (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps less or equals operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = LessOrEquals();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) <= (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps greater operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Greater();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) > (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps greater or equals operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = GreaterOrEquals();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) >= (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps plus operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Plus();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) + (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps minus operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Minus();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) - (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps multiply operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Multiply();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) * (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps plus operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Divide();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression,
          'CAST(${e1.expression} AS FLOAT) / (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps integer divide operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = IntDivide();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) / (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps modulo operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Modulo();
      final e1 = SqliteExpression('some_field + ?', ['42']);
      final e2 = SqliteExpression('? + ?', ['0', '100']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(expression.expression, '(${e1.expression}) % (${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('maps concat operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = Concat();
      final e1 = SqliteExpression('?', ['Test']);
      final e2 = SqliteExpression('CONCAT(?, ?)', ['Tes', 'Test_2']);

      final mappedOperator = mapper.map(operator);
      final expression = mappedOperator(e1, e2);

      expect(
          expression.expression, 'CONCAT(${e1.expression}, ${e2.expression})');
      expect(expression.args, List<String>.from(e1.args)..addAll(e2.args));
    });

    test('throws exception on not supported binary operator', () {
      final mapper = SqliteBinaryOperatorMapper();
      final operator = NotSupportedBinaryOperator();

      expect(() => mapper.map(operator), throwsException);
    });
  });

  group('sqlite projector mapper', () {
    test('maps const value projector', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final mapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final projector1 = ConstValue(42);
      final projector2 = ConstValue('Test');
      final projector3 = ConstValue(true);

      final expression1 = mapper.map(projector1);
      final expression2 = mapper.map(projector2);
      final expression3 = mapper.map(projector3);

      expect(expression1.expression, '?');
      expect(expression1.args, ['42']);
      expect(expression2.expression, '?');
      expect(expression2.args, ['Test']);
      expect(expression3.expression, '1');
      expect(expression3.args, []);
    });

    test('maps const value projector', () {
      final dataConverter = DataConverter(
        fieldMap: {
          'field1': 'field1',
          'anotherField': 'another_field',
        },
      );
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final mapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final projector1 = FieldValue('field1');
      final projector2 = FieldValue('field2');
      final projector3 = FieldValue('anotherField');

      final expression1 = mapper.map(projector1);
      final expression2 = mapper.map(projector2);
      final expression3 = mapper.map(projector3);

      expect(expression1.expression, 'field1');
      expect(expression1.args, []);
      expect(expression2.expression, 'field2');
      expect(expression2.args, []);
      expect(expression3.expression, 'another_field');
      expect(expression3.args, []);
    });

    test('maps unary expression projector', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final mapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final projector1 = UnaryExpression(UnaryMinus(), ConstValue(42));
      final projector2 = UnaryExpression(UnaryMinus(), FieldValue('test'));

      final expression1 = mapper.map(projector1);
      final expression2 = mapper.map(projector2);

      expect(expression1.expression, '-(?)');
      expect(expression1.args, ['42']);
      expect(expression2.expression, '-(test)');
      expect(expression2.args, []);
    });

    test('maps binary expression projector', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final mapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final p1 = FieldValue('test');
      final p2 = ConstValue(42);
      final projector = BinaryExpression(Plus(), p1, p2);

      final expression = mapper.map(projector);

      expect(expression.expression, '(test) + (?)');
      expect(expression.args, ['42']);
    });

    test('throws exception on not supported projector', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final mapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final projector = NotSupportedProjector();

      expect(() => mapper.map(projector), throwsException);
    });
  });

  group('sqlite specification mapper', () {
    test('maps null', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );

      final expression = mapper.map(null);

      expect(expression.expression, '1');
      expect(expression.args, []);
    });

    test('maps custom specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification1 = CustomSpecificationStub(True());
      final specification2 = CustomSpecificationStub(False());

      final expression1 = mapper.map(specification1);
      final expression2 = mapper.map(specification2);

      expect(expression1.expression, '1');
      expect(expression1.args, []);
      expect(expression2.expression, '0');
      expect(expression2.args, []);
    });

    test('maps true specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification = True();

      final expression = mapper.map(specification);

      expect(expression.expression, '1');
      expect(expression.args, []);
    });

    test('maps false specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification = False();

      final expression = mapper.map(specification);

      expect(expression.expression, '0');
      expect(expression.args, []);
    });

    test('maps not specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification1 = Not(True());
      final specification2 = Not(False());

      final expression1 = mapper.map(specification1);
      final expression2 = mapper.map(specification2);

      expect(expression1.expression, 'NOT (1)');
      expect(expression1.args, []);
      expect(expression2.expression, 'NOT (0)');
      expect(expression2.args, []);
    });

    test('maps and specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification1 = And([]);
      final specification2 = And([True()]);
      final specification3 = And([False()]);
      final specification4 = And([True(), True(), True()]);
      final specification5 = And([True(), False(), True()]);
      final specification6 = And([False(), True(), False()]);
      final specification7 = And([False(), False(), False()]);

      final expression1 = mapper.map(specification1);
      final expression2 = mapper.map(specification2);
      final expression3 = mapper.map(specification3);
      final expression4 = mapper.map(specification4);
      final expression5 = mapper.map(specification5);
      final expression6 = mapper.map(specification6);
      final expression7 = mapper.map(specification7);

      expect(expression1.expression, '1');
      expect(expression1.args, []);
      expect(expression2.expression, '(1)');
      expect(expression2.args, []);
      expect(expression3.expression, '(0)');
      expect(expression3.args, []);
      expect(expression4.expression, '(1) AND (1) AND (1)');
      expect(expression4.args, []);
      expect(expression5.expression, '(1) AND (0) AND (1)');
      expect(expression5.args, []);
      expect(expression6.expression, '(0) AND (1) AND (0)');
      expect(expression6.args, []);
      expect(expression7.expression, '(0) AND (0) AND (0)');
      expect(expression7.args, []);
    });

    test('maps or specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification1 = Or([]);
      final specification2 = Or([True()]);
      final specification3 = Or([False()]);
      final specification4 = Or([True(), True(), True()]);
      final specification5 = Or([True(), False(), True()]);
      final specification6 = Or([False(), True(), False()]);
      final specification7 = Or([False(), False(), False()]);

      final expression1 = mapper.map(specification1);
      final expression2 = mapper.map(specification2);
      final expression3 = mapper.map(specification3);
      final expression4 = mapper.map(specification4);
      final expression5 = mapper.map(specification5);
      final expression6 = mapper.map(specification6);
      final expression7 = mapper.map(specification7);

      expect(expression1.expression, '0');
      expect(expression1.args, []);
      expect(expression2.expression, '(1)');
      expect(expression2.args, []);
      expect(expression3.expression, '(0)');
      expect(expression3.args, []);
      expect(expression4.expression, '(1) OR (1) OR (1)');
      expect(expression4.args, []);
      expect(expression5.expression, '(1) OR (0) OR (1)');
      expect(expression5.args, []);
      expect(expression6.expression, '(0) OR (1) OR (0)');
      expect(expression6.args, []);
      expect(expression7.expression, '(0) OR (0) OR (0)');
      expect(expression7.args, []);
    });

    test('throws exception on not supported composite specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification = NotSupportedCompositeSpecification([]);

      expect(() => mapper.map(specification), throwsException);
    });

    test('maps compare specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification = Compare(
        operator: Equals(),
        projector1: ConstValue(42),
        projector2: ConstValue(100),
      );

      final expression = mapper.map(specification);

      expect(expression.expression, '(?) = (?)');
      expect(expression.args, ['42', '100']);
    });

    test('throws exception on not supported specification', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSpecificationMapper(
        projectorMapper: projectorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final specification = NotSupportedSpecification();

      expect(() => mapper.map(specification), throwsException);
    });
  });

  group('sqlite sorter mapper', () {
    test('maps null', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );

      final orderBy = mapper.map(null);

      expect(orderBy, null);
    });

    test('maps value sorter', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );
      final sorter1 = ValueSorter(FieldValue('test'));
      final sorter2 = ValueSorter(FieldValue('test'), true);
      final sorter3 = ValueSorter(FieldValue('test'), false);

      final orderBy1 = mapper.map(sorter1);
      final orderBy2 = mapper.map(sorter2);
      final orderBy3 = mapper.map(sorter3);

      expect(orderBy1, 'test ASC');
      expect(orderBy2, 'test ASC');
      expect(orderBy3, 'test DESC');
    });

    test('throws exception if args required', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );
      final sorter = ValueSorter(ConstValue(42));

      expect(() => mapper.map(sorter), throwsException);
    });

    test('maps composite sorter', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );
      final sorter = CompositeSorter([
        ValueSorter(FieldValue('field1')),
        ValueSorter(FieldValue('field2'), true),
        ValueSorter(FieldValue('field3'), false),
      ]);

      final orderBy = mapper.map(sorter);

      expect(orderBy, 'field1 ASC, field2 ASC, field3 DESC');
    });

    test('maps composite sorter', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );
      final sorter = CustomSorterStub(ValueSorter(FieldValue('field')));

      final orderBy = mapper.map(sorter);

      expect(orderBy, 'field ASC');
    });

    test('throws exception on not supported sorter', () {
      final dataConverter = DataConverter();
      final unaryOperatorMapper = SqliteUnaryOperatorMapper();
      final binaryOperatorMapper = SqliteBinaryOperatorMapper();
      final projectorMapper = SqliteProjectorMapper(
        dataConverter: dataConverter,
        unaryOperatorMapper: unaryOperatorMapper,
        binaryOperatorMapper: binaryOperatorMapper,
      );
      final mapper = SqliteSorterMapper(
        projectorMapper: projectorMapper,
      );
      final sorter = NotSupportedSorter();

      expect(() => mapper.map(sorter), throwsException);
    });
  });

  group('sqlite data provider', () {
    test('find by id', () async {
      final db = MockDatabase();
      final data = [
        {
          'id': 1,
          'title': 'Test',
        },
        {
          'id': 2,
          'title': 'Test_2',
        },
      ];
      when(db.query('test_table', where: 'id = ?', whereArgs: ['42'], limit: 1))
          .thenAnswer((_) => Future.value([data[0]]));
      final dataProvider = makeDataProvider(db);

      final result = await dataProvider.findById('42');

      verify(db.query('test_table',
              where: 'id = ?', whereArgs: ['42'], limit: 1))
          .called(1);
      expect(result, data[0]);
    });

    test('find one', () async {
      final db = MockDatabase();
      final data = [
        {
          'id': 1,
          'title': 'Test',
        },
        {
          'id': 2,
          'title': 'Test_2',
        },
      ];
      when(db.query('test_table',
              where: '(id) = (?)',
              whereArgs: ['42'],
              orderBy: 'id ASC, title DESC',
              limit: 1))
          .thenAnswer((_) => Future.value([data[0]]));
      final dataProvider = makeDataProvider(db);

      final result = await dataProvider.findOne(
        specification: CompareFieldValue(
          field: 'id',
          value: 42,
          operator: Equals(),
        ),
        sorter: FieldSorter({'id': true, 'title': false}),
      );

      verify(db.query('test_table',
              where: '(id) = (?)',
              whereArgs: ['42'],
              orderBy: 'id ASC, title DESC',
              limit: 1))
          .called(1);
      expect(result, data[0]);
    });

    test('find all without params', () async {
      final db = MockDatabase();
      final data = [
        {
          'id': 1,
          'title': 'Test',
        },
        {
          'id': 2,
          'title': 'Test_2',
        },
      ];
      when(db.query('test_table', where: '1', whereArgs: []))
          .thenAnswer((_) => Future.value(data));
      final dataProvider = makeDataProvider(db);

      final result = await dataProvider.findAll();

      verify(db.query('test_table', where: '1', whereArgs: [])).called(1);
      expect(result, data);
    });

    test('find all with params', () async {
      final db = MockDatabase();
      final data = [
        {
          'id': 1,
          'title': 'Test',
        },
        {
          'id': 2,
          'title': 'Test_2',
        },
      ];
      when(db.query('test_table',
              where: '(id) = (?)',
              whereArgs: ['42'],
              orderBy: 'id ASC, title DESC',
              limit: 3,
              offset: 2))
          .thenAnswer((_) => Future.value(data));
      final dataProvider = makeDataProvider(db);

      final result = await dataProvider.findAll(
        specification: CompareFieldValue(
          field: 'id',
          value: 42,
          operator: Equals(),
        ),
        sorter: FieldSorter({'id': true, 'title': false}),
        limit: 3,
        offset: 2,
      );

      verify(db.query('test_table',
              where: '(id) = (?)',
              whereArgs: ['42'],
              orderBy: 'id ASC, title DESC',
              limit: 3,
              offset: 2))
          .called(1);
      expect(result, data);
    });

    test('save one', () async {
      final db = MockDatabase();
      final dataProvider = makeDataProvider(db);
      final json = {'id': 1, 'title': 'Test'};

      await dataProvider.saveOne(json);

      verify(db.insert('test_table', json,
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
    });

    test('save all', () async {
      final db = MockDatabase();
      final batch = MockBatch();
      when(db.batch()).thenReturn(batch);
      final dataProvider = makeDataProvider(db);
      final data = [
        {
          'id': 1,
          'title': 'Test',
        },
        {
          'id': 2,
          'title': 'Test_2',
        },
      ];

      await dataProvider.saveAll(data);

      verify(db.batch()).called(1);
      verify(batch.insert('test_table', data[0],
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
      verify(batch.insert('test_table', data[1],
              conflictAlgorithm: ConflictAlgorithm.replace))
          .called(1);
      verify(batch.commit()).called(1);
    });

    test('delete by id', () async {
      final db = MockDatabase();
      final dataProvider = makeDataProvider(db);

      await dataProvider.deleteById('42');

      verify(db.delete('test_table', where: 'id = ?', whereArgs: ['42']))
          .called(1);
    });

    test('delete all', () async {
      final db = MockDatabase();
      final dataProvider = makeDataProvider(db);

      await dataProvider.deleteAll(CompareFieldValue(
        field: 'id',
        value: 42,
        operator: Equals(),
      ));

      verify(db.delete('test_table', where: '(id) = (?)', whereArgs: ['42']))
          .called(1);
    });
  });

  group('sqlite data provider builder', () {
    test('creates sqlite data provider', () {
      final config = {
        'db': 'test_db',
        'entities': {
          'Entity': {
            'table': 'entity',
            'fields': {
              'id': {
                'type': int,
                'column': 'id',
                'converter': DefaultValueConverter(),
              },
            },
          },
        },
      };
      final migrations = ['CREATE TABLE entity(id INT PRIMARY KEY);'];
      final dataProvider = buildSqliteDataProvider<Entity>(config, migrations);
      expect(dataProvider, isA<SqliteDataProvider>());
    });
  });
}

DataProvider makeDataProvider(Database db) {
  final dataConverter = DataConverter();
  final unaryOperatorMapper = SqliteUnaryOperatorMapper();
  final binaryOperatorMapper = SqliteBinaryOperatorMapper();
  final projectorMapper = SqliteProjectorMapper(
    dataConverter: dataConverter,
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
    dbFactory: () => Future.value(db),
    tableName: 'test_table',
    specificationMapper: specificationMapper,
    sorterMapper: sorterMapper,
    dataConverter: dataConverter,
  );
}

class NotSupportedUnaryOperator extends UnaryOperator {
  @override
  apply(a) {
    return null;
  }
}

class NotSupportedBinaryOperator extends BinaryOperator {
  @override
  apply(a, b) {
    return null;
  }
}

class NotSupportedProjector extends Projector {
  @override
  project(entity) {
    return null;
  }
}

class CustomSpecificationStub extends CustomSpecification {
  CustomSpecificationStub(this.normalized);

  final Specification normalized;

  @override
  Specification normalize() {
    return normalized;
  }
}

class CustomSorterStub extends CustomSorter {
  CustomSorterStub(this.normalized);

  final Sorter normalized;

  @override
  Sorter normalize() {
    return normalized;
  }
}

class NotSupportedSpecification extends Specification {
  @override
  bool isSatisfiedBy(entity) {
    return false;
  }
}

class NotSupportedCompositeSpecification extends CompositeSpecification {
  NotSupportedCompositeSpecification(super.children);

  @override
  bool isSatisfiedBy(entity) {
    return false;
  }
}

class NotSupportedSorter extends Sorter {
  @override
  int compare(a, b) {
    return 0;
  }
}

class Entity implements Serializable {
  Entity({required this.id});
  factory Entity.fromJson(json) => Entity(id: json['id']);

  final int id;

  @override
  Map<String, dynamic> toJson() => {'id': id};
}
