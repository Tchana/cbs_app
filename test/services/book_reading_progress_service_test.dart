import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reading progress percentage follows current page over total pages', () {
    const currentPage = 7;
    const totalPages = 20;
    final progress = (currentPage / totalPages).clamp(0.0, 1.0);
    expect(progress, closeTo(0.35, 0.001));
    expect((progress * 100).round(), 35);
  });
}
