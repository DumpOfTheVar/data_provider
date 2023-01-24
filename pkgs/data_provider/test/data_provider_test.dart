import 'package:data_provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
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