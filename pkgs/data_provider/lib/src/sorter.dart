import 'package:data_provider/data_provider.dart';

abstract class Sorter<T> {
  int compare(T a, T b);

  static int compareValues(a, b, [isAsc = true]) {
    final sign = isAsc ? 1 : -1;
    if (a is String && b is String) {
      return sign * a.compareTo(b);
    }
    if (a is num && b is num) {
      return sign * a.compareTo(b);
    }
    if (a is bool && b is bool) {
      return sign * (a ? 1 : 0).compareTo(b ? 1 : 0);
    }
    throw TypeNotSupportedException(
      'Sorter does not support value types ${a.runtimeType}, ${b.runtimeType}.',
    );
  }
}

class ValueSorter<T> implements Sorter<T> {
  const ValueSorter(this.projector, [this.isAsc = true]);

  final Projector<T, Object?> projector;
  final bool isAsc;

  @override
  int compare(T a, T b) =>
      Sorter.compareValues(projector.project(a), projector.project(b), isAsc);
}

class CompositeSorter<T> implements Sorter<T> {
  const CompositeSorter(this.children);

  final List<Sorter<T>> children;

  @override
  int compare(T a, T b) {
    for (final child in children) {
      final result = child.compare(a, b);
      if (result != 0) {
        return result;
      }
    }
    return 0;
  }
}

abstract class CustomSorter<T> implements Sorter<T> {
  const CustomSorter();

  @override
  int compare(T a, T b) {
    return normalize().compare(a, b);
  }

  Sorter<T> normalize();
}

class FieldSorter<T> extends CustomSorter<T> {
  FieldSorter(Map<String, bool> fields) {
    final children = <Sorter<T>>[];
    for (final field in fields.keys) {
      children
          .add(ValueSorter<T>(FieldValue<T, Object?>(field), fields[field]!));
    }
    normalized = CompositeSorter(children);
  }

  late final Sorter<T> normalized;

  @override
  Sorter<T> normalize() {
    return normalized;
  }
}
