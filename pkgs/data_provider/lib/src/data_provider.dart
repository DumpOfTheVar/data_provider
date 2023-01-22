
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

abstract class BaseQuery {
}

abstract class BaseQueryFactory<Q extends BaseQuery> {
  Q make({
    Specification? specification,
    Sorter? sorter,
    int? limit,
    int? offset,
  });
}

typedef EntityMap = Map<String, dynamic>;

abstract class SpecificationMapper<S> {
  S map(Specification? specification);
}

abstract class SorterMapper<S> {
  S map(Sorter? sorter);
}
