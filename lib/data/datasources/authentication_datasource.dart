import 'package:dio/dio.dart';
import 'package:shop/util/api_exception.dart';
import 'package:shop/util/auth_managment.dart';
import 'package:shop/util/dio_provider.dart';

abstract class IAuthenticationDatasource {
  Future<void> register(
      String username, String password, String passwordConfirm);
  Future<String> login(String username, String password);
}

class AuthenticationRemote extends IAuthenticationDatasource {
  final Dio _dio = DioProvider.creatDioWithOutHeader();
  AuthenticationRemote();
  @override
  Future<void> register(
      String username, String password, String passwordConfirm) async {
    try {
      Response response = await _dio.post(
        'collections/users/records',
        data: {
          'username': username,
          'name': username,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );
      if (response.statusCode == 200) {
        await login(username, password);
      }
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode,
          response: ex.response);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        'collections/users/auth-with-password',
        data: {
          'identity': username,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        AuthManagment.saveUserId(
          response.data['record']['id'],
        );
        AuthManagment.saveToken(
          response.data['token'],
        );

        return response.data['token'];
      }
    } on DioException catch (ex) {
      throw ApiException(ex.response?.data['message'], ex.response?.statusCode);
    } catch (ex) {
      throw ApiException('unknown exception', 0);
    }
    return '';
  }
}
