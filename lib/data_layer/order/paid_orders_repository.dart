import '../netclient.dart';

class PreviousOrdersRepository {
  final Net _net;

  PreviousOrdersRepository(this._net);

  Stream<List<PaidOrder>> getPaidOrders(String sessionId) async* {
    PostResponse response = await _net
        .post(EndPoint.GET_PAID_ORDERS, body: {'session_id': sessionId});
    if (response is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(response.data);
      yield list.map(parse).toList();
    } else {
      yield [];
    }
  }

  PaidOrder parse(Map<String, dynamic> json) {
    return PaidOrder('a');
  }
}

class PaidOrder {
  final String a;

  PaidOrder(this.a);
}
