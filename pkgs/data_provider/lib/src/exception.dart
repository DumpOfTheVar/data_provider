
class DataProviderException implements Exception {
  DataProviderException([this.message = '']);

  final String message;

  @override
  String toString() {
    return message;
  }
}

class TypeNotSupportedException extends DataProviderException {
  TypeNotSupportedException([super.message = '']);
}