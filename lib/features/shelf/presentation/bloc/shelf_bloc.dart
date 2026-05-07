import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/domain/usecases/get_kept_lumis_usecase.dart';
import 'package:lumi/features/shelf/domain/usecases/remove_kept_lumi_usecase.dart';
import 'package:lumi/features/shelf/domain/usecases/save_kept_lumi_usecase.dart';

part 'shelf_bloc.freezed.dart';

class ShelfBloc extends Bloc<ShelfEvent, ShelfState> {
  ShelfBloc({
    required GetKeptLumisUseCase getKeptLumis,
    required SaveKeptLumiUseCase saveKeptLumi,
    required RemoveKeptLumiUseCase removeKeptLumi,
  }) : _getKeptLumis = getKeptLumis,
       _saveKeptLumi = saveKeptLumi,
       _removeKeptLumi = removeKeptLumi,
       super(const ShelfState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_SaveRequested>(_onSaveRequested);
    on<_RemoveRequested>(_onRemoveRequested);
  }

  final GetKeptLumisUseCase _getKeptLumis;
  final SaveKeptLumiUseCase _saveKeptLumi;
  final RemoveKeptLumiUseCase _removeKeptLumi;

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<ShelfState> emit,
  ) async {
    emit(const ShelfState.loading(items: <KeptLumi>[]));
    final result = await _getKeptLumis();
    result.fold(
      (failure) => emit(
        ShelfState.failure(items: const <KeptLumi>[], message: failure.message),
      ),
      (items) => emit(ShelfState.loaded(items: items)),
    );
  }

  Future<void> _onSaveRequested(
    _SaveRequested event,
    Emitter<ShelfState> emit,
  ) async {
    final result = await _saveKeptLumi(event.keptLumi);
    result.fold(
      (failure) => emit(
        ShelfState.failure(items: state.items, message: failure.message),
      ),
      (items) => emit(ShelfState.loaded(items: items)),
    );
  }

  Future<void> _onRemoveRequested(
    _RemoveRequested event,
    Emitter<ShelfState> emit,
  ) async {
    final result = await _removeKeptLumi(event.id);
    result.fold(
      (failure) => emit(
        ShelfState.failure(items: state.items, message: failure.message),
      ),
      (items) => emit(ShelfState.loaded(items: items)),
    );
  }
}

@freezed
sealed class ShelfEvent with _$ShelfEvent {
  const factory ShelfEvent.loadRequested() = _LoadRequested;
  const factory ShelfEvent.saveRequested(KeptLumi keptLumi) = _SaveRequested;
  const factory ShelfEvent.removeRequested(String id) = _RemoveRequested;
}

@freezed
sealed class ShelfState with _$ShelfState {
  const ShelfState._();

  const factory ShelfState.initial({
    @Default(<KeptLumi>[]) List<KeptLumi> items,
  }) = _Initial;
  const factory ShelfState.loading({required List<KeptLumi> items}) = _Loading;
  const factory ShelfState.loaded({required List<KeptLumi> items}) = _Loaded;
  const factory ShelfState.failure({
    required List<KeptLumi> items,
    required String message,
  }) = _Failure;
}
