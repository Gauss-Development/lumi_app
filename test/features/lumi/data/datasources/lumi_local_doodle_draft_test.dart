import 'package:flutter_test/flutter_test.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/lumi/data/datasources/lumi_local_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockCircleRemoteDataSource extends Mock
    implements CircleRemoteDataSource {}

void main() {
  late LumiLocalDataSource dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    dataSource = LumiLocalDataSource(
      PreferencesService(prefs),
      _MockCircleRemoteDataSource(),
    );
  });

  test('save and load doodle draft round trip', () async {
    const DoodleStroke stroke = DoodleStroke(<DoodlePoint>[
      DoodlePoint(dx: 0.1, dy: 0.2),
      DoodlePoint(dx: 0.5, dy: 0.7),
    ]);

    await dataSource.saveDoodleDraft(stroke);
    final DoodleStroke? loaded = await dataSource.loadDoodleDraft();

    expect(loaded, isNotNull);
    expect(loaded!.points.length, 2);
    expect(loaded.points.first.dx, 0.1);
  });

  test('clear doodle draft removes saved stroke', () async {
    await dataSource.saveDoodleDraft(
      const DoodleStroke(<DoodlePoint>[DoodlePoint(dx: 0.2, dy: 0.3)]),
    );
    await dataSource.clearDoodleDraft();
    expect(await dataSource.loadDoodleDraft(), isNull);
  });
}
