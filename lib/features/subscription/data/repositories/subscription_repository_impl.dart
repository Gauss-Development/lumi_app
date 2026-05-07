import 'package:dartz/dartz.dart';

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
      if (offerings?.current != null &&
          offerings!.current!.availablePackages.isNotEmpty) {
        final plans = offerings.current!.availablePackages
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
      return Right(await _localDataSource.getStatus());
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to load subscription status.'),
      );
    }
  }

  @override
  Future<Either<Failure, EntitlementStatus>> purchasePlan(String planId) async {
    try {
      return Right(await _localDataSource.purchase(planId));
    } catch (_) {
      return const Left(ServerFailure('Unable to complete purchase.'));
    }
  }

  @override
  Future<Either<Failure, EntitlementStatus>> restorePurchases() async {
    try {
      await _revenueCatService.restorePurchases();
      return Right(await _localDataSource.restore());
    } catch (_) {
      return const Left(ServerFailure('Unable to restore purchases.'));
    }
  }
}
