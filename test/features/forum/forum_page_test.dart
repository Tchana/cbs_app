import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/features/forum/forum_pages.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

class _FakeForumSupabaseService extends SupabaseService {
  const _FakeForumSupabaseService();

  @override
  Future<List<MessageData>> fetchMessages(String roomUuid) async {
    return const [
      MessageData(
        content: '',
        is_deleted: false,
        timestamp: '2026-01-01T08:00:00.000Z',
      ),
      MessageData(
        content: 'Latest visible message',
        is_deleted: false,
        timestamp: '2026-01-02T09:00:00.000Z',
      ),
    ];
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
  });

  testWidgets('Forum card shows latest visible message', (tester) async {
    final dc = Get.put(DataController());
    dc.setGroups(const [GroupData(uuid: 'room-1', name: 'Prayer room')]);

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('fr')],
        home: ForumPage(apiService: _FakeForumSupabaseService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Prayer room'), findsOneWidget);
    expect(find.text('Latest visible message'), findsOneWidget);
    expect(find.text('No message'), findsNothing);
  });
}
