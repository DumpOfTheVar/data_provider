import 'exception.dart';
import 'operator.dart';
import 'serializable.dart';

abstract class Projector<T, V> {
  V project(T entity);
}

class ConstValue<T, V> implements Projector<T, V> {
  const ConstValue(this.value);

  final V value;

  @override
  V project(entity) => value;
}

class FieldValue<T, V> implements Projector<T, V> {
  const FieldValue(this.field, [this.getter]);

  final String field;
  final V Function(T)? getter;

  @override
  V project(T entity) {
    if (getter != null) {
      return getter!(entity);
    }
    if (entity is Serializable) {
      return entity.toJson()[field];
    }
    throw TypeNotSupportedException(
        'FieldValue projector does not support type ${entity.runtimeType}.');
  }
}

class UnaryExpression<T, P, V> implements Projector<T, V> {
  const UnaryExpression(this.operator, this.p);

  final UnaryOperator<P, V> operator;
  final Projector<T, P> p;

  @override
  V project(T entity) => operator.apply(p.project(entity));
}

class BinaryExpression<T, P, V> implements Projector<T, V> {
  const BinaryExpression(this.operator, this.p1, this.p2);

  final BinaryOperator<P, V> operator;
  final Projector<T, P> p1;
  final Projector<T, P> p2;

  @override
  V project(T entity) => operator.apply(p1.project(entity), p2.project(entity));
}
