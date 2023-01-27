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
  Object? convertFromData(Object? value) => value;

  @override
  Object? convertToData(Object? value) => value;
}

class DataConverter {
  DataConverter({
    Map<String, String> fieldMap = const {},
    FieldConverter fieldConverter = const DefaultFieldConverter(),
    Map<String, Function(dynamic)> valueMap = const {},
    Map<String, Function(dynamic)> reversedValueMap = const {},
    ValueConverter valueConverter = const DefaultValueConverter(),
  }) {
    _fieldMap = fieldMap;
    _reversedFieldMap = {};
    for (final entry in fieldMap.entries) {
      _reversedFieldMap[entry.value] = entry.key;
    }
    _fieldConverter = fieldConverter;
    _valueMap = valueMap;
    _reversedValueMap = reversedValueMap;
    _valueConverter = valueConverter;
  }

  late final Map<String, String> _fieldMap;
  late final Map<String, String> _reversedFieldMap;
  late final FieldConverter _fieldConverter;
  late final Map<String, Function(dynamic)> _valueMap;
  late final Map<String, Function(dynamic)> _reversedValueMap;
  late final ValueConverter _valueConverter;

  String convertFieldToData(String field) {
    return _fieldMap[field] ?? _fieldConverter.convertToData(field);
  }

  String convertFieldFromData(String field) {
    return _reversedFieldMap[field] ?? _fieldConverter.convertFromData(field);
  }

  Object? convertValueToData(String field, Object? value) {
    return (_valueMap[field] ?? _valueConverter.convertToData)(value);
  }

  Object? convertValueFromData(String field, Object? value) {
    return (_reversedValueMap[field] ?? _valueConverter.convertFromData)(value);
  }

  Map<String, dynamic> convertToData(Map<String, dynamic> json) {
    return _convertJson(convertFieldToData, convertValueToData, json);
  }

  Map<String, dynamic> convertFromData(Map<String, dynamic> json) {
    return _convertJson(convertFieldFromData, convertValueFromData, json);
  }

  Map<String, Object?> _convertJson(
    String Function(String) convertField,
    Object? Function(String, Object?) convertValue,
    Map<String, Object?> json,
  ) {
    final result = <String, Object?>{};
    for (String field in json.keys) {
      final convertedField = convertField(field);
      final convertedValue = convertValue(field, json[field]);
      result[convertedField] = convertedValue;
    }
    return result;
  }
}
