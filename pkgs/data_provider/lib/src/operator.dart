import 'package:data_provider/data_provider.dart';

abstract class UnaryOperator<P, V> {
  V apply(P a);
}

abstract class BinaryOperator<P, V> {
  V apply(P a, P b);
}

abstract class ComparisonOperator<P> implements BinaryOperator<P, bool> {}

class Equals<P> implements ComparisonOperator<P> {
  @override
  bool apply(P a, P b) {
    return a == b;
  }

  @override
  String toString() => '=';
}

class Less<P> implements ComparisonOperator<P> {
  @override
  bool apply(P a, P b) {
    if (a == null || b == null) {
      return false;
    }
    if (a is num && b is num) {
      return a < b;
    }
    if (a is String && b is String) {
      return a.compareTo(b) < 0;
    }
    throw TypeNotSupportedException(
        'Less operator does not support type ${a.runtimeType}.');
  }

  @override
  String toString() => '<';
}

class LessOrEquals<P> implements ComparisonOperator<P> {
  @override
  bool apply(P a, P b) {
    if (a == null || b == null) {
      return false;
    }
    if (a is num && b is num) {
      return a <= b;
    }
    if (a is String && b is String) {
      return a.compareTo(b) <= 0;
    }
    throw TypeNotSupportedException(
        'LessOrEquals operator does not support type ${a.runtimeType}.');
  }

  @override
  String toString() => '<=';
}

class Greater<P> implements ComparisonOperator<P> {
  @override
  bool apply(P a, P b) {
    if (a == null || b == null) {
      return false;
    }
    if (a is num && b is num) {
      return a > b;
    }
    if (a is String && b is String) {
      return a.compareTo(b) > 0;
    }
    throw TypeNotSupportedException(
        'Greater operator does not support type ${a.runtimeType}.');
  }

  @override
  String toString() => '>';
}

class GreaterOrEquals<P> implements ComparisonOperator<P> {
  @override
  bool apply(P a, P b) {
    if (a == null || b == null) {
      return false;
    }
    if (a is num && b is num) {
      return a >= b;
    }
    if (a is String && b is String) {
      return a.compareTo(b) >= 0;
    }
    throw TypeNotSupportedException(
        'GreaterOrEquals operator does not support type ${a.runtimeType}.');
  }

  @override
  String toString() => '>=';
}

abstract class ArithmeticOperator<P extends num>
    implements BinaryOperator<P, P> {}

class Plus<P extends num> implements ArithmeticOperator<P> {
  @override
  P apply(P a, P b) => (a + b) as P;
}

class Minus<P extends num> implements ArithmeticOperator<P> {
  @override
  P apply(P a, P b) => (a - b) as P;
}

class Multiply<P extends num> implements ArithmeticOperator<P> {
  @override
  P apply(P a, P b) => (a * b) as P;
}

class Divide implements ArithmeticOperator<double> {
  @override
  double apply(double a, double b) => a / b;
}

class IntDivide implements ArithmeticOperator<int> {
  @override
  int apply(int a, int b) => a ~/ b;
}

class Modulo<P extends num> implements ArithmeticOperator<P> {
  @override
  P apply(P a, P b) => (a % b) as P;
}

class UnaryMinus<P extends num> implements UnaryOperator<P, P> {
  @override
  P apply(P a) => -a as P;
}

class Concat implements BinaryOperator<String, String> {
  @override
  String apply(String a, String b) => a + b;
}

class Substring implements UnaryOperator<String, String> {
  const Substring(this.start, [this.end]);

  final int start;
  final int? end;

  @override
  String apply(String a) {
    final cropped_start = start < a.length ? start : a.length;
    final cropped_end = (end != null && end! < a.length) ? end : a.length;
    return a.substring(cropped_start, cropped_end);
  }
}
