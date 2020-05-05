import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/login_register/login/user.dart';

import 'login_interactor.dart';

@immutable
abstract class LoginEvent extends BlocEvent {}

@immutable
abstract class LoginState extends BlocState {}

// STATES *******************************

class LoadingLoginAttempt extends LoginState {
  LoadingLoginAttempt();

  @override
  String toString() {
    return "STATE: loading login attempt";
  }
}

class LoginSuccessful extends LoginState {
  final User user;

  LoginSuccessful(this.user);

  @override
  String toString() {
    return " STATE: user is logged in : $user";
  }
}

class LoginFailed extends LoginState {
  final LoginError error;

  LoginFailed(this.error);

  @override
  String toString() {
    return "STATE: not logged in";
  }

  String getErrorText() {
    switch (error) {
      case LoginError.CREDENTIALS_MISMATCH:
        return 'نام کاربری یا کلمه عبور صحیح نمی‌باشد';
        break;
      case LoginError.NOT_LOGGED_IN:
        return '';
        break;
      case LoginError.UNKNOWN_ERROR:
        return 'خطا در ورود به حساب کاربری';
        break;
      default:
        return 'خطا در ورود به حساب کاربری';
    }
  }
}

class LogoutSuccessful extends LoginState {
/*
  final User user;
*/

  LogoutSuccessful(/*this.user*/);

  @override
  String toString() {
    return " STATE: user is logged out : ";
  }
}

// EVENTS *******************************

/*class IsLoggedIn extends LoginEvent {
  @override
  String toString() => "is logged in event";
}*/

class AttemptLogin extends LoginEvent {
  final String phoneNo;
  final String password;

  AttemptLogin(this.phoneNo, this.password);

  @override
  String toString() {
    return "attemp login event: username: $phoneNo, password: $password";
  }
}

class AttemptLastLogin extends LoginEvent {
  AttemptLastLogin();

  @override
  String toString() {
    return "attemp last login event";
  }
}

class Logout extends LoginEvent {
  Logout();

  @override
  String toString() {
    return "logout";
  }
}

class Reset extends LoginEvent {
  @override
  String toString() {
    return "logout";
  }

  Reset();
}
