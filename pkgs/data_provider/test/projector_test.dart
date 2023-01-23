import 'package:data_provider/data_provider.dart';
import 'package:data_provider/src/projector.dart';
import 'package:test/test.dart';

void main() {
  group('const value projector', () {
    test('always returns same value', () {
      final projector = ConstValue<EntityStub, String>('Test');
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Tes', -100, false);
      final z = EntityStub('Test_2', 0, true);

      expect(projector.project(x), 'Test');
      expect(projector.project(y), 'Test');
      expect(projector.project(z), 'Test');
    });
  });

  group('field value projector', () {
    test('works for strings', () {
      final projector = FieldValue<EntityStub, String>('a');
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Tes', -100, false);
      final z = EntityStub('Test_2', 0, true);

      expect(projector.project(x), 'Test');
      expect(projector.project(y), 'Tes');
      expect(projector.project(z), 'Test_2');
    });

    test('works for numbers', () {
      final projector = FieldValue<EntityStub, num>('b');
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Tes', -100, false);
      final z = EntityStub('Test_2', 0, true);

      expect(projector.project(x), 42);
      expect(projector.project(y), -100);
      expect(projector.project(z), 0);
    });

    test('works for booleans', () {
      final projector = FieldValue<EntityStub, bool>('c');
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Tes', -100, false);
      final z = EntityStub('Test_2', 0, true);

      expect(projector.project(x), true);
      expect(projector.project(y), false);
      expect(projector.project(z), true);
    });

    test('works with getter', () {
      final projector =
          FieldValue<NonSerializableStub, String>('a', (entity) => entity.a);
      final x = NonSerializableStub('Test', []);
      final y = NonSerializableStub('Tes', []);
      final z = NonSerializableStub('Test_2', []);

      expect(projector.project(x), 'Test');
      expect(projector.project(y), 'Tes');
      expect(projector.project(z), 'Test_2');
    });

    test('throws exception not serializable and no getter provided', () {
      final projector = FieldValue<NonSerializableStub, List>('b');
      final x = NonSerializableStub('Test', []);

      expect(() => projector.project(x), throwsException);
    });
  });

  group('binary expression projector', () {
    test('works for comparison operators', () {
      final p1 = FieldValue<EntityStub, num>('b');
      final p2 = ConstValue<EntityStub, num>(0);
      final projector =
          BinaryExpression<EntityStub, num, bool>(Less<num>(), p1, p2);
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Tes', -100, false);
      final z = EntityStub('Test_2', 0, true);

      expect(projector.project(x), false);
      expect(projector.project(y), true);
      expect(projector.project(z), false);
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

class NonSerializableStub {
  NonSerializableStub(this.a, this.b);

  final String a;
  final List b;
}
