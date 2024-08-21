import 'package:dio/dio.dart';
import 'package:test/services/api/models/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  final Dio _dio = Dio();
  String? _accessToken;
  String? _username;
  String? _password;

  ApiService._internal() {
    _dio.options.baseUrl =
        'https://basic-api-challege-2bcb8cd31390.herokuapp.com';
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        return handler.next(options);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401 &&
            _username != null &&
            _password != null) {
          try {
            await _refreshToken();
            e.requestOptions.headers['Authorization'] = 'Bearer $_accessToken';
            final cloneReq = await _dio.request(
              e.requestOptions.path,
              options: Options(
                method: e.requestOptions.method,
                headers: e.requestOptions.headers,
              ),
              data: e.requestOptions.data,
              queryParameters: e.requestOptions.queryParameters,
            );
            return handler.resolve(cloneReq);
          } catch (error) {
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ));

    // Añadir el interceptor de logging
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      logPrint: (obj) => print(obj),
    ));
  }

  Future<void> login(String username, String password) async {
    _username = username;
    _password = password;

    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      _accessToken = response.data['access_token'];
    } catch (e) {
      throw Exception('Failed to login');
    }
  }

  Future<void> _refreshToken() async {
    if (_username != null && _password != null) {
      await login(_username!, _password!);
    }
  }

  Future<void> logout() async {
    _accessToken = null;
    _username = null;
    _password = null;
    _dio.options.headers.remove('Authorization');
  }

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/user');
      return (response.data as List)
          .map((user) => User.fromJson(user))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }

  Future<User> getUserById(int id) async {
    try {
      final response = await _dio.get('/user/$id');
      return User.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch user');
    }
  }

  Future<void> createUser(CreateUserInput userData) async {
    try {
      await _dio.post('/user', data: userData.toJson());
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(int id, UpdateUserInput userData) async {
    try {
      await _dio.put('/user/$id', data: userData.toJson());
    } catch (e) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/user/$id');
    } catch (e) {
      throw Exception('Failed to delete user');
    }
  }
}
