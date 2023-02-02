import 'dart:convert';
import 'package:recase/recase.dart';
import 'operator.dart';
import 'projector.dart';
import 'sorter.dart';
import 'specification.dart';

abstract class DataProvider {
  Future<EntityMap?> findById(String id);
  Future<EntityMap?> findOne({
    required Specification specification,
    Sorter? sorter,
  });
  Future<List<EntityMap>> findAll({
    Specification? specification,
    Sorter? sorter,
    int? limit,
    int? offset,
  });
  Future<void> saveOne(EntityMap map);
  Future<void> saveAll(List<EntityMap> maps);
  Future<void> deleteById(String id);
  Future<void> deleteAll(Specification specification);
}

typedef EntityMap = Map<String, dynamic>;

abstract class UnaryOperatorMapper<S> {
  S map(UnaryOperator operator);
}

abstract class BinaryOperatorMapper<S> {
  S map(BinaryOperator operator);
}

abstract class ProjectorMapper<S> {
  S map(Projector projector);
}

abstract class SpecificationMapper<S> {
  S map(Specification? specification);
}

abstract class SorterMapper<S> {
  S map(Sorter? sorter);
}

abstract class FieldConverter {
  String convertToData(String field);
  String convertFromData(String field);
}

class DefaultFieldConverter implements FieldConverter {
  const DefaultFieldConverter();

  @override
  String convertFromData(String field) => field;

  @override
  String convertToData(String field) => field;
}

class CamelToSnakeFieldConverter implements FieldConverter {
  const CamelToSnakeFieldConverter();

  @override
  String convertToData(String field) => ReCase(field).snakeCase;

  @override
  String convertFromData(String field) => ReCase(field).camelCase;
}

class SnakeToCamelFieldConverter implements FieldConverter {
  const SnakeToCamelFieldConverter();

  @override
  String convertToData(String field) => ReCase(field).camelCase;

  @override
  String convertFromData(String field) => ReCase(field).snakeCase;
}

abstract class ValueConverter {
  Object? convertToData(Object? value);
  Object? convertFromData(Object? value);
}

class DefaultValueConverter implements ValueConverter {
  const DefaultValueConverter();

  @override
  Object? convertToData(Object? value) => value;

  @override
  Object? convertFromData(Object? value) => value;
}

class StringValueConverter implements ValueConverter {
  const StringValueConverter();

  @override
  String? convertToData(Object? value) => value?.toString();

  @override
  String? convertFromData(Object? value) => value?.toString();
}

class NumToStringValueConverter implements ValueConverter {
  const NumToStringValueConverter();

  @override
  String? convertToData(Object? value) => value?.toString();

  @override
  num? convertFromData(Object? value) {
    if (value == null || value == '') {
      return null;
    }
    if (value is num) {
      return value;
    }
    return num.parse(value as String);
  }
}

class BoolToStringValueConverter implements ValueConverter {
  const BoolToStringValueConverter();

  @override
  String? convertToData(Object? value) => value as bool ? '1' : '0';

  @override
  bool? convertFromData(Object? value) {
    if (value == null || value == '') {
      return null;
    }
    if (value is bool) {
      return value;
    }
    return value.toString() == '1';
  }
}

class DateTimeToStringValueConverter implements ValueConverter {
  const DateTimeToStringValueConverter();

  @override
  String? convertToData(Object? value) =>
      (value as DateTime?)?.toUtc().toString();

  @override
  DateTime? convertFromData(Object? value) {
    if (value == null || value == '') {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.parse(value as String).toLocal();
  }
}

class JsonToStringValueConverter implements ValueConverter {
  const JsonToStringValueConverter();

  @override
  String convertToData(Object? value) => jsonEncode(value);

  @override
  Object? convertFromData(Object? value) => jsonDecode(value as String);
}

class DataConverter {
  DataConverter({
    Map<String, String> fieldMap = const {},
    Map<String, ValueConverter> valueMap = const {},
  }) {
    _fieldMap = fieldMap;
    _reversedFieldMap = {};
    for (final entry in fieldMap.entries) {
      _reversedFieldMap[entry.value] = entry.key;
    }
    _valueMap = valueMap;
  }

  late final Map<String, String> _fieldMap;
  late final Map<String, String> _reversedFieldMap;
  late final Map<String, ValueConverter> _valueMap;

  String convertFieldToData(String field) {
    return _fieldMap[field] ?? field;
  }

  String convertFieldFromData(String field) {
    return _reversedFieldMap[field] ?? field;
  }

  Object? convertValueToData(String field, Object? value) {
    if (!_valueMap.containsKey(field)) {
      return value;
    }
    return _valueMap[field]?.convertToData(value);
  }

  Object? convertValueFromData(String field, Object? value) {
    if (!_valueMap.containsKey(field)) {
      return value;
    }
    return _valueMap[field]?.convertFromData(value);
  }

  Map<String, dynamic> convertToData(Map<String, dynamic> json) {
    final result = <String, Object?>{};
    for (String field in json.keys) {
      final convertedField = convertFieldToData(field);
      final convertedValue = convertValueToData(field, json[field]);
      result[convertedField] = convertedValue;
    }
    return result;
  }

  Map<String, dynamic> convertFromData(Map<String, dynamic> json) {
    final result = <String, Object?>{};
    for (String field in json.keys) {
      final convertedField = convertFieldFromData(field);
      final convertedValue = convertValueFromData(convertedField, json[field]);
      result[convertedField] = convertedValue;
    }
    return result;
  }
}
