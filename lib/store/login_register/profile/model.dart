class Profile {
  final String firstName;
  final String lastName;
  final String email;
  final String nationalCode;
  final String phone;
  final String creditCardNo;
  final String sessionId;

/*
  final String address;
*/

  Profile(this.firstName, this.lastName, this.phone, this.creditCardNo,
      this.email, this.nationalCode, this.sessionId
      /*, this.address*/);

  @override
  String toString() => "name: $firstName  phone: $phone ";
}
