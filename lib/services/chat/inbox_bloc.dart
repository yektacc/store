import 'package:bloc/bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/netclient.dart';
import 'package:store/services/chat/chat_bloc.dart';
import 'package:store/services/chat/chat_event_state.dart';
import 'package:store/services/chat/chat_repository.dart';

import 'inbox_event_state.dart';
import 'model.dart';

class InboxBloc extends Bloc<InboxEvent, InboxState> {
//  final SenderType _type;
  final ChatRepository _chatRepository;
  final ChatUser _owner;
  final List<ChatBloc> _chatBlocs = [];

  InboxBloc(this._owner, Net net)
      : this._chatRepository = ChatRepository(net, _owner) {
    /*   _chatRepository.getAllMessages().then((messages) {
      if (messages != null) {
        dispatch(UpdateInbox());
      }
    });*/
  }

  @override
  InboxState get initialState => InboxLoading();

  @override
  Stream<InboxState> mapEventToState(InboxEvent event) async* {
    if (event is UpdateInbox) {
      yield InboxLoading();
      var messages = await _chatRepository.getAllMessages();
      print(messages);
      if (messages != null) {
        bool newMessage = false;
        messages.forEach((msg) {
          if (!msg.seen) {
            newMessage = true;
          }
        });
        yield InboxLoaded(_makeChatBlocs(messages), newMessage);
      } else {
        yield InboxLoadingFailed();
      }
    } else if (event is SendBroadcast) {
      var success = await _chatRepository.requestBroadcastChat();
      if (success) {
        yield BroadcastSent();
      } else {
        yield InboxLoadingFailed();
      }
    }
  }

  List<ChatBloc> _makeChatBlocs(List<FullMessage> messages) {
    List<Chat> chats = [];

    messages.forEach((msg) {
      print(msg.toString());

      bool sentByMe = false;
      if (_owner is ClientChatUser && msg.sender == 'user') {
        sentByMe = true;
      } else if (_owner is CenterChatUser && msg.sender == 'srv_center') {
        sentByMe = true;
      }

//      print('owner: $_owner  sent by me:' + sentByMe.toString());

      if (!chats.map((chat) => chat.chatId).contains(msg.chatId)) {
//        print('message not available in chats: $')

        List<Message> messageList = [
          SimpleMessage(msg.text, sentByMe, msg.seen, msg.date)
        ];

        ClientChatUser client = ClientChatUser(msg.appUserId);
        CenterChatUser center = CenterChatUser(msg.srvCenterId.toString());

        var other;

        if (client == _owner) {
          other = center;
        } else if (center == _owner) {
          other = client;
        } else {
          throw Exception('owner: $_owner wrong chat users');
        }

//        print('owner: $_owner other user: $other messages: $messageList');

        chats.add(Chat(messageList, _owner, other, msg.chatId));

//        print('owner: $_owner temp chats: $chats');
      } else {
//        print('owner: $_owner chat wasnt added $msg');

        var iranDate = Helpers.getPersianDate(msg.date);

        chats
            .firstWhere((chat) => chat.chatId == msg.chatId)
            .messages
            .add(SimpleMessage(msg.text, sentByMe, msg.seen, msg.date));
      }
    });

    return chats.map((chat) {
      var bloc = ChatBloc(_chatRepository, chat.other, chatId: chat.chatId);
      bloc.dispatch(UpdateChat());
      return bloc;
    }).toList();
  }

  @override
  void dispose() {}
}
