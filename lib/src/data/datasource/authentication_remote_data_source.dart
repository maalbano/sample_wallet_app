import 'package:sample_wallet_app/src/comman/api.dart';
import 'package:sample_wallet_app/src/comman/constant.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> login(String email, String password);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  final Dio dio = Dio();

  @override
  Future<void> login(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(API.LOGIN, data: {
        'email': email,
        'password': password,
      });
      final token = response.data?['token'].toString() ?? '';
      await prefs.setString(ACCESS_TOKEN, token);
    } catch (e) {
      rethrow;
    }
  }
}
