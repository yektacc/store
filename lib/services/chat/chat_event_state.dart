import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/services/chat/chat_repository.dart';

import 'model.dart';

@immutable
abstract class ChatEvent extends BlocEvent {}

@immutable
abstract class ChatState extends BlocState {}

// STATES *******************************

class ChatLoading extends ChatState {
  ChatLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class ChatLoaded extends ChatState {
  final ContactInfo otherInfo;
  final Chat chat;

  ChatLoaded(this.chat, this.otherInfo);

  @override
  String toString() {
    return "STATE: loaded";
  }
}


class FailedLoadingChat extends ChatState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class SendMessage extends ChatEvent {
  final SimpleMessage message;

  SendMessage(this.message);
}

class UpdateChat extends ChatEvent {}

class SeenChat extends ChatEvent {
  final Chat chat;

  SeenChat(this.chat);
}
