import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('resolveStorageViewUrl returns non-storage URLs unchanged', () async {
    const external = 'https://example.com/file.pdf';
    expect(await resolveStorageViewUrl(external), external);
  });
}
