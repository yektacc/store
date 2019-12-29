import 'package:equatable/equatable.dart';
import 'package:get_ip/get_ip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/store/login_register/login/user.dart';

class LoginResponse extends Equatable {}

class LoginSuccessfulResponse extends LoginResponse {
  final User user;

  LoginSuccessfulResponse(this.user);
}

enum LoginError {
  CREDENTIALS_MISMATCH,
  NOT_LOGGED_IN,
/*
  LAST_LOGIN_NOT_AVAILABLE,
*/
  UNKNOWN_ERROR
}

class LoginFailedResponse extends LoginResponse {
  final LoginError error;

  LoginFailedResponse(this.error);
}

class LoginInteractor {
  final Net net;

  LoginInteractor(this.net);

  Future<LoginResponse> attempLastLogin() async {
    User user = await _readUser();
    if (user == null) {
      return LoginFailedResponse(LoginError.NOT_LOGGED_IN);
    } else {
      return attemptLogin(user.phoneNo, user.password);
    }
  }

  Future<LoginResponse> attemptLogin(String phoneNo, String password) async {
    var ip = await GetIp.ipAddress;
    var response = await net.post(EndPoint.LOG_IN,
        body: {'mobile_number': phoneNo, 'password': password, 'client_ip': ip},
        cacheEnabled: false);

    if (response is SuccessResponse) {
      var loginData = response.data;
      print(loginData);

      if (loginData["response_code"].toString() != null) {
        int responseCode = int.parse(loginData["response_code"].toString());
        print("res int: " + responseCode.toString());

        if (responseCode == 0) {
          var _user =
          User(phoneNo, password, loginData["session_id"].toString());
          await _saveUser(_user);
          return LoginSuccessfulResponse(_user);
        } else if (responseCode == 3) {
          return LoginFailedResponse(LoginError.CREDENTIALS_MISMATCH);
        } else {
          return LoginFailedResponse(LoginError.UNKNOWN_ERROR);
        }
      } else {
        return LoginFailedResponse(LoginError.UNKNOWN_ERROR);
      }
    } else {
      return LoginFailedResponse(LoginError.UNKNOWN_ERROR);
    }
  }

  Future<bool> logout() async {
    await _removeUser();
    return true;
  }

  final key1 = 'phone';
  final key2 = 'password';
  final key3 = 'session';

  Future<User> _readUser() async {
    final prefs = await SharedPreferences.getInstance();
    print("read shared pref");
    final user = User(
      prefs.getString(key1) ?? "err",
      prefs.getString(key2) ?? "err",
      prefs.getString(key3) ?? "err",
    );
    if (user.phoneNo == "err" ||
        user.password == "err" ||
        user.sessionId == "err") {
      return null;
    }
    return user;
  }

  _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key1, user.phoneNo);
    prefs.setString(key2, user.password);
    prefs.setString(key3, user.sessionId);
    print(
        'saved  phone: ${user.phoneNo}  pass: ${user.password} session id: ${user.sessionId}');
  }

  _removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key1);
    prefs.remove(key2);
    prefs.remove(key3);
  }
}
