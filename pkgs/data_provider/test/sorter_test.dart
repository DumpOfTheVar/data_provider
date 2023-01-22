
import 'package:data_provider/src/projector.dart';
import 'package:data_provider/src/serializable.dart';
import 'package:data_provider/src/sorter.dart';
import 'package:test/test.dart';

void main() {
  group('value sorter', () {
    test('returns 0 if value is equal and ASC', () {
      final sorter = ValueSorter<EntityStub>(ConstValue<EntityStub, int>(42));
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, y), 0);
      expect(sorter.compare(y, x), 0);
      expect(sorter.compare(y, z), 0);
      expect(sorter.compare(z, y), 0);
      expect(sorter.compare(x, z), 0);
      expect(sorter.compare(z, x), 0);
    });

    test('returns 0 if value is equal and DESC', () {
      final sorter = ValueSorter<EntityStub>(ConstValue<EntityStub, int>(42));
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, y), 0);
      expect(sorter.compare(y, x), 0);
      expect(sorter.compare(y, z), 0);
      expect(sorter.compare(z, y), 0);
      expect(sorter.compare(x, z), 0);
      expect(sorter.compare(z, x), 0);
    });

    test('works for strings when ASC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a'));
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), -1);
      expect(sorter.compare(y, x), 1);
      expect(sorter.compare(y, z), 1);
      expect(sorter.compare(z, y), -1);
      expect(sorter.compare(x, z), 1);
      expect(sorter.compare(z, x), -1);
    });

    test('works for strings when DESC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a'), false);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), 1);
      expect(sorter.compare(y, x), -1);
      expect(sorter.compare(y, z), -1);
      expect(sorter.compare(z, y), 1);
      expect(sorter.compare(x, z), -1);
      expect(sorter.compare(z, x), 1);
    });

    test('works for numbers when ASC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b'));
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), 1);
      expect(sorter.compare(y, x), -1);
      expect(sorter.compare(y, z), -1);
      expect(sorter.compare(z, y), 1);
      expect(sorter.compare(x, z), -1);
      expect(sorter.compare(z, x), 1);
    });

    test('works for numbers when DESC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b'), false);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), -1);
      expect(sorter.compare(y, x), 1);
      expect(sorter.compare(y, z), 1);
      expect(sorter.compare(z, y), -1);
      expect(sorter.compare(x, z), 1);
      expect(sorter.compare(z, x), -1);
    });

    test('works for booleans when ASC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c'));
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), 1);
      expect(sorter.compare(y, x), -1);
      expect(sorter.compare(y, z), -1);
      expect(sorter.compare(z, y), 1);
      expect(sorter.compare(x, z), 0);
      expect(sorter.compare(z, x), 0);
    });

    test('works for booleans when DESC', () {
      final sorter = ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c'), false);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), -1);
      expect(sorter.compare(y, x), 1);
      expect(sorter.compare(y, z), 1);
      expect(sorter.compare(z, y), -1);
      expect(sorter.compare(x, z), 0);
      expect(sorter.compare(z, x), 0);
    });

    test('throws exception if type is not supported', () {
      final sorter = ValueSorter<EntityStub>(ConstValue([]));
      final x = EntityStub('Test', 42, true);

      expect(() => sorter.compare(x, x), throwsException);
    });
  });

  group('composite sorter', () {
    test('returns 0 if no children', () {
      final sorter = CompositeSorter<EntityStub>([]);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter.compare(x, x), 0);
      expect(sorter.compare(y, y), 0);
      expect(sorter.compare(z, z), 0);
      expect(sorter.compare(x, y), 0);
      expect(sorter.compare(y, x), 0);
      expect(sorter.compare(y, z), 0);
      expect(sorter.compare(z, y), 0);
      expect(sorter.compare(x, z), 0);
      expect(sorter.compare(z, x), 0);
    });

    test('works with one child', () {
      final sorter1 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a')),
      ]);
      final sorter2 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b')),
      ]);
      final sorter3 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c')),
      ]);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), -1);
      expect(sorter1.compare(y, x), 1);
      expect(sorter1.compare(y, z), 1);
      expect(sorter1.compare(z, y), -1);
      expect(sorter1.compare(x, z), 1);
      expect(sorter1.compare(z, x), -1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), 1);
      expect(sorter2.compare(y, x), -1);
      expect(sorter2.compare(y, z), -1);
      expect(sorter2.compare(z, y), 1);
      expect(sorter2.compare(x, z), -1);
      expect(sorter2.compare(z, x), 1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), 1);
      expect(sorter3.compare(y, x), -1);
      expect(sorter3.compare(y, z), -1);
      expect(sorter3.compare(z, y), 1);
      expect(sorter3.compare(x, z), 0);
      expect(sorter3.compare(z, x), 0);
    });

    test('works with two children', () {
      final sorter1 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a')),
        ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b')),
      ]);
      final sorter2 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, num>('b')),
        ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c')),
      ]);
      final sorter3 = CompositeSorter<EntityStub>([
        ValueSorter<EntityStub>(FieldValue<EntityStub, bool>('c')),
        ValueSorter<EntityStub>(FieldValue<EntityStub, String>('a')),
      ]);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test', 0, false);
      final z = EntityStub('Test_2', 0, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), 1);
      expect(sorter1.compare(y, x), -1);
      expect(sorter1.compare(y, z), -1);
      expect(sorter1.compare(z, y), 1);
      expect(sorter1.compare(x, z), -1);
      expect(sorter1.compare(z, x), 1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), 1);
      expect(sorter2.compare(y, x), -1);
      expect(sorter2.compare(y, z), -1);
      expect(sorter2.compare(z, y), 1);
      expect(sorter2.compare(x, z), 1);
      expect(sorter2.compare(z, x), -1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), 1);
      expect(sorter3.compare(y, x), -1);
      expect(sorter3.compare(y, z), -1);
      expect(sorter3.compare(z, y), 1);
      expect(sorter3.compare(x, z), -1);
      expect(sorter3.compare(z, x), 1);
    });
  });

  group('field sorter', () {
    test('sorts by zero fields', () {
      final sorter1 = FieldSorter<EntityStub>({});
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), 0);
      expect(sorter1.compare(y, x), 0);
      expect(sorter1.compare(y, z), 0);
      expect(sorter1.compare(z, y), 0);
      expect(sorter1.compare(x, z), 0);
      expect(sorter1.compare(z, x), 0);
    });

    test('sorts by one field ASC', () {
      final sorter1 = FieldSorter<EntityStub>({'a': true});
      final sorter2 = FieldSorter<EntityStub>({'b': true});
      final sorter3 = FieldSorter<EntityStub>({'c': true});
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), -1);
      expect(sorter1.compare(y, x), 1);
      expect(sorter1.compare(y, z), 1);
      expect(sorter1.compare(z, y), -1);
      expect(sorter1.compare(x, z), 1);
      expect(sorter1.compare(z, x), -1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), 1);
      expect(sorter2.compare(y, x), -1);
      expect(sorter2.compare(y, z), -1);
      expect(sorter2.compare(z, y), 1);
      expect(sorter2.compare(x, z), -1);
      expect(sorter2.compare(z, x), 1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), 1);
      expect(sorter3.compare(y, x), -1);
      expect(sorter3.compare(y, z), -1);
      expect(sorter3.compare(z, y), 1);
      expect(sorter3.compare(x, z), 0);
      expect(sorter3.compare(z, x), 0);
    });

    test('sorts by one field DESC', () {
      final sorter1 = FieldSorter<EntityStub>({'a': false});
      final sorter2 = FieldSorter<EntityStub>({'b': false});
      final sorter3 = FieldSorter<EntityStub>({'c': false});
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 0, false);
      final z = EntityStub('Tes', 100, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), 1);
      expect(sorter1.compare(y, x), -1);
      expect(sorter1.compare(y, z), -1);
      expect(sorter1.compare(z, y), 1);
      expect(sorter1.compare(x, z), -1);
      expect(sorter1.compare(z, x), 1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), -1);
      expect(sorter2.compare(y, x), 1);
      expect(sorter2.compare(y, z), 1);
      expect(sorter2.compare(z, y), -1);
      expect(sorter2.compare(x, z), 1);
      expect(sorter2.compare(z, x), -1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), -1);
      expect(sorter3.compare(y, x), 1);
      expect(sorter3.compare(y, z), 1);
      expect(sorter3.compare(z, y), -1);
      expect(sorter3.compare(x, z), 0);
      expect(sorter3.compare(z, x), 0);
    });

    test('sorts by two fields ASC', () {
      final sorter1 = FieldSorter<EntityStub>({'a': true, 'b': true});
      final sorter2 = FieldSorter<EntityStub>({'b': true, 'c': true});
      final sorter3 = FieldSorter<EntityStub>({'c': true, 'a': true});
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test', 0, false);
      final z = EntityStub('Test_2', 0, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), 1);
      expect(sorter1.compare(y, x), -1);
      expect(sorter1.compare(y, z), -1);
      expect(sorter1.compare(z, y), 1);
      expect(sorter1.compare(x, z), -1);
      expect(sorter1.compare(z, x), 1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), 1);
      expect(sorter2.compare(y, x), -1);
      expect(sorter2.compare(y, z), -1);
      expect(sorter2.compare(z, y), 1);
      expect(sorter2.compare(x, z), 1);
      expect(sorter2.compare(z, x), -1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), 1);
      expect(sorter3.compare(y, x), -1);
      expect(sorter3.compare(y, z), -1);
      expect(sorter3.compare(z, y), 1);
      expect(sorter3.compare(x, z), -1);
      expect(sorter3.compare(z, x), 1);
    });

    test('sorts by two fields DESC', () {
      final sorter1 = FieldSorter<EntityStub>({'a': false, 'b': false});
      final sorter2 = FieldSorter<EntityStub>({'b': false, 'c': false});
      final sorter3 = FieldSorter<EntityStub>({'c': false, 'a': false});
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test', 0, false);
      final z = EntityStub('Test_2', 0, true);

      expect(sorter1.compare(x, x), 0);
      expect(sorter1.compare(y, y), 0);
      expect(sorter1.compare(z, z), 0);
      expect(sorter1.compare(x, y), -1);
      expect(sorter1.compare(y, x), 1);
      expect(sorter1.compare(y, z), 1);
      expect(sorter1.compare(z, y), -1);
      expect(sorter1.compare(x, z), 1);
      expect(sorter1.compare(z, x), -1);
      expect(sorter2.compare(x, x), 0);
      expect(sorter2.compare(y, y), 0);
      expect(sorter2.compare(z, z), 0);
      expect(sorter2.compare(x, y), -1);
      expect(sorter2.compare(y, x), 1);
      expect(sorter2.compare(y, z), 1);
      expect(sorter2.compare(z, y), -1);
      expect(sorter2.compare(x, z), -1);
      expect(sorter2.compare(z, x), 1);
      expect(sorter3.compare(x, x), 0);
      expect(sorter3.compare(y, y), 0);
      expect(sorter3.compare(z, z), 0);
      expect(sorter3.compare(x, y), -1);
      expect(sorter3.compare(y, x), 1);
      expect(sorter3.compare(y, z), 1);
      expect(sorter3.compare(z, y), -1);
      expect(sorter3.compare(x, z), 1);
      expect(sorter3.compare(z, x), -1);
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
