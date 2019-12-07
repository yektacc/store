import 'package:store/store/login_register/forgetpass/forget_pass_interactor.dart';

import '../netclient.dart';

class PasswordChangeWebClient {
  final Net _net;

  PasswordChangeWebClient(this._net);

  Future<ForgetPassResponse> passwordForgottenRequest(String phone) async {
    /*  String url =
        'http://51.254.65.54/epet24/public/api/sendforgottenpasswordinfo?mobile_number=$phone';

    print(url);

    var res = await http.post(url);
*/
    var res = await _net
        .post(EndPoint.REQUEST_PASSWORD_CHANGE, body: {'mobile_number': phone},cacheEnabled: false);

    if (res is SuccessResponse) {
      var data = res.data;
      int responseCode = data['response_code'];
      var errResponseMessage = data['response_message'] ?? '';

      if (responseCode == null) {
        print('error null response code forget pass: $errResponseMessage');

        return ForgottenReqFailedResponse();
      } else if (responseCode == 0) {
        return ForgottenReqSuccessResponse();
      } else {
        print('error respnse code $responseCode forget pass: $errResponseMessage');
        return ForgottenReqFailedResponse(err :errResponseMessage.toString());

      }
    } else {
      print('error data from forget pass');
      return ForgottenReqFailedResponse();
    }
  }

/*  Future<String> changePassword(String phone, String password) async {
    *//*  var res = await http.post(
        'http://51.254.65.54/epet24/public/api/sendchangedpasswordinfo?mobile_number=$phone&password=$password');
    String body = res.body;

    print("@#@#@#" + res.body);*//*


  }*/
}
