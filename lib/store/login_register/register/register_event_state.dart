import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/store/login_register/register/register_interactor.dart';

@immutable
abstract class RegisterEvent extends BlocEvent {}

@immutable
abstract class RegisterState extends BlocState {}

// STATES *******************************

class LoadingRegister extends RegisterState {
  LoadingRegister();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class InfoSubmission extends RegisterState {
  RegisterError currentError;

  InfoSubmission({this.currentError});

  @override
  String toString() {
    return " STATE: initial state";
  }
}

class OtpSubmission extends RegisterState {
  RegisterError currentError;
  final String otp;

  OtpSubmission({this.currentError, this.otp});

  @override
  String toString() {
    return "STATE: failed";
  }
}

class RegisterFailed extends RegisterState {
  final RegisterError error;

  RegisterFailed(this.error);

  @override
  String toString() {
    return "STATE: failed : $error";
  }
}

class RegisterSuccessful extends RegisterState {
  final String phone;
  final String pass;

  RegisterSuccessful(this.phone, this.pass);

  @override
  String toString() {
    return "STATE: successful";
  }
}

// EVENTS *******************************
class AttemptRegister extends RegisterEvent {
  final String phoneNo;
  final String password;

  AttemptRegister(this.phoneNo, this.password);

  @override
  String toString() {
    return "attemp register event: username: $phoneNo, password: $password";
  }
}

class AttemptOtpCheck extends RegisterEvent {
  final String otp;
  final String phone;
  final String pass;

  AttemptOtpCheck(this.otp, this.phone, this.pass);

  @override
  String toString() {
    return "otp check: $otp";
  }
}

class ResetRegister extends RegisterEvent {
  @override
  String toString() {
    return "reset register form";
  }
}
