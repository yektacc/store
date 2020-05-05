import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/services/chat/model.dart';

//enum SenderType { USER, CENTER }

class ChatRepository {
  /*final CenterChatUser center;
  final ClientChatUser user;
  final SenderType type;*/
  final ChatUser owner;
  final Net _net;

//  int chatId;
  String sessionId;

  ChatRepository(this._net, this.owner, {this.sessionId});

  // return -1 if failed
  Future<int> _startChatWith(ChatUser to) async {
    if (sessionId != null) {
//      if (chatId == null) {
//        var appUserId;
      var srvCenterId;

      if (owner is ClientChatUser && to is CenterChatUser) {
//          appUserId = (owner as ClientChatUser).appUserId;
        srvCenterId = to.srvCenterId;
      }
      /*else if (owner is CenterChatUser && to is ClientChatUser) {
        appUserId = to.appUserId;
        srvCenterId = (owner as CenterChatUser).srvCenterId;
      }*/
      else {
        throw (Exception('the types arent valid for starting chat'));
      }

      var res = await _net.post(EndPoint.START_CHAT,
          cacheEnabled: false,
          body: {'session_id': sessionId, 'srv_center_id': srvCenterId});

      if (res is SuccessResponse) {
        var chatId = Map.of(res.data)['chat_id'];
        return chatId;
      } else {
        Helpers.showErrorToast();
        return -1;
      }
//      } else {
//        return chatId;
//      }
    } else {
      throw Exception("can't start a chat with no session id");
    }
  }

  Future<bool> sendMessageTo(SimpleMessage message, ChatUser to,
      int chatId) async {
    print('sending message, chat_id = $chatId');
    if (chatId == null) {
      var res = await _startChatWith(to);
      if (res != -1) {
        chatId = res;
      } else {
        return false;
      }
    }

    var appUserId;
    var srvCenterId;
    var sender;

    if (owner is ClientChatUser && to is CenterChatUser) {
      appUserId = (owner as ClientChatUser).appUserId;
      srvCenterId = to.srvCenterId;
      sender = 'user';
    } else if (owner is CenterChatUser && to is ClientChatUser) {
      appUserId = to.appUserId;
      srvCenterId = (owner as CenterChatUser).srvCenterId;
      sender = 'srv_center';
    } else {
      throw (Exception('the types arent valid'));
    }

    var res =
    await _net.post(EndPoint.SEND_MESSAGE, cacheEnabled: false, body: {
      'app_user_id': appUserId,
      'srv_center_id': srvCenterId,
      'sender': sender,
      'message': message.text,
      'chat_id': chatId
    });

    return res is SuccessResponse;
  }

  Future<List<FullMessage>> getAllMessages() async {
    var res;
    if (owner is ClientChatUser) {
      res = await _net
          .post(EndPoint.GET_ALL_USER_CHATS, cacheEnabled: false, body: {
        'app_user_id': (owner as ClientChatUser).appUserId,
      });
    } else if (owner is CenterChatUser) {
      res = await _net.post(EndPoint.GET_ALL_CENTER_CHATS,
          cacheEnabled: false,
          body: {'srv_center_id': (owner as CenterChatUser).srvCenterId});
    } else {
      throw (Exception('the types arent valid'));
    }

    if (res is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(res.data);

      var messages = list.map((json) => FullMessage.fromJson(json)).toList();

      return messages;
    } else {
      Helpers.showErrorToast();
      return null;
    }
  }

  Future<bool> seenChat(chatId) async {
    var res = await _net.post(EndPoint.SEEN_CHAT, cacheEnabled: false, body: {
      'chat_id': chatId.toString(),
    });

    return res is SuccessResponse;
  }

  Future<List<FullMessage>> getMessagesWith(ChatUser to) async {
    var res;

    var appUserId;
    var srvCenterId;

    if (owner is ClientChatUser && to is CenterChatUser) {
      appUserId = (owner as ClientChatUser).appUserId;
      srvCenterId = to.srvCenterId;
      /*res = await _net.post(EndPoint.GET_ALL_CHATS,
          cacheEnabled: false,
          body: {'app_user_id': appUserId, 'srv_center_id': srvCenterId});*/
    } else if (owner is CenterChatUser && to is ClientChatUser) {
      appUserId = to.appUserId;
      srvCenterId = (owner as CenterChatUser).srvCenterId;
      /*  res = await _net.post(EndPoint.GET_ALL_CHATS,
          cacheEnabled: false,
          body: {'app_user_id': appUserId, 'srv_center_id': srvCenterId});*/
    } else {
      throw (Exception('the types arent valid'));
    }

    res = await _net.post(EndPoint.GET_CHAT_WITH,
        cacheEnabled: false,
        body: {'app_user_id': appUserId, 'srv_center_id': srvCenterId});

    if (res is SuccessResponse) {
      if (res.data == 'chat not found') {
        var res = await _startChatWith(to);
        if (res != -1) {
//          chatId = res;
          return [];
        } else {
          return null;
        }
      } else {
        var list = List<Map<String, dynamic>>.from(res.data);
        var messages = list.map((json) => FullMessage.fromJson(json)).toList();
        return messages;
      }
    } else {
      Helpers.showErrorToast();
      return null;
    }
  }

  Future<ContactInfo> getContactInfo(ChatUser chatUser) async {
    if (chatUser is ClientChatUser) {
      var res = await _net.post(EndPoint.GET_CONTACT_INFO,
          body: {'id': chatUser.appUserId.toString()});

      if (res is SuccessResponse) {
        var info = List<Map<String, dynamic>>.from(res.data)[0];

        var fn = info['firstname'];
        var ln = info['lastname'];

        var title;

        if (fn != '' || ln != '') {
          title = fn + " " + ln;
        } else {
          title = 'نام مشخص نشده است';
        }

        return ContactInfo(title);
      } else {
        return ContactInfo('');
      }
    } else if (chatUser is CenterChatUser) {
      var res = await _net.post(EndPoint.GET_CENTERS,
          body: {'center_id': chatUser.srvCenterId});

      if (res is SuccessResponse) {
        var info = List<Map<String, dynamic>>.from(res.data)[0];

        var centerName = info['center_name'];

        return ContactInfo(centerName);
      } else {
        return ContactInfo('');
      }
    } else {
      throw Exception('invalid type: $chatUser');
    }
  }
}

class ContactInfo {
  final String title;

  ContactInfo(this.title);
}
