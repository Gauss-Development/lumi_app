import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class WatchLumiInboxChangesUseCase {
  const WatchLumiInboxChangesUseCase(this._repository);

  final LumiRepository _repository;

  Stream<void> call() {
    return _repository.watchInboxChanges();
  }
}
