import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();
  String? _accessToken;
  String? _username;
  String? _password;

  ApiService() {
    _dio.options.baseUrl =
        'http://localhost:3000'; // Cambia esto a la URL de tu API
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        if (e.response?.statusCode == 401 &&
            _username != null &&
            _password != null) {
          try {
            await _refreshToken();
            _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
            final opts = Options(
              method: e.requestOptions.method,
              headers: e.requestOptions.headers,
            );
            final cloneReq = await _dio.request(e.requestOptions.path,
                options: opts,
                data: e.requestOptions.data,
                queryParameters: e.requestOptions.queryParameters);
            return handler.resolve(cloneReq);
          } catch (error) {
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
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
      _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
    } catch (e) {
      print('Error during login: $e');
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
    print('User logged out and credentials cleared.');
  }

  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _dio.get('/user');
      return response.data;
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to fetch users');
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await _dio.get('/user/$id');
      return response.data;
    } catch (e) {
      print('Error fetching user: $e');
      throw Exception('Failed to fetch user');
    }
  }

  Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      await _dio.post('/user', data: userData);
    } catch (e) {
      print('Error creating user: $e');
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      await _dio.put('/user/$id', data: userData);
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/user/$id');
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }
}
