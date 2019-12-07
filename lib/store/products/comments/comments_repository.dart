import 'package:store/data_layer/netclient.dart';

class CommentsRepository {
  final Net _net;

  CommentsRepository(this._net);

  Future<List<Comment>> fetch(int saleItemId) async {
    var res = await _net.post(EndPoint.GET_COMMENTS,
        body: {'prd_sale_item_id': saleItemId.toString()},cacheEnabled: false);

    if (res is SuccessResponse) {
      var list = List<Map<String, dynamic>>.from(res.data);
      return list.map(parse).toList();
    } else {
      return null;
    }
  }

  Future<bool> sendComment(
      int saleItemId, String comment, String sessionId) async {
    var res = await _net.post(EndPoint.SEND_COMMENT, body: {
      'session_id': sessionId,
      'prd_sale_item_id': saleItemId.toString(),
      'comment': comment
    });

    return res is SuccessResponse;
  }

  Comment parse(Map<String, dynamic> json) {
    return Comment(json['comment'], json['app_user_id'].toString());
  }
}

class Comment {
  final String text;
  final String username;

  Comment(this.text, this.username);
}
