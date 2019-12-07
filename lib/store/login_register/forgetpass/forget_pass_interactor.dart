import 'package:equatable/equatable.dart';
import 'package:store/data_layer/login/password_change_client.dart';
import 'package:store/data_layer/netclient.dart';

class ForgetPassInteractor {
  final PasswordChangeWebClient _client;
  final Net _net;

  ForgetPassInteractor(this._net) : _client = PasswordChangeWebClient(_net);

  Future<ForgetPassResponse> attemptPassChange(String phone) async {
    return await _client.passwordForgottenRequest(phone);
  }

  Future<ForgetPassResponse> attemptOtp(String otpCode, String phone) async {
    /*var url = 'http://51.254.65.54/epet24/public/api/sendverificationcode' +
        "?mobile_number=$phone&verification_code=$otpCode&verification_type=forgotten";

    print(url);
    var res = await http.post(url);*/

    var res = await _net.post(EndPoint.SEND_VERIFICATION_CODE,
        body: {
          'mobile_number': phone,
          'verification_type': 'forgotten',
          'verification_code': otpCode,
        },
        cacheEnabled: false);

    if (res is SuccessResponse) {
      var otpData = res.data;

      if (otpData["response_code"].toString() != null) {
        int responseCode = int.parse(otpData["response_code"].toString());

        if (responseCode == 0) {
          return OtpSuccessResponse();
        } else if (responseCode == 2) {
          return ForgetPassFailedResponse(ForgetPassError.OTP_INCORRECT);
        } else {
          return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
        }
      } else {
        return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
      }
    } else {
      return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
    }
  }

  Future<ForgetPassResponse> changePassword(
      String phone, String newPass) async {
    /*  var res = await _client.changePassword(phone, newPass);
    if (res != null) {
      return PassChangedSuccessResponse();
    } else {
      return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
    }*/
    var res = await _net.post(EndPoint.CHANGE_PASSWORD,
        body: {'mobile_number': phone, 'password': newPass},
        cacheEnabled: false);

    if (res is SuccessResponse) {
      return PassChangedSuccessResponse();

    /*  try {
      } catch (e) {
        print('error changing password:' + e);
        return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
      }*/
    } else {
      return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR);
    }
  }
}

class ForgetPassResponse extends Equatable {}

class PassChangedSuccessResponse extends ForgetPassResponse {
  PassChangedSuccessResponse();
}

class ForgetPassFailedResponse extends ForgetPassResponse {
  final ForgetPassError error;

  ForgetPassFailedResponse(this.error);
}

class ForgottenReqFailedResponse extends ForgetPassResponse {
  final String err;

  ForgottenReqFailedResponse({this.err = ''});
}

class ForgottenReqSuccessResponse extends ForgetPassResponse {}

class OtpSuccessResponse extends ForgetPassResponse {
  OtpSuccessResponse();
}

enum ForgetPassError { OTP_INCORRECT, UNKNOWN_ERROR }
/*/////////// REGISTER ////////////

class ForgetPassResponse extends Equatable {}

class ForgetPassSuccessResponse extends ForgetPassResponse {
  final User user;

  ForgetPassSuccessResponse(this.user);
}

class ForgetPassFailedResponse extends ForgetPassResponse {
  final ForgetPassError error;

  ForgetPassFailedResponse(this.error);
}

class OtpSuccessResponse extends ForgetPassResponse {
  OtpSuccessResponse();
}

class InfoSuccessResponse extends ForgetPassResponse {
  InfoSuccessResponse();
}

enum ForgetPassError {
  PHONE_NUMBER_EXISTS,
  OTP_INCORRECT,
  UNKNOWN_ERROR_INFO,
  UNKNOWN_ERROR_OTP
}

/////////////////////////////////

class ForgetPassInteractor {
  Future<ForgetPassResponse> attemptForgetPass(
      String phoneNo, String password) async {
    var url = 'http://51.254.65.54/epet24/public/api/sendregisterationinfo' +
        "?mobile_number=$phoneNo&password=$password";
    print(url);
    var res = await http.post(url);
    var registerData = json.decode(res.body)['data'];

    print(res.body);

    if (registerData["response_code"] != null) {
      int responseCode = registerData["response_code"];

      if (responseCode == 0) {
        return InfoSuccessResponse();
      } else if (responseCode == 1) {
        return ForgetPassFailedResponse(ForgetPassError.PHONE_NUMBER_EXISTS);
      } else {
        return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR_INFO);
      }
    } else {
      return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR_INFO);
    }
  }

  Future<ForgetPassResponse> attemptOtp(String otpCode, String phone) async {
    var url = 'http://51.254.65.54/epet24/public/api/sendverificationcode' +
        "?mobile_number=$phone&verification_code=$otpCode&verification_type=registeration";
    print(url);
    var res = await http.post(url);
    var otpData = json.decode(res.body)['data'];

    print(res.body);

    if (otpData["response_code"].toString() != null) {
      int responseCode = int.parse(otpData["response_code"].toString());

      if (responseCode == 0) {
        return OtpSuccessResponse();
        otpData["session_id"];
      } else if (responseCode == 2) {
        return ForgetPassFailedResponse(ForgetPassError.OTP_INCORRECT);
      } else {
        return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR_OTP);
      }
    } else {
      return ForgetPassFailedResponse(ForgetPassError.UNKNOWN_ERROR_OTP);
    }
  }
}*/
