import 'package:bloc/bloc.dart';
import 'package:store/common/constants.dart';
import 'package:store/services/chat/model.dart';

import 'chat_event_state.dart';
import 'chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
//  final SenderType _type;
  final ChatRepository _chatRepository;

  final ChatUser other;
  final int chatId;

  ChatBloc(this._chatRepository, this.other, {this.chatId}
      /*, this._center, this._type*/) {
//    _chatRepository.getMessagesWith(other).then((messages) {
//      if (messages.isNotEmpty) {
//        dispatch(UpdateChat());
//      }
//    });
  }

  @override
  ChatState get initialState => ChatLoading();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessage) {
      yield ChatLoading();
      var sent =
      await _chatRepository.sendMessageTo(event.message, other, chatId);
      if (sent) {
        dispatch(UpdateChat());
      } else {
        Helpers.showToast('خطا در ارسال پیام، لطفا مجددا تلاش نمایید');
      }
    } else if (event is UpdateChat) {
      yield ChatLoading();
      var messages = await _chatRepository.getMessagesWith(other);
      if (messages != null) {
        yield ChatLoaded(Chat(messages, _chatRepository.owner, other, chatId));
      } else {
        yield FailedLoadingChat();
      }
    } else if (event is SeenChat) {
      var messages = await _chatRepository.getMessagesWith(other);

      if (messages != null) {
        messages.forEach((msg) {
          if ((other is ClientChatUser && msg.sender == 'user' && !msg.seen) ||
              (other is CenterChatUser &&
                  msg.sender == 'srv_center' &&
                  !msg.seen)) {
            _chatRepository.seenChat(msg.chatId);
          }
        });
      }
    }
  }
}
