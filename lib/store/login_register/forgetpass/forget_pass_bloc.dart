import 'package:bloc/bloc.dart';

import 'forget_pass_event_state.dart';
import 'forget_pass_interactor.dart';

class ForgetPassBloc extends Bloc<ForgetPassEvent, ForgetPassState> {
  final ForgetPassInteractor _interactor;

  ForgetPassBloc(this._interactor);

  @override
  ForgetPassState get initialState => LoadingForgetPass();

  @override
  Stream<ForgetPassState> mapEventToState(ForgetPassEvent event) async* {
    if (event is AttemptPassChange) {
      yield LoadingForgetPass();
      ForgetPassResponse res = await _interactor.attemptPassChange(event.phone);
      if (res is ForgottenReqFailedResponse) {
        yield WaitingForPhone(prevErr: res.err);
      } else {
        yield WaitingForOtp();
      }
    } else if (event is AttemptOtpCheck) {
      yield LoadingForgetPass();
      var res = await _interactor.attemptOtp(event.otp, event.phone);
      if (res is OtpSuccessResponse) {
        yield (OtpSuccessful());
      } else if (res is ForgetPassFailedResponse) {
        if (res.error == ForgetPassError.OTP_INCORRECT) {
          yield (WaitingForOtp(err: "کد وارد شده صحیح نمی باشد"));
        }
      }
    } else if (event is SubmitNewPass) {
      yield LoadingForgetPass();
      var res = await _interactor.changePassword(event.phone, event.newPass);
      if (res is PassChangedSuccessResponse) {
        yield PasswordChanged();
      } else if (res is ForgottenReqFailedResponse) {

        yield ForgetPassFailed(msg: res.err);
      }
    } else if (event is ResetForgetPass) {
      yield WaitingForPhone();
    }
  }
}
