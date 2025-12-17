/// Base use case cho domain layer
/// Tất cả use cases nên extend class này
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// No params use case
class NoParams {
  const NoParams();
}
