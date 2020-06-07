import 'package:meta/meta.dart';
import 'package:store/common/bloc_state_event.dart';
import 'package:store/services/chat/chat_bloc.dart';

@immutable
abstract class InboxEvent extends BlocEvent {}

@immutable
abstract class InboxState extends BlocState {}

// STATES *******************************

class InboxLoading extends InboxState {
  InboxLoading();

  @override
  String toString() {
    return "STATE: loading";
  }
}

class InboxLoaded extends InboxState {
  final List<ChatBloc> inbox;
  final bool newMessage;

  InboxLoaded(this.inbox, this.newMessage);

  @override
  String toString() {
    return "STATE: loaded";
  }
}

class InboxLoadingFailed extends InboxState {
  @override
  String toString() {
    return "STATE: failed";
  }
}

// EVENTS *******************************
/*
class SendMessage extends InboxEvent {
  final Message message;

  SendMessage(this.message);
}*/

class UpdateInbox extends InboxEvent {}

class SendBroadcast extends InboxEvent {
  final String message;

  SendBroadcast(this.message);
}

class BroadcastSent extends InboxState {}
