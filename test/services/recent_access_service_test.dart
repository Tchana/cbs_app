import 'package:center_for_biblical_studies/services/recent_access_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('keeps at most 5 recent items across courses and books', () async {
    for (var i = 1; i <= 6; i++) {
      await RecentAccessService.markCourseAccessed('c$i');
    }
    await RecentAccessService.markBookAccessed('b1');

    final entries = await RecentAccessService.getRecentEntries();
    expect(entries.length, 5);
    expect(entries.first.kind, RecentAccessKind.book);
    expect(entries.first.id, 'b1');
  });

  test('orders by most recently accessed', () async {
    await RecentAccessService.markCourseAccessed('c1');
    await RecentAccessService.markBookAccessed('b1');
    await RecentAccessService.markCourseAccessed('c2');

    final entries = await RecentAccessService.getRecentEntries();
    expect(entries.map((e) => e.id).toList(), ['c2', 'b1', 'c1']);
  });
}
