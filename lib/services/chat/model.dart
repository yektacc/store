class Message {
  final String text;
  final int timestamp;

  Message(this.text, this.timestamp);
}

abstract class ChatUser {
  ChatUser();

  String get id;
}

class ClientChatUser extends ChatUser {
  final String phoneNumber;

  ClientChatUser(this.phoneNumber);

  @override
  String get id => "1_$phoneNumber";
}

class ClinicChatUser extends ChatUser {
  final String clinicId;

  ClinicChatUser(this.clinicId);

  @override
  String get id => "2_$clinicId";
}
