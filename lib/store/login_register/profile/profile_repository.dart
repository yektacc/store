import 'package:store/data_layer/netclient.dart';

import 'model.dart';

class ProfileRepository {
  final Net _net;

  ProfileRepository(this._net);

  Stream<Profile> load(String sessionId, {bool forceUpdate}) async* {
    var res = await _net.post(EndPoint.GET_USER_PROFILE,
        body: {'session_id': sessionId.toString()}, cacheEnabled: !forceUpdate);

    if (res is SuccessResponse) {
      yield parse(res.data['personal_information'], sessionId);
    } else {
      yield null;
    }
  }

  Profile parse(Map<String, dynamic> json, String sessionId) {
    return Profile(
        json['firstname'].toString() == "null"
            ? ""
            : json['firstname'].toString(),
        json['lastname'].toString() == "null"
            ? ""
            : json['lastname'].toString(),
        json['mobile_number'].toString() == "null"
            ? ""
            : json['mobile_number'].toString(),
        json['credit_card_number'].toString() == "null"
            ? ""
            : json['credit_card_number'].toString(),
        json['email'].toString() == "null" ? "" : json['email'].toString(),
        json['national_code'].toString() == "null"
            ? ""
            : json['national_code'].toString(),
        sessionId);
  }

  Future<bool> updateProfile(EditRequest request) async {
    var res = await _net.post(EndPoint.EDIT_PROFILE, body: {
      "session_id": request.newProfile.sessionId ?? '',
      "firstname": request.newProfile.firstName ?? '',
      "lastname": request.newProfile.lastName ?? '',
/*
      "mobile_number": request.newProfile.phone ?? '',
*/
      "email": request.newProfile.email ?? '',
      "national_code": request.newProfile.nationalCode ?? '',
      "credit_card_number": request.newProfile.creditCardNo ?? '',
    });

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }

    /// fix the type
    /* print(url);
    var res = await http.post(url);
    print('profile repo' + res.toString());
    var editData = json.decode(res.body)['data'];*/

    /*  if (editData["response_code"] != null) {
      int responseCode = editData["response_code"];

      if (responseCode == 0) {
        return SuccessResponse(request.newProfile.sessionId);
      } else
        return FailureResponse();
    } else {
      return FailureResponse();
    }*/
  }
}

class EditRequest {
  final Profile newProfile;

  EditRequest(this.newProfile);
}
/*
class EditResponse extends Equatable {}

class SuccessResponse extends EditResponse {
  final String sessionId;

  SuccessResponse(this.sessionId);
}

class FailureResponse extends EditResponse {}
*/
