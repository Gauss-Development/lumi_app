import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/usecases/clear_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/get_recent_lumis_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/mark_lumi_seen_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/react_to_lumi_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/save_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/send_lumi_usecase.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';

class _MockGetRecentLumisUseCase extends Mock
    implements GetRecentLumisUseCase {}

class _MockSendLumiUseCase extends Mock implements SendLumiUseCase {}

class _MockReactToLumiUseCase extends Mock implements ReactToLumiUseCase {}

class _MockMarkLumiSeenUseCase extends Mock implements MarkLumiSeenUseCase {}

class _MockSaveDoodleDraftUseCase extends Mock
    implements SaveDoodleDraftUseCase {}

class _MockClearDoodleDraftUseCase extends Mock
    implements ClearDoodleDraftUseCase {}

void main() {
  late _MockGetRecentLumisUseCase getRecentLumisUseCase;
  late LumiBloc bloc;

  final Lumi incoming = Lumi(
    id: 'lumi-1',
    senderId: 'user-a',
    memberId: 'member-b-to-a',
    isIncoming: true,
    type: LumiType.light,
    colorValue: 0xFFFFAA00,
    createdAt: DateTime.utc(2026, 6, 1),
    intensity: 0.8,
    deliveryStatus: LumiDeliveryStatus.delivered,
  );

  setUp(() {
    getRecentLumisUseCase = _MockGetRecentLumisUseCase();
    bloc = LumiBloc(
      getRecentLumisUseCase: getRecentLumisUseCase,
      sendLumiUseCase: _MockSendLumiUseCase(),
      reactToLumiUseCase: _MockReactToLumiUseCase(),
      markLumiSeenUseCase: _MockMarkLumiSeenUseCase(),
      saveDoodleDraftUseCase: _MockSaveDoodleDraftUseCase(),
      clearDoodleDraftUseCase: _MockClearDoodleDraftUseCase(),
    );
  });

  tearDown(() => bloc.close());

  blocTest<LumiBloc, LumiState>(
    'watchRecent always loads the full inbox even when memberId is set',
    build: () {
      when(() => getRecentLumisUseCase(memberId: any(named: 'memberId')))
          .thenAnswer((_) async => Right(<Lumi>[incoming]));
      return bloc;
    },
    act: (LumiBloc bloc) => bloc.add(
      const LumiEvent.watchRecent(memberId: 'member-a-to-b'),
    ),
    expect: () => <LumiState>[
      const LumiState.loading(
        selectedMemberId: 'member-a-to-b',
        recentLumis: <Lumi>[],
      ),
      LumiState.loaded(
        selectedMemberId: 'member-a-to-b',
        recentLumis: <Lumi>[incoming],
      ),
    ],
    verify: (_) {
      verify(() => getRecentLumisUseCase()).called(1);
    },
  );
}
