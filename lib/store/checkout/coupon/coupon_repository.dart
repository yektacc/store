import 'package:store/data_layer/netclient.dart';
import 'package:store/store/products/filter/filter.dart';

class CouponRepository {
  final Net _net;

  CouponRepository(this._net);

  Future<ValidCoupon> validateCoupon(String code, List<int> sellerIds) async {
    var res = await _net.post(EndPoint.SEND_COUPON,
        body: {'code': code, 'seller_id': sellerIds});

    if (res is SuccessResponse) {
      return ValidCoupon(code, res.data);
    } else {
      return null;
    }
  }
}

class ValidCoupon {
  final String code;
  final int codeId;
  final Price discount;
  final int sellerId;

  ValidCoupon(this.code, Map<String, dynamic> json)
      : this.codeId = json['coupon_code_id'],
        this.discount = Price(json['discount_price'].toString()),
        this.sellerId = json['seller_id'];
}
