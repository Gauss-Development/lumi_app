import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/usecases/fetch_paywall_plans_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/get_entitlement_status_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/purchase_plan_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/restore_purchases_usecase.dart';

part 'subscription_bloc.freezed.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc({
    required GetEntitlementStatusUseCase getEntitlementStatusUseCase,
    required FetchPaywallPlansUseCase fetchPaywallPlansUseCase,
    required PurchasePlanUseCase purchasePlanUseCase,
    required RestorePurchasesUseCase restorePurchasesUseCase,
  }) : _getEntitlementStatusUseCase = getEntitlementStatusUseCase,
       _fetchPaywallPlansUseCase = fetchPaywallPlansUseCase,
       _purchasePlanUseCase = purchasePlanUseCase,
       _restorePurchasesUseCase = restorePurchasesUseCase,
       super(const SubscriptionState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_PurchaseRequested>(_onPurchaseRequested);
    on<_RestoreRequested>(_onRestoreRequested);
  }

  final GetEntitlementStatusUseCase _getEntitlementStatusUseCase;
  final FetchPaywallPlansUseCase _fetchPaywallPlansUseCase;
  final PurchasePlanUseCase _purchasePlanUseCase;
  final RestorePurchasesUseCase _restorePurchasesUseCase;

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionState.loading());

    final statusResult = await _getEntitlementStatusUseCase();
    final plansResult = await _fetchPaywallPlansUseCase();

    statusResult.fold(
      (failure) => emit(SubscriptionState.failure(failure.message)),
      (status) => plansResult.fold(
        (failure) => emit(SubscriptionState.failure(failure.message)),
        (plans) => emit(SubscriptionState.loaded(status: status, plans: plans)),
      ),
    );
  }

  Future<void> _onPurchaseRequested(
    _PurchaseRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _purchasePlanUseCase(event.planId);
    result.fold(
      (failure) => emit(SubscriptionState.failure(failure.message)),
      (_) => add(const SubscriptionEvent.loadRequested()),
    );
  }

  Future<void> _onRestoreRequested(
    _RestoreRequested event,
    Emitter<SubscriptionState> emit,
  ) async {
    final result = await _restorePurchasesUseCase();
    result.fold(
      (failure) => emit(SubscriptionState.failure(failure.message)),
      (_) => add(const SubscriptionEvent.loadRequested()),
    );
  }
}

@freezed
class SubscriptionEvent with _$SubscriptionEvent {
  const factory SubscriptionEvent.loadRequested() = _LoadRequested;
  const factory SubscriptionEvent.purchaseRequested(String planId) =
      _PurchaseRequested;
  const factory SubscriptionEvent.restoreRequested() = _RestoreRequested;
}

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState.initial() = _Initial;
  const factory SubscriptionState.loading() = _Loading;
  const factory SubscriptionState.loaded({
    required EntitlementStatus status,
    required List<PaywallPlan> plans,
  }) = _Loaded;
  const factory SubscriptionState.failure(String message) = _Failure;
}
