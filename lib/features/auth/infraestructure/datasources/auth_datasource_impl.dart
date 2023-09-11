import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infrastructure.dart';

// patter adapter para envolver dio y si queremos posteriormente cambiarlo por otra clase

class AuthDatasourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try{
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });

      final user = UserMapper.userJsonToEntity(response.data); //mapper
      return user;

    } on DioException catch(e){
      if (e.response?.statusCode == 401 ) throw WrongCredentials();
      if (e.type == DioExceptionType.connectionTimeout ) throw ConnectionTimeout();
      throw CustomError('Something wrong happened', 1);
    }
    catch (e) {
        throw CustomError('Something wrong happened', 1);
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
