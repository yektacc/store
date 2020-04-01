import 'package:json_annotation/json_annotation.dart';

part 'address_json.g.dart';

@JsonSerializable()
class AddressData {
  @JsonKey(name: 'address_id')
  final int id;

  @JsonKey(name: 'transferee_name')
  final String name;

  @JsonKey(name: 'transferee_mobile_number')
  final String phone;

  @JsonKey(name: 'province_name')
  final String provinceName;

  @JsonKey(name: 'city_name')
  final String cityName;

  @JsonKey(name: 'city_id')
  final int cityId;

  @JsonKey(name: 'province_id')
  final int provinceId;

  @JsonKey(name: 'district_name')
  final String districtName;

  @JsonKey(name: 'remained')
  final String remained;

  @JsonKey(name: 'postal_code')
  final String postalCode;

  @JsonKey(name: 'editable')
  final int editable;

  AddressData(this.id, this.name, this.phone, this.provinceName, this.cityName,
      this.cityId, this.provinceId, this.districtName, this.remained,
      this.postalCode, this.editable);

  factory AddressData.fromJson(Map<String, dynamic> json) =>
      _$AddressDataFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDataToJson(this);
}
/*

class AddressJson {
*/
/*
  ProvinceBloc _provinceBloc;
*/ /*


  */
/* Future<List<AddressData>> getUserAddress(int sessionId) async {

    var res = await http.post(
        'http://51.254.65.54/epet24/public/api/getuseraddresses?session_id=$sessionId');
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    List<Map<String, dynamic>> list =
        new List<Map<String, dynamic>>.from(jsonBody);

    List<AddressData> addresses =
        list.map((address) => AddressData.fromJson(address)).toList();

    return addresses;
  }
*/ /*

  */
/* Future<bool> addUserAddress(int sessionId, AddAddressItem address) async {
*/ /*
 */
/*
    String cityId = await _provinceBloc.getCityId(address.city);
*/ /*
 */
/*

    String url =
        'http://51.254.65.54/epet24/public/api/adduseraddress?session_id=$sessionId&transferee_name=${address.fullName}&transferee_mobile_number=${address.phone}&city_id=${address.cityId}&address=${address.address}&postal_code=${address.postalCode}';

    var res = await http.post(url);
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    var responseCode = json.decode(jsonBody)["response_code"];

    if (responseCode == 0) {
      return true;
    } else
      return false;
  }*/ /*


  */
/*Future<bool> deleteUserAddress(int addressId) async {
    String url =
        'http://51.254.65.54/epet24/public/api/deleteuseraddress?transferee_address_id=$addressId';

    var res = await http.post(url);
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    print(jsonBody.toString());

    var responseCode = json.decode(jsonBody)["response_code"];

    if (responseCode == 0) {
      return true;
    } else
      return false;
  }*/ /*


*/
/*  Future<bool> editUserAddress(Address address) async {
    String cityId = await _provinceBloc.getCityId(address.city);

    var res = await http.post(
        'http://51.254.65.54/epet24/public/api/edituseraddress?transferee_address_id=${address.id}&transferee_name=${address.fullName}&transferee_mobile_number=${address.phone}&city_id=$cityId&address=${address.address}');
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    var responseCode = json.decode(jsonBody)["response_code"];

    if (responseCode == 0) {
      return true;
    } else
      return false;
  }*/ /*

}


*/
