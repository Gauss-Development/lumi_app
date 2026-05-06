import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  T foldMap<T>({
    required T Function(L left) onLeft,
    required T Function(R right) onRight,
  }) {
    return fold(onLeft, onRight);
  }
}
