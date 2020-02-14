import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:store/data_layer/netclient.dart';

class FcmTokenRepository {
  final Net _net;
  final firebaseMessaging = FirebaseMessaging();

  /*
  // firebase


//  var fcmHandler = FcmHandler();

  */

  FcmTokenRepository(this._net);

  Future<bool> updateToken(String sessionId) async {
    var token = await firebaseMessaging.getToken();
    if (token == null) {
      return false;
    } else {
      return await _sendTokenToServer(token, sessionId);
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
