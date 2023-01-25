import 'package:data_provider/data_provider.dart';
import 'package:data_provider/src/data_provider/in_memory.dart';
import 'package:test/test.dart';

void main() {
  group('in memory projector mapper', () {
    test('maps const value projector', () {
      final mapper = InMemoryProjectorMapper();
      final entity = EntityStub('', 0, false);
      final projector1 = ConstValue<EntityStub, String>('Test');
      final projector2 = ConstValue<EntityStub, num>(42);
      final projector3 = ConstValue<EntityStub, bool>(true);

      final mappedProjector1 = mapper.map(projector1);
      final mappedProjector2 = mapper.map(projector2);
      final mappedProjector3 = mapper.map(projector3);

      expect(mappedProjector1(entity.toJson()), 'Test');
      expect(mappedProjector2(entity.toJson()), 42);
      expect(mappedProjector3(entity.toJson()), true);
    });

    test('maps unary expression projector', () {
      final mapper = InMemoryProjectorMapper();
      final p = FieldValue<EntityStub, num>('b');
      final projector = UnaryExpression(UnaryMinus(), p);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test', -100, true);
      final z = EntityStub('Test', 0, true);

      final mappedProjector = mapper.map(projector);

      expect(mappedProjector(x.toJson()), -42);
      expect(mappedProjector(y.toJson()), 100);
      expect(mappedProjector(z.toJson()), 0);
    });

    test('maps binary expression projector', () {
      final mapper = InMemoryProjectorMapper();
      final p1 = ConstValue<EntityStub, num>(36.6);
      final p2 = FieldValue<EntityStub, num>('b');
      final projector = BinaryExpression(Plus(), p1, p2);
      final x = EntityStub('', 42, true);
      final y = EntityStub('Test', -100, false);
      final z = EntityStub('Test_2', 0, true);

      final mappedProjector = mapper.map(projector);

      expect(mappedProjector(x.toJson()), 42 + 36.6);
      expect(mappedProjector(y.toJson()), -100 + 36.6);
      expect(mappedProjector(z.toJson()), 0 + 36.6);
    });

    test('throws expression on not supported projector', () {
      final mapper = InMemoryProjectorMapper();
      final projector = NotSupportedProjector();

      expect(() => mapper.map(projector), throwsException);
    });
  });

  group('in memory specification mapper', () {
    test('maps null', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification = null;
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification = mapper.map(specification);

      expect(mappedSpecification(x.toJson()), true);
      expect(mappedSpecification(y.toJson()), true);
      expect(mappedSpecification(z.toJson()), true);
    });

    test('maps true specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification = True<EntityStub>();
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification = mapper.map(specification);

      expect(mappedSpecification(x.toJson()), true);
      expect(mappedSpecification(y.toJson()), true);
      expect(mappedSpecification(z.toJson()), true);
    });

    test('maps false specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification = False<EntityStub>();
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification = mapper.map(specification);

      expect(mappedSpecification(x.toJson()), false);
      expect(mappedSpecification(y.toJson()), false);
      expect(mappedSpecification(z.toJson()), false);
    });

    test('maps not specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = Not<EntityStub>(False<EntityStub>());
      final specification2 = Not<EntityStub>(True<EntityStub>());
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification1 = mapper.map(specification1);
      final mappedSpecification2 = mapper.map(specification2);

      expect(mappedSpecification1(x.toJson()), true);
      expect(mappedSpecification1(y.toJson()), true);
      expect(mappedSpecification1(z.toJson()), true);
      expect(mappedSpecification2(x.toJson()), false);
      expect(mappedSpecification2(y.toJson()), false);
      expect(mappedSpecification2(z.toJson()), false);
    });

    test('maps and specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = And<EntityStub>([]);
      final specification2 =
          And<EntityStub>([True<EntityStub>(), True<EntityStub>()]);
      final specification3 =
          And<EntityStub>([True<EntityStub>(), False<EntityStub>()]);
      final specification4 =
          And<EntityStub>([False<EntityStub>(), False<EntityStub>()]);
      final entity = EntityStub('', 0, false);

      final mappedSpecification1 = mapper.map(specification1);
      final mappedSpecification2 = mapper.map(specification2);
      final mappedSpecification3 = mapper.map(specification3);
      final mappedSpecification4 = mapper.map(specification4);

      expect(mappedSpecification1(entity.toJson()), true);
      expect(mappedSpecification2(entity.toJson()), true);
      expect(mappedSpecification3(entity.toJson()), false);
      expect(mappedSpecification4(entity.toJson()), false);
    });

    test('maps or specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = Or<EntityStub>([]);
      final specification2 =
          Or<EntityStub>([True<EntityStub>(), True<EntityStub>()]);
      final specification3 =
          Or<EntityStub>([True<EntityStub>(), False<EntityStub>()]);
      final specification4 =
          Or<EntityStub>([False<EntityStub>(), False<EntityStub>()]);
      final entity = EntityStub('', 0, false);

      final mappedSpecification1 = mapper.map(specification1);
      final mappedSpecification2 = mapper.map(specification2);
      final mappedSpecification3 = mapper.map(specification3);
      final mappedSpecification4 = mapper.map(specification4);

      expect(mappedSpecification1(entity.toJson()), false);
      expect(mappedSpecification2(entity.toJson()), true);
      expect(mappedSpecification3(entity.toJson()), true);
      expect(mappedSpecification4(entity.toJson()), false);
    });

    test('maps compare specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = Compare<EntityStub, String>(
        operator: Equals<String>(),
        projector1: FieldValue<EntityStub, String>('a'),
        projector2: ConstValue<EntityStub, String>('Test'),
      );
      final specification2 = Compare<EntityStub, num>(
        operator: Equals<num>(),
        projector1: FieldValue<EntityStub, num>('b'),
        projector2: ConstValue<EntityStub, num>(-100),
      );
      final specification3 = Compare<EntityStub, bool>(
        operator: Equals<bool>(),
        projector1: FieldValue<EntityStub, bool>('c'),
        projector2: ConstValue<EntityStub, bool>(true),
      );
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification1 = mapper.map(specification1);
      final mappedSpecification2 = mapper.map(specification2);
      final mappedSpecification3 = mapper.map(specification3);

      expect(mappedSpecification1(x.toJson()), false);
      expect(mappedSpecification1(y.toJson()), true);
      expect(mappedSpecification1(z.toJson()), false);
      expect(mappedSpecification2(x.toJson()), false);
      expect(mappedSpecification2(y.toJson()), false);
      expect(mappedSpecification2(z.toJson()), true);
      expect(mappedSpecification3(x.toJson()), false);
      expect(mappedSpecification3(y.toJson()), true);
      expect(mappedSpecification3(z.toJson()), false);
    });

    test('maps custom specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = CustomSpecificationStub(True<EntityStub>());
      final specification2 = CustomSpecificationStub(False<EntityStub>());
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSpecification1 = mapper.map(specification1);
      final mappedSpecification2 = mapper.map(specification2);

      expect(mappedSpecification1(x.toJson()), true);
      expect(mappedSpecification1(y.toJson()), true);
      expect(mappedSpecification1(z.toJson()), true);
      expect(mappedSpecification2(x.toJson()), false);
      expect(mappedSpecification2(y.toJson()), false);
      expect(mappedSpecification2(z.toJson()), false);
    });

    test('throws exception on non supported specification', () {
      final mapper = InMemorySpecificationMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final specification1 = NotSupportedSpecification();
      final specification2 = NotSupportedCompositeSpecification([]);

      expect(() => mapper.map(specification1), throwsException);
      expect(() => mapper.map(specification2), throwsException);
    });
  });

  group('in memory sorter mapper', () {
    test('maps null', () {
      final mapper = InMemorySorterMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final sorter = null;
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSorter = mapper.map(sorter);

      expect(mappedSorter(x.toJson(), y.toJson()), 0);
      expect(mappedSorter(y.toJson(), z.toJson()), 0);
      expect(mappedSorter(z.toJson(), x.toJson()), 0);
    });

    test('maps value sorter', () {
      final mapper = InMemorySorterMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final sorter1 =
          ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a'));
      final sorter2 = ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b'));
      final sorter3 =
          ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c'));
      final x = EntityStub('', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('Test_2', -100, false);

      final mappedSorter1 = mapper.map(sorter1);
      final mappedSorter2 = mapper.map(sorter2);
      final mappedSorter3 = mapper.map(sorter3);

      expect(mappedSorter1(x.toJson(), x.toJson()), 0);
      expect(mappedSorter1(y.toJson(), y.toJson()), 0);
      expect(mappedSorter1(z.toJson(), z.toJson()), 0);
      expect(mappedSorter1(x.toJson(), y.toJson()), -1);
      expect(mappedSorter1(y.toJson(), z.toJson()), -1);
      expect(mappedSorter1(z.toJson(), x.toJson()), 1);
      expect(mappedSorter2(x.toJson(), x.toJson()), 0);
      expect(mappedSorter2(y.toJson(), y.toJson()), 0);
      expect(mappedSorter2(z.toJson(), z.toJson()), 0);
      expect(mappedSorter2(x.toJson(), x.toJson()), 0);
      expect(mappedSorter2(x.toJson(), y.toJson()), -1);
      expect(mappedSorter2(y.toJson(), z.toJson()), 1);
      expect(mappedSorter2(z.toJson(), x.toJson()), -1);
      expect(mappedSorter3(x.toJson(), x.toJson()), 0);
      expect(mappedSorter3(y.toJson(), y.toJson()), 0);
      expect(mappedSorter3(z.toJson(), z.toJson()), 0);
      expect(mappedSorter3(x.toJson(), x.toJson()), 0);
      expect(mappedSorter3(x.toJson(), y.toJson()), -1);
      expect(mappedSorter3(y.toJson(), z.toJson()), 1);
      expect(mappedSorter3(z.toJson(), x.toJson()), 0);
    });

    test('maps composite sorter', () {
      final mapper = InMemorySorterMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final s1 = ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a'));
      final s2 = ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b'));
      final s3 = ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c'));
      final sorter1 = CompositeSorter([]);
      final sorter2 = CompositeSorter([s1]);
      final sorter3 = CompositeSorter([s2]);
      final sorter4 = CompositeSorter([s3]);
      final sorter5 = CompositeSorter([s1, s2]);
      final sorter6 = CompositeSorter([s2, s3]);
      final sorter7 = CompositeSorter([s3, s1]);
      final x = EntityStub('Test', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('', 42, false);

      final mappedSorter1 = mapper.map(sorter1);
      final mappedSorter2 = mapper.map(sorter2);
      final mappedSorter3 = mapper.map(sorter3);
      final mappedSorter4 = mapper.map(sorter4);
      final mappedSorter5 = mapper.map(sorter5);
      final mappedSorter6 = mapper.map(sorter6);
      final mappedSorter7 = mapper.map(sorter7);

      expect(mappedSorter1(x.toJson(), x.toJson()), 0);
      expect(mappedSorter1(y.toJson(), y.toJson()), 0);
      expect(mappedSorter1(z.toJson(), z.toJson()), 0);
      expect(mappedSorter1(x.toJson(), y.toJson()), 0);
      expect(mappedSorter1(y.toJson(), z.toJson()), 0);
      expect(mappedSorter1(z.toJson(), x.toJson()), 0);

      expect(mappedSorter2(x.toJson(), x.toJson()), 0);
      expect(mappedSorter2(y.toJson(), y.toJson()), 0);
      expect(mappedSorter2(z.toJson(), z.toJson()), 0);
      expect(mappedSorter2(x.toJson(), y.toJson()), 0);
      expect(mappedSorter2(y.toJson(), z.toJson()), 1);
      expect(mappedSorter2(z.toJson(), x.toJson()), -1);

      expect(mappedSorter3(x.toJson(), x.toJson()), 0);
      expect(mappedSorter3(y.toJson(), y.toJson()), 0);
      expect(mappedSorter3(z.toJson(), z.toJson()), 0);
      expect(mappedSorter3(x.toJson(), y.toJson()), -1);
      expect(mappedSorter3(y.toJson(), z.toJson()), 0);
      expect(mappedSorter3(z.toJson(), x.toJson()), 1);

      expect(mappedSorter4(x.toJson(), x.toJson()), 0);
      expect(mappedSorter4(y.toJson(), y.toJson()), 0);
      expect(mappedSorter4(z.toJson(), z.toJson()), 0);
      expect(mappedSorter4(x.toJson(), y.toJson()), -1);
      expect(mappedSorter4(y.toJson(), z.toJson()), 1);
      expect(mappedSorter4(z.toJson(), x.toJson()), 0);

      expect(mappedSorter5(x.toJson(), x.toJson()), 0);
      expect(mappedSorter5(y.toJson(), y.toJson()), 0);
      expect(mappedSorter5(z.toJson(), z.toJson()), 0);
      expect(mappedSorter5(x.toJson(), y.toJson()), -1);
      expect(mappedSorter5(y.toJson(), z.toJson()), 1);
      expect(mappedSorter5(z.toJson(), x.toJson()), -1);

      expect(mappedSorter6(x.toJson(), x.toJson()), 0);
      expect(mappedSorter6(y.toJson(), y.toJson()), 0);
      expect(mappedSorter6(z.toJson(), z.toJson()), 0);
      expect(mappedSorter6(x.toJson(), y.toJson()), -1);
      expect(mappedSorter6(y.toJson(), z.toJson()), 1);
      expect(mappedSorter6(z.toJson(), x.toJson()), 1);

      expect(mappedSorter7(x.toJson(), x.toJson()), 0);
      expect(mappedSorter7(y.toJson(), y.toJson()), 0);
      expect(mappedSorter7(z.toJson(), z.toJson()), 0);
      expect(mappedSorter7(x.toJson(), y.toJson()), -1);
      expect(mappedSorter7(y.toJson(), z.toJson()), 1);
      expect(mappedSorter7(z.toJson(), x.toJson()), -1);
    });

    test('maps composite sorter', () {
      final mapper = InMemorySorterMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final sorter1 = CustomSorterStub(
          ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a')));
      final sorter2 = CustomSorterStub(
          ValueSorter<EntityStub>(FieldValue<EntityStub, String>('b')));
      final sorter3 = CustomSorterStub(
          ValueSorter<EntityStub>(FieldValue<EntityStub, String>('c')));
      final x = EntityStub('Test', 0, false);
      final y = EntityStub('Test', 42, true);
      final z = EntityStub('', 42, false);

      final mappedSorter1 = mapper.map(sorter1);
      final mappedSorter2 = mapper.map(sorter2);
      final mappedSorter3 = mapper.map(sorter3);

      expect(mappedSorter1(x.toJson(), x.toJson()), 0);
      expect(mappedSorter1(y.toJson(), y.toJson()), 0);
      expect(mappedSorter1(z.toJson(), z.toJson()), 0);
      expect(mappedSorter1(x.toJson(), y.toJson()), 0);
      expect(mappedSorter1(y.toJson(), z.toJson()), 1);
      expect(mappedSorter1(z.toJson(), x.toJson()), -1);

      expect(mappedSorter2(x.toJson(), x.toJson()), 0);
      expect(mappedSorter2(y.toJson(), y.toJson()), 0);
      expect(mappedSorter2(z.toJson(), z.toJson()), 0);
      expect(mappedSorter2(x.toJson(), y.toJson()), -1);
      expect(mappedSorter2(y.toJson(), z.toJson()), 0);
      expect(mappedSorter2(z.toJson(), x.toJson()), 1);

      expect(mappedSorter3(x.toJson(), x.toJson()), 0);
      expect(mappedSorter3(y.toJson(), y.toJson()), 0);
      expect(mappedSorter3(z.toJson(), z.toJson()), 0);
      expect(mappedSorter3(x.toJson(), y.toJson()), -1);
      expect(mappedSorter3(y.toJson(), z.toJson()), 1);
      expect(mappedSorter3(z.toJson(), x.toJson()), 0);
    });

    test('throws exception on non supported sorter', () {
      final mapper = InMemorySorterMapper(
        projectorMapper: InMemoryProjectorMapper(),
      );
      final sorter = NotSupportedSorter();

      expect(() => mapper.map(sorter), throwsException);
    });
  });

  group('in memory data provider', () {
    test('findAll without arguments returns all entries', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );

      final result = await dataProvider.findAll();

      expect(result, data);
    });

    test('findAll returns all entries satisfying specification', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final specification1 =
          CompareFieldValue(field: 'id', value: 2, operator: Equals());
      final sorter1 = FieldSorter({'id': true});
      final specification2 =
          CompareFieldValue(field: 'id', value: 2, operator: Greater());
      final sorter2 = FieldSorter({'id': true});
      final specification3 = CompareFieldValue(
          field: 'title', value: 'Test_2', operator: Equals());
      final sorter3 = FieldSorter({'id': false});

      final result1 = await dataProvider.findAll(
        specification: specification1,
        sorter: sorter1,
      );
      final result2 = await dataProvider.findAll(
        specification: specification2,
        sorter: sorter2,
      );
      final result3 = await dataProvider.findAll(
        specification: specification3,
        sorter: sorter3,
      );

      expect(result1, [data[1]]);
      expect(result2, [data[2], data[3]]);
      expect(result3, [data[3], data[2]]);
    });

    test('findById returns entry with specified id', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );

      final result1 = await dataProvider.findById('1');
      final result2 = await dataProvider.findById('2');
      final result3 = await dataProvider.findById('3');
      final result4 = await dataProvider.findById('4');
      final result5 = await dataProvider.findById('5');

      expect(result1, data[0]);
      expect(result2, data[1]);
      expect(result3, data[2]);
      expect(result4, data[3]);
      expect(result5, isNull);
    });

    test('findOne returns entry that satisfies specification', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final specification1 = True();
      final sorter1 = ValueSorter(FieldValue('id'));
      final specification2 = True();
      final sorter2 = ValueSorter(FieldValue('id'), false);
      final specification3 = False();
      final sorter3 = null;
      final specification4 =
          CompareFieldValue(field: 'title', value: 'Test', operator: Equals());
      final sorter4 = null;
      final specification5 = CompareFieldValue(
          field: 'title', value: 'Test_2', operator: Equals());
      final sorter5 = ValueSorter(FieldValue('id'));
      final specification6 = CompareFieldValue(
          field: 'title', value: 'Test_2', operator: Equals());
      final sorter6 = ValueSorter(FieldValue('id'), false);

      final result1 = await dataProvider.findOne(
          specification: specification1, sorter: sorter1);
      final result2 = await dataProvider.findOne(
          specification: specification2, sorter: sorter2);
      final result3 = await dataProvider.findOne(
          specification: specification3, sorter: sorter3);
      final result4 = await dataProvider.findOne(
          specification: specification4, sorter: sorter4);
      final result5 = await dataProvider.findOne(
          specification: specification5, sorter: sorter5);
      final result6 = await dataProvider.findOne(
          specification: specification6, sorter: sorter6);

      expect(result1, data[0]);
      expect(result2, data[3]);
      expect(result3, isNull);
      expect(result4, data[1]);
      expect(result5, data[2]);
      expect(result6, data[3]);
    });

    test('saveOne saves new entry', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final newEntry = {'id': 5, 'title': 'New entry'};

      await dataProvider.saveOne(newEntry);

      expect(await dataProvider.findAll(), hasLength(5));
      expect(await dataProvider.findById('5'), newEntry);
      expect(await dataProvider.findById('1'), data[0]);
      expect(await dataProvider.findById('2'), data[1]);
      expect(await dataProvider.findById('3'), data[2]);
      expect(await dataProvider.findById('4'), data[3]);
    });

    test('saveOne replaces existing entry', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final newEntry = {'id': 3, 'title': 'New entry'};

      await dataProvider.saveOne(newEntry);

      expect(await dataProvider.findAll(), hasLength(4));
      expect(await dataProvider.findById('3'), newEntry);
      expect(await dataProvider.findById('1'), data[0]);
      expect(await dataProvider.findById('2'), data[1]);
      expect(await dataProvider.findById('4'), data[3]);
    });

    test('saveAll saves entries', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final newEntries = [
        {'id': 3, 'title': 'New entry 1'},
        {'id': 5, 'title': 'New entry 2'},
      ];

      await dataProvider.saveAll(newEntries);

      expect(await dataProvider.findAll(), hasLength(5));
      expect(await dataProvider.findById('3'), newEntries[0]);
      expect(await dataProvider.findById('5'), newEntries[1]);
      expect(await dataProvider.findById('1'), data[0]);
      expect(await dataProvider.findById('2'), data[1]);
      expect(await dataProvider.findById('4'), data[3]);
    });

    test('deleteById deletes existing entry', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );

      await dataProvider.deleteById('3');

      expect(await dataProvider.findAll(), hasLength(3));
      expect(await dataProvider.findById('3'), isNull);
      expect(await dataProvider.findById('1'), data[0]);
      expect(await dataProvider.findById('2'), data[1]);
      expect(await dataProvider.findById('4'), data[3]);
    });

    test('deleteById ignores not existing entry', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );

      await dataProvider.deleteById('5');

      expect(await dataProvider.findAll(), hasLength(4));
      expect(await dataProvider.findById('1'), data[0]);
      expect(await dataProvider.findById('2'), data[1]);
      expect(await dataProvider.findById('3'), data[2]);
      expect(await dataProvider.findById('4'), data[3]);
    });

    test('deleteAll deletes no entries if none satisfies specification',
        () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final specification = False();

      await dataProvider.deleteAll(specification);

      expect(await dataProvider.findAll(), data);
    });

    test('deleteAll deletes all entries if all satisfy specification',
        () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final specification = True();

      await dataProvider.deleteAll(specification);

      expect(await dataProvider.findAll(), []);
    });

    test('deleteAll deletes all entries that satisfy specification', () async {
      final projectorMapper = InMemoryProjectorMapper();
      final specificationMapper =
          InMemorySpecificationMapper(projectorMapper: projectorMapper);
      final sorterMapper =
          InMemorySorterMapper(projectorMapper: projectorMapper);
      final data = [
        {'id': 1, 'title': ''},
        {'id': 2, 'title': 'Test'},
        {'id': 3, 'title': 'Test_2'},
        {'id': 4, 'title': 'Test_2'},
      ];
      final dataProvider = InMemoryDataProvider(
        specificationMapper: specificationMapper,
        sorterMapper: sorterMapper,
        data: data,
      );
      final specification = CompareFieldValue(
          field: 'title', value: 'Test_2', operator: Equals());

      await dataProvider.deleteAll(specification);

      expect(await dataProvider.findAll(), [data[0], data[1]]);
    });
  });
}

class EntityStub implements Serializable {
  EntityStub(this.a, this.b, this.c);

  final String a;
  final int b;
  final bool c;

  @override
  Map<String, dynamic> toJson() {
    return {
      'a': a,
      'b': b,
      'c': c,
    };
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
