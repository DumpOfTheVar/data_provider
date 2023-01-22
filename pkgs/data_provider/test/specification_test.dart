
import 'package:data_provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
  group('true specification', () {
    test('always returns true', () {
      final specification = True<EntityStub>();
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), true);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), true);
    });
  });

  group('false specification', () {
    test('always returns false', () {
      final specification = False<EntityStub>();
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), false);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), false);
    });
  });

  group('not specification', () {
    test('returns true when child returns false', () {
      final specification = Not<EntityStub>(False<EntityStub>());
      expect(true, specification.isSatisfiedBy(EntityStub('Test', 42, true)));
      expect(true, specification.isSatisfiedBy(EntityStub('', 0, false)));
    });

    test('returns false when child returns true', () {
      final specification = Not<EntityStub>(True<EntityStub>());
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), false);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), false);
    });
  });

  group('and specification', () {
    test('returns true when children empty', () {
      final specification = And<EntityStub>([]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), true);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), true);
    });

    test('returns true when all children return true', () {
      final specification = And<EntityStub>([
        True<EntityStub>(),
        True<EntityStub>(),
        True<EntityStub>(),
      ]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), true);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), true);
    });

    test('returns false when some child returns false', () {
      final specification = And<EntityStub>([
        True<EntityStub>(),
        True<EntityStub>(),
        False<EntityStub>(),
      ]);
      expect(false, specification.isSatisfiedBy(EntityStub('Test', 42, true)));
      expect(false, specification.isSatisfiedBy(EntityStub('', 0, false)));
    });

    test('returns false when all children return false', () {
      final specification = And<EntityStub>([
        False<EntityStub>(),
        False<EntityStub>(),
        False<EntityStub>(),
      ]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), false);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), false);
    });
  });

  group('or specification', () {
    test('returns false when children empty', () {
      final specification = Or<EntityStub>([]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), false);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), false);
    });

    test('returns true when all children return true', () {
      final specification = Or<EntityStub>([
        True<EntityStub>(),
        True<EntityStub>(),
        True<EntityStub>(),
      ]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), true);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), true);
    });

    test('returns true when some child returns true', () {
      final specification = Or<EntityStub>([
        False<EntityStub>(),
        False<EntityStub>(),
        True<EntityStub>(),
      ]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), true);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), true);
    });

    test('returns false when all children return false', () {
      final specification = Or<EntityStub>([
        False<EntityStub>(),
        False<EntityStub>(),
        False<EntityStub>(),
      ]);
      expect(specification.isSatisfiedBy(EntityStub('Test', 42, true)), false);
      expect(specification.isSatisfiedBy(EntityStub('', 0, false)), false);
    });
  });

  group('compare field value specification', () {
    test('works for strings', () {
      final specification1 = CompareFieldValue<EntityStub, String>(
        field: 'a',
        operator: Equals<String>(),
        value: 'Test',
      );
      final specification2 = CompareFieldValue<EntityStub, String>(
        field: 'a',
        operator: Less<String>(),
        value: 'Test',
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), false);
      expect(specification1.isSatisfiedBy(z), false);
      expect(specification2.isSatisfiedBy(x), false);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), true);
    });

    test('works for numbers', () {
      final specification1 = CompareFieldValue<EntityStub, num>(
        field: 'b',
        operator: Equals<num>(),
        value: 42,
      );
      final specification2 = CompareFieldValue<EntityStub, num>(
        field: 'b',
        operator: Less<num>(),
        value: 42,
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), false);
      expect(specification1.isSatisfiedBy(z), false);
      expect(specification2.isSatisfiedBy(x), false);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), true);
    });

    test('works for booleans', () {
      final specification = CompareFieldValue<EntityStub, bool>(
        field: 'c',
        operator: Equals<bool>(),
        value: false,
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification.isSatisfiedBy(x), false);
      expect(specification.isSatisfiedBy(y), true);
      expect(specification.isSatisfiedBy(z), true);
    });
  });

  group('compare two fields specification', () {
    test('works for strings', () {
      final specification1 = CompareTwoFields<EntityStub, String>(
        field1: 'a',
        field2: 'a',
        operator: Equals<String>(),
      );
      final specification2 = CompareTwoFields<EntityStub, String>(
        field1: 'a',
        field2: 'a',
        operator: Less<String>(),
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), true);
      expect(specification1.isSatisfiedBy(z), true);
      expect(specification2.isSatisfiedBy(x), false);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), false);
    });

    test('works for numbers', () {
      final specification1 = CompareTwoFields<EntityStub, num>(
        field1: 'b',
        field2: 'b',
        operator: Equals<num>(),
      );
      final specification2 = CompareTwoFields<EntityStub, num>(
        field1: 'b',
        field2: 'b',
        operator: Less<num>(),
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), true);
      expect(specification1.isSatisfiedBy(z), true);
      expect(specification2.isSatisfiedBy(x), false);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), false);
    });

    test('works for booleans', () {
      final specification = CompareTwoFields<EntityStub, bool>(
        field1: 'c',
        field2: 'c',
        operator: Equals<bool>(),
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification.isSatisfiedBy(x), true);
      expect(specification.isSatisfiedBy(y), true);
      expect(specification.isSatisfiedBy(z), true);
    });
  });

  group('custom specification', () {
    test('returns true when normalized return true', () {
      final specification = CustomSpecificationStub(True());
      final x = EntityStub('Test', 42, true);
      expect(specification.isSatisfiedBy(x), true);
    });

    test('returns false when normalized return false', () {
      final specification = CustomSpecificationStub(False());
      final x = EntityStub('Test', 42, true);
      expect(specification.isSatisfiedBy(x), false);
    });
  });


  group('between specification', () {
    test('works for strings', () {
      final specification1 = Between<EntityStub, String>(
        field: 'a',
        from: 'Test',
        to: 'Test_2',
      );
      final specification2 = Between<EntityStub, String>(
        field: 'a',
        from: '',
        to: 'Test_',
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), false);
      expect(specification1.isSatisfiedBy(z), false);
      expect(specification2.isSatisfiedBy(x), true);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), true);
    });

    test('works for numbers', () {
      final specification1 = Between<EntityStub, num>(
        field: 'b',
        from: 42,
        to: 100,
      );
      final specification2 = Between<EntityStub, num>(
        field: 'b',
        from: 0,
        to: 43,
      );
      final x = EntityStub('Test', 42, true);
      final y = EntityStub('Test_2', 100, false);
      final z = EntityStub('', 0, false);

      expect(specification1.isSatisfiedBy(x), true);
      expect(specification1.isSatisfiedBy(y), false);
      expect(specification1.isSatisfiedBy(z), false);
      expect(specification2.isSatisfiedBy(x), true);
      expect(specification2.isSatisfiedBy(y), false);
      expect(specification2.isSatisfiedBy(z), true);
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

class CustomSpecificationStub extends CustomSpecification {
  CustomSpecificationStub(this.normalized);

  final Specification normalized;

  @override
  Specification normalize() {
    return normalized;
  }
}
