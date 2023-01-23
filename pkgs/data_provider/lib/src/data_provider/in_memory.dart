import '../data_provider.dart';
import '../exception.dart';
import '../projector.dart';
import '../sorter.dart';
import '../specification.dart';

class InMemoryDataProvider implements DataProvider {
  InMemoryDataProvider({
    required this.specificationMapper,
    required this.sorterMapper,
    this.idField = 'id',
    int delay = 0,
    List<EntityMap>? data,
  }) {
    _delay = Duration(milliseconds: delay);
    for (final entity in data ?? []) {
      _data[entity[idField]!.toString()] = entity;
    }
  }

  final InMemorySpecificationMapper specificationMapper;
  final InMemorySorterMapper sorterMapper;
  final String idField;
  late final Duration _delay;
  final Map<String, EntityMap> _data = {};

  @override
  Future<List<EntityMap>> findAll({
    Specification? specification,
    Sorter? sorter,
    int? limit,
    int? offset,
  }) {
    final test = specificationMapper.map(specification);
    final compare = sorterMapper.map(sorter);
    return Future<List<EntityMap>>.delayed(_delay, () {
      final data = _data.values.where(test).toList();
      data.sort(compare);
      return data;
    });
  }

  @override
  Future<EntityMap?> findById(String id) {
    return Future<EntityMap?>.delayed(_delay, () => _data[id]);
  }

  @override
  Future<EntityMap?> findOne({
    required Specification specification,
    Sorter? sorter,
  }) {
    final test = specificationMapper.map(specification);
    final compare = sorterMapper.map(sorter);
    return Future<EntityMap?>.delayed(_delay, () {
      final data = _data.values.where(test).toList();
      data.sort(compare);
      return data.isNotEmpty ? data.first : null;
    });
  }

  @override
  Future<void> saveOne(EntityMap map) {
    _data[map[idField].toString()] = map;
    return Future.delayed(_delay);
  }

  @override
  Future<void> saveAll(List<EntityMap> maps) {
    for (final map in maps) {
      _data[map[idField].toString()] = map;
    }
    return Future.delayed(_delay);
  }

  @override
  Future<void> deleteById(String id) {
    _data.remove(id);
    return Future.delayed(_delay);
  }

  @override
  Future<void> deleteAll(Specification specification) {
    final test = specificationMapper.map(specification);
    _data.removeWhere((id, entity) => test(entity));
    return Future.delayed(_delay);
  }
}

typedef InMemoryProjector<V> = V Function(EntityMap);
typedef InMemorySpecification = bool Function(EntityMap);
typedef InMemorySorter = int Function(EntityMap, EntityMap);

class InMemoryProjectorMapper {
  InMemoryProjector map(Projector projector) {
    if (projector is ConstValue) {
      return (EntityMap _) => projector.value;
    }
    if (projector is FieldValue) {
      return (EntityMap entityMap) => entityMap[projector.field];
    }
    if (projector is UnaryExpression) {
      final p = map(projector.p);
      return (EntityMap entityMap) => projector.operator.apply(p(entityMap));
    }
    if (projector is BinaryExpression) {
      final p1 = map(projector.p1);
      final p2 = map(projector.p2);
      return (EntityMap entityMap) =>
          projector.operator.apply(p1(entityMap), p2(entityMap));
    }
    throw TypeNotSupportedException(
      'InMemoryDataProvider does not support'
      'projector type ${projector.runtimeType}.',
    );
  }
}

class InMemorySpecificationMapper
    extends SpecificationMapper<InMemorySpecification> {
  InMemorySpecificationMapper({required this.projectorMapper});

  final InMemoryProjectorMapper projectorMapper;

  @override
  InMemorySpecification map(Specification? specification) {
    if (specification == null) {
      return (EntityMap _) => true;
    }
    if (specification is True) {
      return (EntityMap _) => true;
    }
    if (specification is False) {
      return (EntityMap _) => false;
    }
    if (specification is Not) {
      final child = map(specification.child);
      return (EntityMap entityMap) => !child(entityMap);
    }
    if (specification is CompositeSpecification) {
      final children = specification.children.map(map).toList();
      if (specification is And) {
        return (EntityMap entityMap) => !children.any((s) => !s(entityMap));
      }
      if (specification is Or) {
        return (EntityMap entityMap) => children.any((s) => s(entityMap));
      }
      throw TypeNotSupportedException(
        'InMemoryDataProvider does not support'
        'specification type ${specification.runtimeType}.',
      );
    }
    if (specification is Compare) {
      final p1 = projectorMapper.map(specification.projector1);
      final p2 = projectorMapper.map(specification.projector2);
      return (EntityMap entityMap) =>
          specification.operator.apply(p1(entityMap), p2(entityMap));
    }
    if (specification is CustomSpecification) {
      return map(specification.normalize());
    }
    throw TypeNotSupportedException(
      'InMemoryDataProvider does not support specification type ${specification.runtimeType}.',
    );
  }
}

class InMemorySorterMapper extends SorterMapper<InMemorySorter> {
  InMemorySorterMapper({required this.projectorMapper});

  final InMemoryProjectorMapper projectorMapper;

  @override
  InMemorySorter map(Sorter? sorter) {
    if (sorter == null) {
      return (EntityMap _, EntityMap __) => 0;
    }
    if (sorter is CompositeSorter) {
      final children = sorter.children.map(map);
      return (EntityMap a, EntityMap b) => children
          .map((sorter) => sorter(a, b))
          .firstWhere((result) => result != 0, orElse: () => 0);
    }
    if (sorter is CustomSorter) {
      return map(sorter.normalize());
    }
    if (sorter is ValueSorter) {
      final projector = projectorMapper.map(sorter.projector);
      return (EntityMap a, EntityMap b) =>
          Sorter.compareValues(projector(a), projector(b), sorter.isAsc);
    }
    throw TypeNotSupportedException(
      'InMemoryDataProvider does not support sorter type ${sorter.runtimeType}.',
    );
  }
}
