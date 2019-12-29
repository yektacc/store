import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/services/chat/model.dart';

class ChatRepository {
  final ChatUser sender;
  final ChatUser receiver;
  final String chatId;

  ChatRepository(this.sender, this.receiver)
      : chatId = "${receiver.id}_${sender.id}";

  sendMessage(Message message) {
    var documentReference = Firestore.instance
        .collection('messages')
        .document(chatId)
        .collection(chatId)
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'idFrom': sender.id,
          'idTo': receiver.id,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': message.text,
        },
      );
    });
  }

  Stream<List<Message>> getMessages() async* {
    yield* Firestore.instance
        .collection('messages')
        .document(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()
        .map((qs) => qs.documents
            .map((msg) => Message(msg.data['content'].toString(), 0))
            .toList());
/*
    ;
    await for (var docs in Firestore.instance
        .collection('messages')
        .document(chatId)
        .collection(chatId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots()) {
      print(chatId);
      print('docs: ' + docs.toString());
      var messages = docs.documents;

      yield messages;
    }*/
  }
}
