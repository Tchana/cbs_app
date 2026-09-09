import 'package:center_for_biblical_studies/models/app_update_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppVersion compares semver and build numbers', () {
    expect(AppVersion.parse('1.0.1').isNewerThan(AppVersion.parse('1.0.0')), isTrue);
    expect(AppVersion.parse('1.0.0+2').isNewerThan(AppVersion.parse('1.0.0+1')), isTrue);
    expect(AppVersion.parse('1.0.0').isNewerThan(AppVersion.parse('1.0.0')), isFalse);
  });

  test('AppUpdateInfo resolves platform asset', () {
    final info = AppUpdateInfo.fromJson({
      'version': '1.0.1',
      'build_number': 2,
      'force_update': false,
      'assets': {'android': 'android.apk', 'windows': 'windows-setup.exe'},
    }, 'android');
    expect(info.downloadUrl, 'android.apk');
    expect(info.displayVersion, '1.0.1 (2)');
  });
}
