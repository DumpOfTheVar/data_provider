import 'package:data_provider/data_provider.dart';
import 'package:data_provider/src/projector.dart';

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
