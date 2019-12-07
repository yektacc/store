import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/login_register/login/user.dart';

@immutable
abstract class LoginStatusEvent extends BlocEvent {}

@immutable
abstract class LoginStatusState extends BlocState {}

// STATES *******************************

class StatusLoading extends LoginStatusState {
  StatusLoading();

  @override
  String toString() {
    return "STATE: loading login status";
  }
}

class NotLoggedIn extends LoginStatusState {
/*
  final LoginStatus status = NotLoggedInStatus();
*/

  NotLoggedIn();

  @override
  String toString() {
    return " STATE: user isn't logged in";
  }
}

class IsLoggedIn extends LoginStatusState {
  final User user;

  IsLoggedIn(this.user);

  @override
  String toString() {
    return " STATE: user is logged in : $user";
  }
}

// EVENTS *******************************

class UpdateStatus extends LoginStatusEvent {
  final LoginStatus status;

  UpdateStatus(this.status);

  @override
  String toString() => "update status event: $status";
}

// login status

@immutable
abstract class LoginStatus extends Equatable {
  bool isLoggedIn();
}

class LoggedInStatus extends LoginStatus {
  final User user;

  LoggedInStatus(this.user);

  @override
  bool isLoggedIn() {
    return true;
  }
}

class NotLoggedInStatus extends LoginStatus {
  NotLoggedInStatus();

  @override
  bool isLoggedIn() {
    return false;
  }
}
