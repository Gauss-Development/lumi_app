import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/core/services/revenuecat_service.dart';
import 'package:lumi/features/subscription/data/datasources/subscription_local_data_source.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  SubscriptionRepositoryImpl({
    required SubscriptionLocalDataSource localDataSource,
    required RevenueCatService revenueCatService,
  }) : _localDataSource = localDataSource,
       _revenueCatService = revenueCatService;

  final SubscriptionLocalDataSource _localDataSource;
  final RevenueCatService _revenueCatService;

  @override
  Future<Either<Failure, List<PaywallPlan>>> fetchPaywallPlans() async {
    try {
      final offerings = await _revenueCatService.getOfferings();
      final current = offerings?.current;
      if (current != null && current.availablePackages.isNotEmpty) {
        final plans = current.availablePackages
            .map(
              (package) => PaywallPlan(
                id: package.identifier,
                title: package.storeProduct.title,
                priceLabel: package.storeProduct.priceString,
                description: package.storeProduct.description,
                isAnnual: package.packageType.name.toLowerCase().contains(
                  'annual',
                ),
              ),
            )
            .toList(growable: false);
        return Right(plans);
      }

      return Right(_localDataSource.defaultPlans());
    } catch (_) {
      return const Left(ServerFailure('Unable to load paywall plans.'));
    }
  }

  @override
  Future<Either<Failure, EntitlementStatus>> getEntitlementStatus() async {
    try {
      final customerInfo = await _revenueCatService.getCustomerInfo();
      if (customerInfo == null) {
        return Right(await _localDataSource.getStatus());
      }

      final status = _statusFromCustomerInfo(customerInfo);
      await _localDataSource.saveStatus(status);
      return Right(status);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to load subscription status.'),
      );
    }
  }

  @override
  Future<Either<Failure, EntitlementStatus>> purchasePlan(String planId) async {
    try {
      final offerings = await _revenueCatService.getOfferings();
      final current = offerings?.current;
      if (current == null || current.availablePackages.isEmpty) {
        return const Left(ServerFailure('Plan unavailable.'));
      }

      final package = current.availablePackages.firstWhere(
        (Package p) => p.identifier == planId,
        orElse: () => current.availablePackages.first,
      );

      final customerInfo = await _revenueCatService.purchasePackage(package);
      if (customerInfo == null) {
        return const Left(ServerFailure('Unable to complete purchase.'));
      }

      final status = _statusFromCustomerInfo(customerInfo);
      await _localDataSource.saveStatus(status);
      return Right(status);
    } on PlatformException catch (e) {
      if (PurchasesErrorHelper.getErrorCode(e) ==
          PurchasesErrorCode.purchaseCancelledError) {
        return const Left(ServerFailure('Purchase cancelled.'));
      }
      return const Left(ServerFailure('Unable to complete purchase.'));
    } catch (_) {
      return const Left(ServerFailure('Unable to complete purchase.'));
    }
  }

  @override
  Future<Either<Failure, EntitlementStatus>> restorePurchases() async {
    try {
      final customerInfo = await _revenueCatService.restorePurchases();
      if (customerInfo == null) {
        return Right(await _localDataSource.getStatus());
      }

      final status = _statusFromCustomerInfo(customerInfo);
      await _localDataSource.saveStatus(status);
      return Right(status);
    } catch (_) {
      return const Left(ServerFailure('Unable to restore purchases.'));
    }
  }

  EntitlementStatus _statusFromCustomerInfo(CustomerInfo info) {
    final entitlement =
        info.entitlements.active[RevenueCatService.lumiPlusEntitlementId];
    if (entitlement == null) {
      return const EntitlementStatus.free();
    }
    final productId = entitlement.productIdentifier.toLowerCase();
    final plan = productId.contains('annual') || productId.contains('year')
        ? HouseholdPlan.yearly
        : HouseholdPlan.monthly;
    return EntitlementStatus.household(plan: plan);
  }
}
