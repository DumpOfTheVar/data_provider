import 'package:data_provider/src/operator.dart';
import 'package:test/test.dart';

void main() {
  group('equals operator', () {
    test('toString', () {
      final operator = Equals<String>();
      expect(operator.toString(), '==');
    });

    test('works on strings', () {
      final operator = Equals<String>();
      expect(operator.apply('', ''), true);
      expect(operator.apply('', 'a'), false);
      expect(operator.apply('a', ''), false);
      expect(operator.apply('Test', 'Test'), true);
      expect(operator.apply('Test', 'Test_2'), false);
      expect(operator.apply('Test', 'Tes'), false);
      expect(operator.apply('1234', '1234'), true);
      expect(operator.apply('1234', '1235'), false);
      expect(operator.apply('1234', '1233'), false);
    });

    test('works on numbers', () {
      final operator = Equals<num>();
      expect(operator.apply(0, 0), true);
      expect(operator.apply(5, 10), false);
      expect(operator.apply(10, 5), false);
      expect(operator.apply(0, 42), false);
      expect(operator.apply(0, -42), false);
      expect(operator.apply(42, 42), true);
      expect(operator.apply(42, -42), false);
      expect(operator.apply(-42, 42), false);
      expect(operator.apply(-42, -42), true);
      expect(operator.apply(42, 42.0), true);
      expect(operator.apply(5, 10.0), false);
      expect(operator.apply(10, 5.0), false);
      expect(operator.apply(36.6, 36.6), true);
      expect(operator.apply(36.6, -36.6), false);
      expect(operator.apply(-36.6, 36.6), false);
      expect(operator.apply(-36.6, -36.6), true);
      expect(operator.apply(5.5, 10.2), false);
      expect(operator.apply(10.2, 5.5), false);
    });
  });

  group('less operator', () {
    test('toString', () {
      final operator = Less<String>();
      expect(operator.toString(), '<');
    });

    test('works on strings', () {
      final operator = Less<String>();
      expect(operator.apply('', ''), false);
      expect(operator.apply('', 'a'), true);
      expect(operator.apply('a', ''), false);
      expect(operator.apply('Test', 'Test'), false);
      expect(operator.apply('Test', 'Test_2'), true);
      expect(operator.apply('Test', 'Tes'), false);
      expect(operator.apply('1234', '1234'), false);
      expect(operator.apply('1234', '1235'), true);
      expect(operator.apply('1234', '1233'), false);
    });

    test('works on numbers', () {
      final operator = Less<num>();
      expect(operator.apply(0, 0), false);
      expect(operator.apply(5, 10), true);
      expect(operator.apply(10, 5), false);
      expect(operator.apply(0, 42), true);
      expect(operator.apply(0, -42), false);
      expect(operator.apply(42, 42), false);
      expect(operator.apply(42, -42), false);
      expect(operator.apply(-42, 42), true);
      expect(operator.apply(-42, -42), false);
      expect(operator.apply(42, 42.0), false);
      expect(operator.apply(5, 10.0), true);
      expect(operator.apply(10, 5.0), false);
      expect(operator.apply(36.6, 36.6), false);
      expect(operator.apply(36.6, -36.6), false);
      expect(operator.apply(-36.6, 36.6), true);
      expect(operator.apply(-36.6, -36.6), false);
      expect(operator.apply(5.5, 10.2), true);
      expect(operator.apply(10.2, 5.5), false);
    });

    test('throws exception on non comparable type', () {
      expect(() => Less().apply([], []), throwsException);
      expect(() => Less<List>().apply([], []), throwsException);
      expect(() => Less<Map>().apply({}, {}), throwsException);
    });
  });

  group('less or equals operator', () {
    test('toString', () {
      final operator = LessOrEquals<String>();
      expect(operator.toString(), '<=');
    });

    test('works on strings', () {
      final operator = LessOrEquals<String>();
      expect(operator.apply('', ''), true);
      expect(operator.apply('', 'a'), true);
      expect(operator.apply('a', ''), false);
      expect(operator.apply('Test', 'Test'), true);
      expect(operator.apply('Test', 'Test_2'), true);
      expect(operator.apply('Test', 'Tes'), false);
      expect(operator.apply('1234', '1234'), true);
      expect(operator.apply('1234', '1235'), true);
      expect(operator.apply('1234', '1233'), false);
    });

    test('works on numbers', () {
      final operator = LessOrEquals<num>();
      expect(operator.apply(0, 0), true);
      expect(operator.apply(5, 10), true);
      expect(operator.apply(10, 5), false);
      expect(operator.apply(0, 42), true);
      expect(operator.apply(0, -42), false);
      expect(operator.apply(42, 42), true);
      expect(operator.apply(42, -42), false);
      expect(operator.apply(-42, 42), true);
      expect(operator.apply(-42, -42), true);
      expect(operator.apply(42, 42.0), true);
      expect(operator.apply(5, 10.0), true);
      expect(operator.apply(10, 5.0), false);
      expect(operator.apply(36.6, 36.6), true);
      expect(operator.apply(36.6, -36.6), false);
      expect(operator.apply(-36.6, 36.6), true);
      expect(operator.apply(-36.6, -36.6), true);
      expect(operator.apply(5.5, 10.2), true);
      expect(operator.apply(10.2, 5.5), false);
    });

    test('throws exception on non comparable type', () {
      expect(() => LessOrEquals().apply([], []), throwsException);
      expect(() => LessOrEquals<List>().apply([], []), throwsException);
      expect(() => LessOrEquals<Map>().apply({}, {}), throwsException);
    });
  });

  group('greater operator', () {
    test('toString', () {
      final operator = Greater<String>();
      expect(operator.toString(), '>');
    });

    test('works on strings', () {
      final operator = Greater<String>();
      expect(operator.apply('', ''), false);
      expect(operator.apply('', 'a'), false);
      expect(operator.apply('a', ''), true);
      expect(operator.apply('Test', 'Test'), false);
      expect(operator.apply('Test', 'Test_2'), false);
      expect(operator.apply('Test', 'Tes'), true);
      expect(operator.apply('1234', '1234'), false);
      expect(operator.apply('1234', '1235'), false);
      expect(operator.apply('1234', '1233'), true);
    });

    test('works on numbers', () {
      final operator = Greater<num>();
      expect(operator.apply(0, 0), false);
      expect(operator.apply(5, 10), false);
      expect(operator.apply(10, 5), true);
      expect(operator.apply(0, 42), false);
      expect(operator.apply(0, -42), true);
      expect(operator.apply(42, 42), false);
      expect(operator.apply(42, -42), true);
      expect(operator.apply(-42, 42), false);
      expect(operator.apply(-42, -42), false);
      expect(operator.apply(42, 42.0), false);
      expect(operator.apply(5, 10.0), false);
      expect(operator.apply(10, 5.0), true);
      expect(operator.apply(36.6, 36.6), false);
      expect(operator.apply(36.6, -36.6), true);
      expect(operator.apply(-36.6, 36.6), false);
      expect(operator.apply(-36.6, -36.6), false);
      expect(operator.apply(5.5, 10.2), false);
      expect(operator.apply(10.2, 5.5), true);
    });

    test('throws exception on non comparable type', () {
      expect(() => Greater().apply([], []), throwsException);
      expect(() => Greater<List>().apply([], []), throwsException);
      expect(() => Greater<Map>().apply({}, {}), throwsException);
    });
  });

  group('greater or equals operator', () {
    test('toString', () {
      final operator = GreaterOrEquals<String>();
      expect(operator.toString(), '>=');
    });

    test('works on strings', () {
      final operator = GreaterOrEquals<String>();
      expect(operator.apply('', ''), true);
      expect(operator.apply('', 'a'), false);
      expect(operator.apply('a', ''), true);
      expect(operator.apply('Test', 'Test'), true);
      expect(operator.apply('Test', 'Test_2'), false);
      expect(operator.apply('Test', 'Tes'), true);
      expect(operator.apply('1234', '1234'), true);
      expect(operator.apply('1234', '1235'), false);
      expect(operator.apply('1234', '1233'), true);
    });

    test('works on numbers', () {
      final operator = GreaterOrEquals<num>();
      expect(operator.apply(0, 0), true);
      expect(operator.apply(5, 10), false);
      expect(operator.apply(10, 5), true);
      expect(operator.apply(0, 42), false);
      expect(operator.apply(0, -42), true);
      expect(operator.apply(42, 42), true);
      expect(operator.apply(42, -42), true);
      expect(operator.apply(-42, 42), false);
      expect(operator.apply(-42, -42), true);
      expect(operator.apply(42, 42.0), true);
      expect(operator.apply(5, 10.0), false);
      expect(operator.apply(10, 5.0), true);
      expect(operator.apply(36.6, 36.6), true);
      expect(operator.apply(36.6, -36.6), true);
      expect(operator.apply(-36.6, 36.6), false);
      expect(operator.apply(-36.6, -36.6), true);
      expect(operator.apply(5.5, 10.2), false);
      expect(operator.apply(10.2, 5.5), true);
    });

    test('throws exception on non comparable type', () {
      expect(() => GreaterOrEquals().apply([], []), throwsException);
      expect(() => GreaterOrEquals<List>().apply([], []), throwsException);
      expect(() => GreaterOrEquals<Map>().apply({}, {}), throwsException);
    });
  });

  group('plus operator', () {
    test('toString', () {
      final operator = Plus();
      expect(operator.toString(), '+');
    });

    test('works on integers', () {
      final operator = Plus<int>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(42, 0), 42);
      expect(operator.apply(0, 42), 42);
      expect(operator.apply(-42, 0), -42);
      expect(operator.apply(0, -42), -42);
      expect(operator.apply(42, 42), 84);
      expect(operator.apply(42, -42), 0);
      expect(operator.apply(-42, 42), 0);
      expect(operator.apply(-42, -42), -84);
      expect(operator.apply(42, 100), 142);
      expect(operator.apply(42, -100), -58);
    });

    test('works on doubles', () {
      final operator = Plus<double>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(36.6, 0), 36.6);
      expect(operator.apply(0, 36.6), 36.6);
      expect(operator.apply(-36.6, 0), -36.6);
      expect(operator.apply(0, -36.6), -36.6);
      expect(operator.apply(36.6, 36.6), 73.2);
      expect(operator.apply(36.6, -36.6), 0);
      expect(operator.apply(-36.6, 36.6), 0);
      expect(operator.apply(-36.6, -36.6), -73.2);
      expect(operator.apply(36.6, 100), 136.6);
      expect(operator.apply(36.6, -100), -63.4);
    });
  });

  group('minus operator', () {
    test('toString', () {
      final operator = Minus();
      expect(operator.toString(), '-');
    });

    test('works on integers', () {
      final operator = Minus<int>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(42, 0), 42);
      expect(operator.apply(0, 42), -42);
      expect(operator.apply(-42, 0), -42);
      expect(operator.apply(0, -42), 42);
      expect(operator.apply(42, 42), 0);
      expect(operator.apply(42, -42), 84);
      expect(operator.apply(-42, 42), -84);
      expect(operator.apply(-42, -42), 0);
      expect(operator.apply(42, 100), -58);
      expect(operator.apply(42, -100), 142);
    });

    test('works on doubles', () {
      final operator = Minus<double>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(36.6, 0), 36.6);
      expect(operator.apply(0, 36.6), -36.6);
      expect(operator.apply(-36.6, 0), -36.6);
      expect(operator.apply(0, -36.6), 36.6);
      expect(operator.apply(36.6, 36.6), 0);
      expect(operator.apply(36.6, -36.6), 73.2);
      expect(operator.apply(-36.6, 36.6), -73.2);
      expect(operator.apply(-36.6, -36.6), 0);
      expect(operator.apply(36.6, 100), -63.4);
      expect(operator.apply(36.6, -100), 136.6);
    });
  });

  group('multiply operator', () {
    test('toString', () {
      final operator = Multiply();
      expect(operator.toString(), '*');
    });

    test('works on integers', () {
      final operator = Multiply<int>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(42, 0), 0);
      expect(operator.apply(0, 42), 0);
      expect(operator.apply(-42, 0), 0);
      expect(operator.apply(0, -42), 0);
      expect(operator.apply(42, 42), 42 * 42);
      expect(operator.apply(42, -42), -42 * 42);
      expect(operator.apply(-42, 42), -42 * 42);
      expect(operator.apply(-42, -42), 42 * 42);
      expect(operator.apply(42, 100), 42 * 100);
      expect(operator.apply(42, -100), -42 * 100);
    });

    test('works on doubles', () {
      final operator = Multiply<double>();
      expect(operator.apply(0, 0), 0);
      expect(operator.apply(36.6, 0), 0);
      expect(operator.apply(0, 36.6), 0);
      expect(operator.apply(-36.6, 0), 0);
      expect(operator.apply(0, -36.6), 0);
      expect(operator.apply(36.6, 36.6), 36.6 * 36.6);
      expect(operator.apply(36.6, -36.6), -36.6 * 36.6);
      expect(operator.apply(-36.6, 36.6), -36.6 * 36.6);
      expect(operator.apply(-36.6, -36.6), 36.6 * 36.6);
      expect(operator.apply(36.6, 100), 36.6 * 100);
      expect(operator.apply(36.6, -100), -36.6 * 100);
    });
  });

  group('divide operator', () {
    test('toString', () {
      final operator = Divide();
      expect(operator.toString(), '/');
    });

    test('works on integers', () {
      final operator = Divide();
      expect(operator.apply(0, 42), 0);
      expect(operator.apply(0, -42), 0);
      expect(operator.apply(42, 42), 42 / 42);
      expect(operator.apply(42, -42), -42 / 42);
      expect(operator.apply(-42, 42), -42 / 42);
      expect(operator.apply(-42, -42), 42 / 42);
      expect(operator.apply(42, 100), 42 / 100);
      expect(operator.apply(42, -100), -42 / 100);
    });

    test('works on doubles', () {
      final operator = Divide();
      expect(operator.apply(0, 36.6), 0);
      expect(operator.apply(0, -36.6), 0);
      expect(operator.apply(36.6, 36.6), 36.6 / 36.6);
      expect(operator.apply(36.6, -36.6), -36.6 / 36.6);
      expect(operator.apply(-36.6, 36.6), -36.6 / 36.6);
      expect(operator.apply(-36.6, -36.6), 36.6 / 36.6);
      expect(operator.apply(36.6, 100), 36.6 / 100);
      expect(operator.apply(36.6, -100), -36.6 / 100);
    });
  });

  group('int divide operator', () {
    test('toString', () {
      final operator = IntDivide();
      expect(operator.toString(), '~/');
    });

    test('works on integers', () {
      final operator = IntDivide();
      expect(operator.apply(0, 42), 0);
      expect(operator.apply(0, -42), 0);
      expect(operator.apply(42, 42), 42 ~/ 42);
      expect(operator.apply(42, -42), -42 ~/ 42);
      expect(operator.apply(-42, 42), -42 ~/ 42);
      expect(operator.apply(-42, -42), 42 ~/ 42);
      expect(operator.apply(42, 100), 42 ~/ 100);
      expect(operator.apply(42, -100), -42 ~/ 100);
      expect(operator.apply(42, 3), 42 ~/ 3);
      expect(operator.apply(42, 5), 42 ~/ 5);
      expect(operator.apply(42, 11), 42 ~/ 11);
    });
  });

  group('modulo operator', () {
    test('toString', () {
      final operator = Modulo();
      expect(operator.toString(), '%');
    });

    test('works on integers', () {
      final operator = Modulo();
      expect(operator.apply(0, 42), 0);
      expect(operator.apply(0, -42), 0);
      expect(operator.apply(42, 42), 0);
      expect(operator.apply(42, -42), 0);
      expect(operator.apply(-42, 42), 0);
      expect(operator.apply(-42, -42), 0);
      expect(operator.apply(42, 100), 42 % 100);
      expect(operator.apply(42, -100), 42 % -100);
      expect(operator.apply(42, 3), 42 % 3);
      expect(operator.apply(42, 5), 42 % 5);
      expect(operator.apply(42, 11), 42 % 11);
    });
  });

  group('unary minus operator', () {
    test('works on integers', () {
      final operator = UnaryMinus<int>();
      expect(operator.apply(0), 0);
      expect(operator.apply(42), -42);
      expect(operator.apply(-42), 42);
    });

    test('works on doubles', () {
      final operator = UnaryMinus<double>();
      expect(operator.apply(0), 0);
      expect(operator.apply(36.6), -36.6);
      expect(operator.apply(-36.6), 36.6);
    });
  });

  group('concat operator', () {
    test('toString', () {
      final operator = Concat();
      expect(operator.toString(), 'concat');
    });

    test('works', () {
      final operator = Concat();
      expect(operator.apply('', ''), '');
      expect(operator.apply('Test', ''), 'Test');
      expect(operator.apply('', 'Test'), 'Test');
      expect(operator.apply('Test', 'Test'), 'TestTest');
      expect(operator.apply('abc', 'def'), 'abcdef');
    });
  });

  group('substring operator', () {
    test('works for beginning of string', () {
      final operator1 = Substring(0);
      final operator2 = Substring(0, 0);
      final operator3 = Substring(0, 3);
      final operator4 = Substring(0, 4);
      final operator5 = Substring(0, 10);
      expect(operator1.apply(''), '');
      expect(operator2.apply(''), '');
      expect(operator3.apply(''), '');
      expect(operator4.apply(''), '');
      expect(operator5.apply(''), '');
      expect(operator1.apply('Test'), 'Test');
      expect(operator2.apply('Test'), '');
      expect(operator3.apply('Test'), 'Tes');
      expect(operator4.apply('Test'), 'Test');
      expect(operator5.apply('Test'), 'Test');
    });

    test('works for middle of string', () {
      final operator1 = Substring(1);
      final operator2 = Substring(1, 1);
      final operator3 = Substring(1, 3);
      final operator4 = Substring(1, 4);
      final operator5 = Substring(1, 10);
      expect(operator1.apply(''), '');
      expect(operator2.apply(''), '');
      expect(operator3.apply(''), '');
      expect(operator4.apply(''), '');
      expect(operator5.apply(''), '');
      expect(operator1.apply('Test'), 'est');
      expect(operator2.apply('Test'), '');
      expect(operator3.apply('Test'), 'es');
      expect(operator4.apply('Test'), 'est');
      expect(operator5.apply('Test'), 'est');
    });

    test('works for end of string', () {
      final operator1 = Substring(4);
      final operator2 = Substring(4, 4);
      final operator3 = Substring(4, 10);
      expect(operator1.apply(''), '');
      expect(operator2.apply(''), '');
      expect(operator3.apply(''), '');
      expect(operator1.apply('Test'), '');
      expect(operator2.apply('Test'), '');
      expect(operator3.apply('Test'), '');
    });
  });
}
