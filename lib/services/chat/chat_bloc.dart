import 'package:bloc/bloc.dart';
import 'package:store/services/chat/model.dart';

import 'chat_event_state.dart';
import 'chat_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUser sender;
  final ChatUser receiver;

  final ChatRepository _chatRepository;

  ChatBloc(this.sender, this.receiver)
      : this._chatRepository = ChatRepository(sender, receiver) {
    _chatRepository.getMessages().listen((messages) {
      if (messages.isNotEmpty) {
        dispatch(UpdateMessages(messages));
      }
    });
  }

  @override
  ChatState get initialState => MessagesLoading();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is SendMessage) {
      yield MessagesLoading();
      /* var chats = */
      await _chatRepository.sendMessage(event.message);
//      yield MessagesLoaded(chats);
    } else if (event is UpdateMessages) {
      yield MessagesLoaded(event.messages);
    }
  }
}
