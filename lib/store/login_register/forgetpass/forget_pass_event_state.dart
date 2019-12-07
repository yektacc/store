import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

@immutable
abstract class ForgetPassEvent extends BlocEvent {}

@immutable
abstract class ForgetPassState extends BlocState {}

// STATES *******************************

class WaitingForPhone extends ForgetPassState {
  String prevErr;

  WaitingForPhone({this.prevErr});
}

class LoadingForgetPass extends ForgetPassState {
  LoadingForgetPass();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class WaitingForOtp extends ForgetPassState {
  String err;

  WaitingForOtp({this.err});

  @override
  String toString() {
    return " STATE: initial state";
  }
}

class OtpSuccessful extends ForgetPassState {
  OtpSuccessful();

  @override
  String toString() {
    return "STATE: otp successful";
  }
}

class PasswordChanged extends ForgetPassState {
  PasswordChanged();

  @override
  String toString() {
    return "STATE: password change successful";
  }
}

class ForgetPassFailed extends ForgetPassState {
  final String msg;

  ForgetPassFailed({this.msg = ''});
}

// EVENTS **********

class AttemptPassChange extends ForgetPassEvent {
  final String phone;

  AttemptPassChange(this.phone);

  @override
  String toString() {
    return "attempt pass change";
  }
}

class AttemptOtpCheck extends ForgetPassEvent {
  final String otp;
  final String phone;

  AttemptOtpCheck(this.otp, this.phone);

  @override
  String toString() {
    return "otp check: $otp";
  }
}

class SubmitNewPass extends ForgetPassEvent {
  final String newPass;
  final String phone;

  SubmitNewPass(this.newPass, this.phone);

  @override
  String toString() {
    return "new pass : $newPass";
  }
}

class ResetForgetPass extends ForgetPassEvent {}
