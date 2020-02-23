import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:store/data_layer/netclient.dart';

class FcmTokenRepository {
  final Net _net;
  final firebaseMessaging = FirebaseMessaging();

  FcmTokenRepository(this._net);

  Future<bool> updateUserToken(String sessionId) async {
    var token = await firebaseMessaging.getToken();
    if (token == null) {
      return false;
    } else {
      return await _sendUserTokenToServer(token, sessionId);
    }
  }

  Future<bool> updateManagerToken(int srvCenterId) async {
    var token = await firebaseMessaging.getToken();
    if (token == null) {
      return false;
    } else {
      return await _sendManagerTokenToServer(token, srvCenterId);
    }
  }

  Future<bool> _sendUserTokenToServer(String token, String sessionId) async {
    var res = await _net.post(EndPoint.SEND_USER_FCM_TOKEN,
        body: {'session_id': sessionId, 'fcm_token': token});

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _sendManagerTokenToServer(String token, int srvCenterId) async {
    var res = await _net.post(EndPoint.SEND_MNG_FCM_TOKEN,
        body: {'id': srvCenterId.toString(), 'fcm_token': token});

    if (res is SuccessResponse) {
      return true;
    } else {
      return false;
    }
  }
}
