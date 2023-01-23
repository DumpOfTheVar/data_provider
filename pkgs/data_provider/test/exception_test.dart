import 'package:data_provider/data_provider.dart';
import 'package:test/test.dart';

void main() {
  group('data provider exception', () {
    test('type', () {
      final exception = DataProviderException();
      expect(exception, isException);
    });

    test('toString', () {
      expect(DataProviderException().toString(), '');
      expect(DataProviderException('Test').toString(), 'Test');
      expect(DataProviderException('Test_123').toString(), 'Test_123');
    });
  });

  group('type not supported exception', () {
    test('type', () {
      final exception = TypeNotSupportedException();
      expect(exception, isException);
    });

    test('toString', () {
      expect(TypeNotSupportedException().toString(), '');
      expect(TypeNotSupportedException('Test').toString(), 'Test');
      expect(TypeNotSupportedException('Test_123').toString(), 'Test_123');
    });
  });
}
