import 'package:store/data_layer/adress/address_json.dart';
import 'package:store/data_layer/netclient.dart';

import 'model.dart';

class AddressRepository {
/*
  final AddressWebClient client = AddressWebClient();
*/

  final Net _net;

  AddressRepository(this._net);

  Future<List<Address>> getAll(int sessionId,
      {bool forceUpdate = false}) async {
    var response = await _net.post(EndPoint.GET_USER_ADDRESSES,
        body: {'session_id': sessionId.toString()}, cacheEnabled: !forceUpdate);

    if (response is SuccessResponse) {
      List<Map<String, dynamic>> list =
          new List<Map<String, dynamic>>.from(response.data);


      List<AddressData> addresses =
          list.map((address) => AddressData.fromJson(address)).toList();


      return addresses
          .map((ad) => Address(
              ad.id ?? 0,
              /*(ad.cityName ?? "") + " " +
                  (ad.districtName ?? "") + " " +*/
              (ad.remained ?? ""),
              ad.cityName ?? "",
              ad.cityId ?? '',
              ad.provinceId ?? '',
              ad.name ?? "",
              ad.phone ?? "",
          ad.postalCode ?? '',
          ad.editable == 1))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> addAddress(int sessionId, AddAddressItem address) async {
    var res = await _net.post(EndPoint.ADD_ADDRESS, body: {
      'session_id': sessionId.toString(),
      'transferee_name': address.fullName,
      'transferee_mobile_number': address.phone,
      'city_id': address.cityId.toString(),
      'address': address.address,
      'postal_code': address.postalCode.toString()
    });

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> removeAddress(int addressId) async {
    var res = await _net.post(EndPoint.DELETE_ADDRESS,
        body: {'transferee_address_id': addressId});

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> editAddress(Address address) async {
    var res = await _net.post(EndPoint.EDIT_ADDRESS, body: {
      'transferee_address_id': address.id.toString(),
      'transferee_name': address.fullName,
      'transferee_mobile_number': address.phone,
      'city_id': address.cityId.toString(),
      'address': address.address,
      'postal_code': address.postalCode.toString()
    });

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}
