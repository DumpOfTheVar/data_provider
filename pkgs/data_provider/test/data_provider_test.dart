import 'package:data_provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
  group('default field converter', () {
    test('converts to data', () {
      final fieldConverter = DefaultFieldConverter();

      expect(fieldConverter.convertToData('test'), 'test');
      expect(fieldConverter.convertToData('testField'), 'testField');
      expect(fieldConverter.convertToData('longTestField'), 'longTestField');
      expect(fieldConverter.convertToData('test_field'), 'test_field');
      expect(
          fieldConverter.convertToData('long_test_field'), 'long_test_field');
    });

    test('converts from data', () {
      final fieldConverter = DefaultFieldConverter();

      expect(fieldConverter.convertFromData('test'), 'test');
      expect(fieldConverter.convertFromData('testField'), 'testField');
      expect(fieldConverter.convertFromData('longTestField'), 'longTestField');
      expect(fieldConverter.convertFromData('test_field'), 'test_field');
      expect(
          fieldConverter.convertFromData('long_test_field'), 'long_test_field');
    });
  });

  group('camel to snake field converter', () {
    test('converts to data', () {
      final fieldConverter = CamelToSnakeFieldConverter();

      expect(fieldConverter.convertToData('test'), 'test');
      expect(fieldConverter.convertToData('testField'), 'test_field');
      expect(fieldConverter.convertToData('longTestField'), 'long_test_field');
      expect(fieldConverter.convertToData('test_field'), 'test_field');
      expect(
          fieldConverter.convertToData('long_test_field'), 'long_test_field');
    });

    test('converts from data', () {
      final fieldConverter = CamelToSnakeFieldConverter();

      expect(fieldConverter.convertFromData('test'), 'test');
      expect(fieldConverter.convertFromData('testField'), 'testField');
      expect(fieldConverter.convertFromData('longTestField'), 'longTestField');
      expect(fieldConverter.convertFromData('test_field'), 'testField');
      expect(
          fieldConverter.convertFromData('long_test_field'), 'longTestField');
    });
  });

  group('snake to camel field converter', () {
    test('converts to data', () {
      final fieldConverter = SnakeToCamelFieldConverter();

      expect(fieldConverter.convertToData('test'), 'test');
      expect(fieldConverter.convertToData('testField'), 'testField');
      expect(fieldConverter.convertToData('longTestField'), 'longTestField');
      expect(fieldConverter.convertToData('test_field'), 'testField');
      expect(fieldConverter.convertToData('long_test_field'), 'longTestField');
    });

    test('converts from data', () {
      final fieldConverter = SnakeToCamelFieldConverter();

      expect(fieldConverter.convertFromData('test'), 'test');
      expect(fieldConverter.convertFromData('testField'), 'test_field');
      expect(
          fieldConverter.convertFromData('longTestField'), 'long_test_field');
      expect(fieldConverter.convertFromData('test_field'), 'test_field');
      expect(
          fieldConverter.convertFromData('long_test_field'), 'long_test_field');
    });
  });

  group('default value converter', () {
    test('converts to data', () {
      final valueConverter = DefaultValueConverter();

      expect(valueConverter.convertToData(42), 42);
      expect(valueConverter.convertToData('Test'), 'Test');
      expect(valueConverter.convertToData(true), true);
      expect(valueConverter.convertToData({'field': 42}), {'field': 42});
      expect(valueConverter.convertToData([1, 2, 3]), [1, 2, 3]);
      expect(valueConverter.convertToData(DateTime(10000)), DateTime(10000));
    });

    test('converts from data', () {
      final valueConverter = DefaultValueConverter();

      expect(valueConverter.convertFromData(42), 42);
      expect(valueConverter.convertFromData('Test'), 'Test');
      expect(valueConverter.convertFromData(true), true);
      expect(valueConverter.convertFromData({'field': 42}), {'field': 42});
      expect(valueConverter.convertFromData([1, 2, 3]), [1, 2, 3]);
      expect(valueConverter.convertFromData(DateTime(10000)), DateTime(10000));
    });
  });

  group('num to string value converter', () {
    test('converts to data', () {
      final valueConverter = NumToStringValueConverter();

      expect(valueConverter.convertToData(42), '42');
      expect(valueConverter.convertToData(-42), '-42');
      expect(valueConverter.convertToData(36.6), '36.6');
      expect(valueConverter.convertToData(-36.6), '-36.6');
    });

    test('converts from data', () {
      final valueConverter = NumToStringValueConverter();

      expect(valueConverter.convertFromData('42'), 42);
      expect(valueConverter.convertFromData('-42'), -42);
      expect(valueConverter.convertFromData('36.6'), 36.6);
      expect(valueConverter.convertFromData('-36.6'), -36.6);
    });
  });

  group('bool to string value converter', () {
    test('converts to data', () {
      final valueConverter = BoolToStringValueConverter();

      expect(valueConverter.convertToData(true), '1');
      expect(valueConverter.convertToData(false), '0');
    });

    test('converts from data', () {
      final valueConverter = BoolToStringValueConverter();

      expect(valueConverter.convertFromData('1'), true);
      expect(valueConverter.convertFromData('0'), false);
    });
  });

  group('date time to string value converter', () {
    test('converts to data', () {
      final valueConverter = DateTimeToStringValueConverter();

      expect(
        valueConverter
            .convertToData(DateTime.parse('1991-08-24 12:34:56Z').toLocal()),
        '1991-08-24 12:34:56.000Z',
      );
    });

    test('converts from data', () {
      final valueConverter = DateTimeToStringValueConverter();

      expect(
        valueConverter.convertFromData('1991-08-24 12:34:56.000Z'),
        DateTime.parse('1991-08-24 12:34:56Z').toLocal(),
      );
    });
  });

  group('json to string value converter', () {
    test('converts to data', () {
      final valueConverter = JsonToStringValueConverter();

      expect(valueConverter.convertToData({'field': 42}), '{"field":42}');
    });

    test('converts from data', () {
      final valueConverter = JsonToStringValueConverter();

      expect(valueConverter.convertFromData('{"field":42}'), {'field': 42});
    });
  });

  group('data converter', () {
    test('does not change data by default', () {
      final dataConverter = DataConverter();
      final json = {
        'firstField': 'Test',
        'second_field': 42,
        'THIRD_FIELD': true,
      };

      expect(dataConverter.convertFieldToData('testField'), 'testField');
      expect(dataConverter.convertFieldToData('test_field'), 'test_field');
      expect(dataConverter.convertFieldFromData('testField'), 'testField');
      expect(dataConverter.convertFieldFromData('test_field'), 'test_field');
      expect(dataConverter.convertToData(json), json);
      expect(dataConverter.convertFromData(json), json);
    });

    test('converts field name', () {
      final dataConverter = DataConverter(
        fieldMap: {'firstField': 'first_field'},
      );
      final json1 = {
        'firstField': 'Test',
        'second_field': 42,
        'THIRD_FIELD': true,
      };
      final json2 = {
        'first_field': 'Test',
        'second_field': 42,
        'THIRD_FIELD': true,
      };

      expect(dataConverter.convertFieldToData('firstField'), 'first_field');
      expect(dataConverter.convertFieldFromData('first_field'), 'firstField');
      expect(dataConverter.convertFieldToData('testField'), 'testField');
      expect(dataConverter.convertFieldToData('test_field'), 'test_field');
      expect(dataConverter.convertFieldFromData('testField'), 'testField');
      expect(dataConverter.convertFieldFromData('test_field'), 'test_field');
      expect(dataConverter.convertToData(json1), json2);
      expect(dataConverter.convertFromData(json2), json1);
    });

    test('converts value', () {
      final dataConverter = DataConverter(
        fieldMap: {'firstField': 'first_field'},
        valueMap: {
          'second_field': const NumToStringValueConverter(),
          'THIRD_FIELD': const BoolToStringValueConverter(),
        },
      );
      final json1 = {
        'firstField': 'Test',
        'second_field': 42,
        'THIRD_FIELD': true,
      };
      final json2 = {
        'first_field': 'Test',
        'second_field': '42',
        'THIRD_FIELD': '1',
      };

      expect(dataConverter.convertToData(json1), json2);
      expect(dataConverter.convertFromData(json2), json1);
    });
  });
}
