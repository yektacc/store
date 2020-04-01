class Address {
  final int id;
  final String postalCode;
  final String address;
  final String city;
  final int cityId;
  final int provinceId;
  final String fullName;
  final String phone;
  final bool editable;

  Address(
    this.id,
    this.address,
    this.city,
    this.cityId,
    this.provinceId,
    this.fullName,
    this.phone,
      this.postalCode, this.editable,
  );
}

class AddAddressItem {
  final String postalCode;
  final String address;
  final int cityId;
  final String fullName;
  final String phone;

  AddAddressItem(
    this.postalCode,
    this.address,
    this.cityId,
    this.fullName,
    this.phone,
/*      this.postalCode*/
  );
}
