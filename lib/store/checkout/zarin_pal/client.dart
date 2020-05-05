import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:store/common/constants.dart';

class ZarinPalClient {
  Future<ZPResponse> getPaymentURL(ZPPaymentRequest request) async {
    var url = 'https://www.zarinpal.com/pg/rest/WebGate/PaymentRequest.json';

    Map data = {
      "MerchantID": "f2fe5ae0-99fe-11e8-aa9d-005056a205be",
      "CallbackURL": "epet24://open-epet-app",
      "Amount": request.amount,
      "Description": "test"
    };

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print("zpreqstatuscode: ${response.statusCode}");
    print("zprbody: ${response.body}");

    int status = json.decode(response.body)['Status'];
//    int authority = json.decode(response.body)['Status'];

    if (status != null && status == 100) {
      String authority = json.decode(response.body)['Authority'];

      return ZPPaymentSuccessResponse(authority);
    } else {
      return ZPPaymentFailedResponse(status);
    }
  }

  Future<ZPResponse> verifyPayment(ZPVerifyRequest request) async {
    var url =
        'https://www.zarinpal.com/pg/rest/WebGate/PaymentVerification.json';

    Map data = {
      "MerchantID": "f2fe5ae0-99fe-11e8-aa9d-005056a205be",
      "Amount": request.amount,
      "Authority": request.authority
    };

    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);

    print("zpreqstatuscode: ${response.statusCode}");
    print("zprbody: ${response.body}");

    int status = json.decode(response.body)['Status'];
    String refId = json.decode(response.body)['RefID'].toString();
//    int authority = json.decode(response.body)['Status'];

    if (status != null && status == 100) {
      return ZPVerifySuccessResponse(refId);
    } else {
      return ZPVerifyErrorResponse();
    }
  }
}

class ZPRequest extends Equatable {}

class ZPResponse extends Equatable {}

class ZPPaymentRequest extends ZPRequest {
  final String amount;

  ZPPaymentRequest(this.amount);
}

class ZPPaymentSuccessResponse extends ZPResponse {
  final String authority;

  ZPPaymentSuccessResponse(this.authority);

  String getURL() {
    return "https://www.zarinpal.com/pg/StartPay/$authority";
  }
}

class ZPPaymentFailedResponse extends ZPResponse {
  final int err;

  ZPPaymentFailedResponse(this.err);
}

class ZPVerifyRequest extends ZPRequest {
  final String authority;
  final String amount;

  ZPVerifyRequest(this.authority, this.amount);
}

class ZPVerifySuccessResponse extends ZPResponse {
  final String refId;

  ZPVerifySuccessResponse(this.refId);
}

class ZPVerifyErrorResponse extends ZPResponse {}
