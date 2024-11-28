import 'package:dartz/dartz.dart';
import 'package:shop/data/datasources/authentication_datasource.dart';
import 'package:shop/util/api_exception.dart';

abstract class IAuthenticationRepository {
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm);
  Future<Either<String, String>> login(String username, String password);
}

class AuthenticationRepository extends IAuthenticationRepository {
  final IAuthenticationDatasource _authenticationDatasource;
  AuthenticationRepository(this._authenticationDatasource);

  @override
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm) async {
    try {
      await _authenticationDatasource.register(
          username, password, passwordConfirm);
      return right('ثبت نام با موفقیت انجام شد');
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }

  @override
  Future<Either<String, String>> login(String username, String password) async {
    try {
      String token = await _authenticationDatasource.login(username, password);
      if (token.isNotEmpty) {
        return right(' وارد شدید');
      } else {
        return left('کابر با این مشخصات وجود ندارد');
      }
    } on ApiException catch (ex) {
      return left(ex.message ?? 'متنی برای خطا تعریف نشده');
    }
  }
}
