import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/store/login_register/login/user.dart';

class RegisterInteractor {
  final Net _net;

  RegisterInteractor(this._net);

  Future<RegisterResponse> attemptRegister(
      String phoneNo, String password) async {
    /*  var url = 'http://51.254.65.54/epet24/public/api/sendregisterationinfo' +
        "?mobile_number=$phoneNo&password=$password";
    print(url);*/
/*
    var res = await http.post(url);
*/
/*
    var registerData = json.decode(res.body)['data'];
*/

    var res = await _net.post(EndPoint.SEND_REGISTER_INFO,
        body: {'mobile_number': phoneNo, 'password': password},
        cacheEnabled: false);

    if (res is SuccessResponse) {
      if (res.data["response_code"] != null) {
        int responseCode = res.data["response_code"];
        if (responseCode == 0) {
          return InfoSuccessResponse();
        } else if (responseCode == 1) {
          return RegisterFailedResponse(RegisterError.PHONE_NUMBER_EXISTS);
        } else {
          return RegisterFailedResponse(RegisterError.UNKNOWN_ERROR_INFO);
        }
      } else {
        return RegisterFailedResponse(RegisterError.UNKNOWN_ERROR_INFO);
      }
    }
  }

  Future<RegisterResponse> attemptOtp(String otpCode, String phone) async {
    /*var url = 'http://51.254.65.54/epet24/public/api/sendverificationcode' +
        "?mobile_number=$phone&verification_code=$otpCode&verification_type=registeration";
    print(url);
    var res = await http.post(url);*/

    var res = await _net.post(EndPoint.SEND_VERIFICATION_CODE,
        body: {
          'mobile_number': phone,
          'verification_code': otpCode,
          'verification_type': 'registeration'
        },
        cacheEnabled: false);

    if (res is SuccessResponse) {
      var otpData = res.data;

      if (otpData["response_code"].toString() != null) {
        int responseCode = int.parse(otpData["response_code"].toString());

        if (responseCode == 0) {
          return OtpSuccessResponse();
        } else if (responseCode == 2) {
          return RegisterFailedResponse(RegisterError.OTP_INCORRECT);
        } else {
          return RegisterFailedResponse(RegisterError.UNKNOWN_ERROR_OTP);
        }
      } else {
        return RegisterFailedResponse(RegisterError.UNKNOWN_ERROR_OTP);
      }
    } else {
      return RegisterFailedResponse(RegisterError.UNKNOWN_ERROR_OTP);
    }
  }
}

/////////// REGISTER ////////////

class RegisterResponse extends Equatable {}

class RegisterSuccessResponse extends RegisterResponse {
  final User user;

  RegisterSuccessResponse(this.user);
}

class RegisterFailedResponse extends RegisterResponse {
  final RegisterError error;

  RegisterFailedResponse(this.error);
}

class OtpSuccessResponse extends RegisterResponse {
  OtpSuccessResponse();
}

class InfoSuccessResponse extends RegisterResponse {
  InfoSuccessResponse();
}

enum RegisterError {
  PHONE_NUMBER_EXISTS,
  OTP_INCORRECT,
  UNKNOWN_ERROR_INFO,
  UNKNOWN_ERROR_OTP
}

/////////////////////////////////
