import 'package:bloc/bloc.dart';
import 'package:store/store/login_register/register/register_event_state.dart';
import 'package:store/store/login_register/register/register_interactor.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterInteractor _interactor;

  RegisterBloc(this._interactor);

  @override
  RegisterState get initialState => InfoSubmission();

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is AttemptRegister) {
      yield (LoadingRegister());
      var res =
          await _interactor.attemptRegister(event.phoneNo, event.password);

      if (res is InfoSuccessResponse) {
        yield (OtpSubmission());
      } else if (res is RegisterFailedResponse) {
        if (res.error == RegisterError.PHONE_NUMBER_EXISTS) {
          yield (InfoSubmission(
              currentError: RegisterError.PHONE_NUMBER_EXISTS));
        }
      }
    } else if (event is AttemptOtpCheck) {
      yield (LoadingRegister());
      var res = await _interactor.attemptOtp(event.otp, event.phone);
      if (res is OtpSuccessResponse) {
        yield (RegisterSuccessful(event.phone, event.pass));
      } else if (res is RegisterFailedResponse) {
        if (res.error == RegisterError.OTP_INCORRECT) {
          yield (OtpSubmission(currentError: RegisterError.OTP_INCORRECT));
        }
      }
    } else if (event is ResetRegister) {
      yield (InfoSubmission());
    }
  }
}
