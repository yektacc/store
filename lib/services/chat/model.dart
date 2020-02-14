import 'package:quiver/core.dart';

// message

abstract class Message {}

class FullMessage extends Message {
  final int id;
  final int chatId;
  final String text;
  final int srvCenterId;
  final int appUserId;
  final String sender;
  final bool seen;

  FullMessage(this.id, this.chatId, this.text, this.srvCenterId, this.appUserId,
      this.sender, this.seen);

  factory FullMessage.fromJson(Map<String, dynamic> json) {
    return FullMessage(
        json['id'],
        json['chat_id'],
        json['message'],
        json['srv_center_id'],
        json['app_user_id'],
        json['sender'],
        json['is_seen'] == 1);
  }

  @override
  String toString() {
    return 'full message: id: $id - srv_center_id: $srvCenterId - app_user_id: $appUserId - sender : $sender';
  }
}

class SimpleMessage extends Message {
  final bool sentByMe;
  final String text;

  SimpleMessage(this.text, this.sentByMe);
}

// user

abstract class ChatUser {
  ChatUser();

  String get id;

  @override
  bool operator ==(other) {
    return other is ChatUser &&
        this.runtimeType == other.runtimeType &&
        this.id == other.id;
  }

  @override
  int get hashCode {
    return hash2(this.runtimeType, this.id);
  }
}

class ClientChatUser extends ChatUser {
  final int appUserId;

  ClientChatUser(this.appUserId);

  @override
  String get id => appUserId.toString();
}

class CenterChatUser extends ChatUser {
  final String srvCenterId;

  CenterChatUser(this.srvCenterId);

  @override
  String get id => srvCenterId;
}

// chat

class Chat {
  final int chatId;
  final List<SimpleMessage> messages;
  final ChatUser owner;
  final ChatUser other;
  bool hasNew;

//  final bool hasNew;

  Chat(List<Message> messages, this.owner, this.other, this.chatId)
      : this.messages = messages.map((msg) {
    assert(messages.isNotEmpty);
    if (msg is SimpleMessage) {
      return msg;
    } else if (msg is FullMessage) {
      bool sentByMe = false;
      if (other is CenterChatUser && msg.sender == 'user') {
        sentByMe = true;
      } else if (other is ClientChatUser && msg.sender == 'srv_center') {
        sentByMe = true;
      }
      return SimpleMessage(msg.text, sentByMe);
    } else {
      throw Exception('wrong message type: $msg');
    }
  }).toList() {
    hasNew = _hasNew(messages);
  }

  bool _hasNew(List<Message> messages) {
    bool newMessage = false;
    messages.forEach((msg) {
      if (msg is FullMessage &&
          !msg.seen &&
          ((msg.sender == 'srv_center' && owner is ClientChatUser) ||
              (msg.sender == 'user' && owner is CenterChatUser))) {
        print('fourd one:' + msg.text);
        newMessage = true;
      }
    });
    return newMessage;
  }
}
