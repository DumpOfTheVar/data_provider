import 'package:data_provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
  group('default field converters', () {
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

  group('camel to snake field converters', () {
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

  group('snake to camel field converters', () {
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

    test('converts field name with fieldConverter', () {
      final dataConverter = DataConverter(
        fieldMap: {'firstField': 'another_name'},
        fieldConverter: CamelToSnakeFieldConverter(),
      );
      final json1 = {
        'firstField': 'Test',
        'secondField': 42,
        'thirdField': true,
      };
      final json2 = {
        'another_name': 'Test',
        'second_field': 42,
        'third_field': true,
      };

      expect(dataConverter.convertFieldToData('firstField'), 'another_name');
      expect(dataConverter.convertFieldFromData('another_name'), 'firstField');
      expect(dataConverter.convertFieldToData('testField'), 'test_field');
      expect(dataConverter.convertFieldToData('test_field'), 'test_field');
      expect(dataConverter.convertFieldFromData('testField'), 'testField');
      expect(dataConverter.convertFieldFromData('test_field'), 'testField');
      expect(dataConverter.convertToData(json1), json2);
      expect(dataConverter.convertFromData(json2), json1);
    });

    test('converts value', () {
      final dataConverter = DataConverter(
        fieldMap: {'firstField': 'first_field'},
        valueMap: {
          'firstField': (value) => value + '_2',
          'second_field': (value) => value + 1,
        },
        reversedValueMap: {
          'first_field': (value) => value.substring(0, 4),
          'second_field': (value) => value - 1,
        },
      );
      final json1 = {
        'firstField': 'Test',
        'second_field': 42,
        'THIRD_FIELD': true,
      };
      final json2 = {
        'first_field': 'Test_2',
        'second_field': 43,
        'THIRD_FIELD': true,
      };

      expect(dataConverter.convertToData(json1), json2);
      expect(dataConverter.convertFromData(json2), json1);
    });
  });
}
