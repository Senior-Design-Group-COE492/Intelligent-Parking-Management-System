import 'package:dio/dio.dart';
import 'package:parking_app/globals/Globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHandler {
  final String email, password;
  Dio dio;
  Response response;

  BaseOptions options = new BaseOptions(
    baseUrl: "http://" + Globals.IP_ADDRESS + ':' + Globals.PORT,
    connectTimeout: 15000,
    receiveTimeout: 15000,
    contentType: Headers.formUrlEncodedContentType,
  );

  LoginHandler(this.email, this.password) {
    dio = new Dio(options);
  }
  static Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<Map<String, dynamic>> authUser() async {
    // authorizes the user
    try {
      response = await dio.post("/login", data: {
        "email": email,
        "password": password,
      });
      return response.data;
    } on DioError catch (e) {
      print(e.runtimeType);
      if (e.response == null) {
        return {
          'status': '-1',
          'message':
              'Something went wrong. Please make sure you are connected to the internet.',
        };
      }
      if (e.response.statusCode == 401 || e.response.statusCode == 400) {
        // validation errors
        return e.response.data;
      } else {
        // Error when sending the request
        return {
          'status': '-1',
          'message': 'Something went wrong, try again later',
        };
      }
    }
  }

  void saveTime() async {
    String now = DateTime.now().toString();
    print(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginTime', now);
  }

  void saveUserInfo(String email, String jwt) async {
    print(email);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('jwt', jwt);
  }
}
