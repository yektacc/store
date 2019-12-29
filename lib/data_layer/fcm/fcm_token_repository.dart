import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:store/data_layer/netclient.dart';

class FcmTokenRepository {
  final Net _net;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  FcmTokenRepository(this._net);

  Future<bool> updateToken(String sessionId) async {
    var token = await _firebaseMessaging.getToken();
    if (token == null) {
      return false;
    } else {
      return _sendTokenToServer(token, sessionId);
    }
  }

  Future<bool> _sendTokenToServer(String token, String sessionId) async {
    var res = await _net.post(EndPoint.SEND_FCM_TOKEN,
        body: {'session_id': sessionId, 'fcm_token': token});

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}
