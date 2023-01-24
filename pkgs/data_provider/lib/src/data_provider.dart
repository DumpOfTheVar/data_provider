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

class DataConverter {
  DataConverter({
    Map<String, String> fieldMap = const {},
    Map<String, Function(dynamic)> valueMap = const {},
    Map<String, Function(dynamic)> reversedValueMap = const {},
  }) {
    _fieldMap = fieldMap;
    _reversedFieldMap = {};
    for (final entry in fieldMap.entries) {
      _reversedFieldMap[entry.value] = entry.key;
    }
    _valueMap = valueMap;
    _reversedValueMap = reversedValueMap;
  }

  late final Map<String, String> _fieldMap;
  late final Map<String, String> _reversedFieldMap;
  late final Map<String, Function(dynamic)> _valueMap;
  late final Map<String, Function(dynamic)> _reversedValueMap;

  String convertFieldToData(String field) {
    return _convertField(_fieldMap, field);
  }

  String convertFieldFromData(String field) {
    return _convertField(_reversedFieldMap, field);
  }

  Map<String, dynamic> convertToData(Map<String, dynamic> json) {
    return _convertJson(_fieldMap, _valueMap, json);
  }

  Map<String, dynamic> convertFromData(Map<String, dynamic> json) {
    return _convertJson(_reversedFieldMap, _reversedValueMap, json);
  }

  String _convertField(Map<String, String> map, String field) {
    return map[field] ?? field;
  }

  _convertValue(Map<String, Function(dynamic)> map, String field, value) {
    if (!map.containsKey(field)) {
      return value;
    }
    return map[field]!(value);
  }

  Map<String, dynamic> _convertJson(
    Map<String, String> fieldMap,
    Map<String, Function(dynamic)> valueMap,
    Map<String, dynamic> json,
  ) {
    final result = <String, dynamic>{};
    for (String field in json.keys) {
      final convertedField = _convertField(fieldMap, field);
      final convertedValue = _convertValue(valueMap, field, json[field]);
      result[convertedField] = convertedValue;
    }
    return result;
  }
}
