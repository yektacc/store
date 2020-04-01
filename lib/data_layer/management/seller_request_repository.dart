import 'package:store/data_layer/netclient.dart';

class SellerRequestRepository {
  final Net _net;

  SellerRequestRepository(this._net);

  Future<bool> sendRequest(
      int appUserId,
      String firstName,
      String lastName,
      int provinceId,
      int cityId,
      String job,
      String phone,
      String address,
      String extra) async {
    var res = await _net.post(EndPoint.SEND_SELLER_REQUEST, body: {
      'app_user_id': appUserId.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'province_id': provinceId.toString(),
      'city_id': cityId.toString(),
      'job_brief': job,
      'call_namber': phone,
      'address': address,
      'additional_info': extra
    });

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}
