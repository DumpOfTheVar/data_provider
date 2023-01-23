import 'operator.dart';
import 'projector.dart';

abstract class Specification<T> {
  bool isSatisfiedBy(T entity);
}

class True<T> implements Specification<T> {
  @override
  bool isSatisfiedBy(T entity) {
    return true;
  }
}

class False<T> implements Specification<T> {
  @override
  bool isSatisfiedBy(T entity) {
    return false;
  }
}

class Not<T> implements Specification<T> {
  Not(this.child);

  final Specification<T> child;

  @override
  bool isSatisfiedBy(T entity) {
    return !child.isSatisfiedBy(entity);
  }
}

abstract class CompositeSpecification<T> implements Specification<T> {
  const CompositeSpecification(this.children);

  final List<Specification<T>> children;
}

class And<T> extends CompositeSpecification<T> {
  const And(super.children);

  @override
  bool isSatisfiedBy(T entity) {
    for (final child in children) {
      if (!child.isSatisfiedBy(entity)) {
        return false;
      }
    }
    return true;
  }
}

class Or<T> extends CompositeSpecification<T> {
  const Or(super.children);

  @override
  bool isSatisfiedBy(T entity) {
    for (final child in children) {
      if (child.isSatisfiedBy(entity)) {
        return true;
      }
    }
    return false;
  }
}

class Compare<T, P> implements Specification<T> {
  const Compare({
    required this.operator,
    required this.projector1,
    required this.projector2,
  });

  final ComparisonOperator<P> operator;
  final Projector<T, P> projector1;
  final Projector<T, P> projector2;

  @override
  bool isSatisfiedBy(T entity) => operator.apply(
        projector1.project(entity),
        projector2.project(entity),
      );
}

abstract class CustomSpecification<T> implements Specification<T> {
  @override
  bool isSatisfiedBy(T entity) {
    return normalize().isSatisfiedBy(entity);
  }

  Specification<T> normalize();
}

class CompareFieldValue<T, P> extends CustomSpecification<T> {
  CompareFieldValue({
    required String field,
    P Function(T)? getter,
    required P value,
    required ComparisonOperator<P> operator,
  }) {
    normalized = Compare(
      operator: operator,
      projector1: FieldValue<T, P>(field, getter),
      projector2: ConstValue<T, P>(value),
    );
  }

  late final Specification<T> normalized;

  @override
  Specification<T> normalize() {
    return normalized;
  }
}

class CompareTwoFields<T, P> extends CustomSpecification<T> {
  CompareTwoFields({
    required String field1,
    P Function(T)? getter1,
    required String field2,
    P Function(T)? getter2,
    required ComparisonOperator<P> operator,
  }) {
    normalized = Compare(
      operator: operator,
      projector1: FieldValue<T, P>(field1, getter1),
      projector2: FieldValue<T, P>(field2, getter2),
    );
  }

  late final Specification<T> normalized;

  @override
  Specification<T> normalize() {
    return normalized;
  }
}

class Between<T, P> extends CustomSpecification<T> {
  Between({
    required String field,
    P Function(T)? getter,
    required P from,
    required P to,
  }) {
    normalized = And<T>([
      CompareFieldValue<T, P>(
        field: field,
        getter: getter,
        operator: GreaterOrEquals<P>(),
        value: from,
      ),
      CompareFieldValue<T, P>(
        field: field,
        getter: getter,
        operator: Less<P>(),
        value: to,
      ),
    ]);
  }

  late final Specification<T> normalized;

  @override
  Specification<T> normalize() {
    return normalized;
  }
}
