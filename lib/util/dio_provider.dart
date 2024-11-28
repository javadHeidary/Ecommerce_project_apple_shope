import 'package:dio/dio.dart';
import 'package:shop/util/auth_managment.dart';

class DioProvider {
  static Dio creatDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://startflutter.ir/api/',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Baere ${AuthManagment.readToken()}'
        },
      ),
    );
  }

  static Dio creatDioWithOutHeader() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://startflutter.ir/api/',
      ),
    );
  }
}
