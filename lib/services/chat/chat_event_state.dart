import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';

import 'model.dart';

@immutable
abstract class ChatEvent extends BlocEvent {}

@immutable
abstract class ChatState extends BlocState {}

// STATES *******************************

class MessagesLoading extends ChatState {
  MessagesLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class MessagesLoaded extends ChatState {
  final List<Message> messages;

  MessagesLoaded(this.messages);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class ChatsLoadingFailed extends ChatState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************

class SendMessage extends ChatEvent {
  final Message message;

  SendMessage(this.message);
}

class UpdateMessages extends ChatEvent {
  final List<Message> messages;

  UpdateMessages(this.messages);
}
