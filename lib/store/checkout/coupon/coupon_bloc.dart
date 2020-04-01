//import 'package:bloc/bloc.dart';
//import 'package:store/common/bloc_state_event.dart';
//
//import 'coupon_repository.dart';
//
//class CouponBloc extends Bloc<CouponEvent, CouponState> {
//  final CouponRepository _couponRepository;
//
//  final List<ValidCoupon> _addedCoupons = [];
//
//  CouponBloc(this._couponRepository);
//
//  @override
//  CouponState get initialState => LoadingCoupon();
//
//  @override
//  Stream<CouponState> mapEventToState(CouponEvent event) async* {
//    if (event is AddCoupon) {
//      if (!_addedCoupons.contains(event.code)) {
//        yield LoadingCoupon();
//        var coupon =
//            await _couponRepository.validateCoupon(event.code, event.sellers);
//
//        if (coupon != null && coupon is ValidCoupon) {
//          _addedCoupons.add(coupon);
//          yield CouponsAvailable(_addedCoupons);
//        } else {
//          yield InvalidCoupon(message: "کد وارد شده صحصیح نمی‌باشد.");
//        }
//      } else {
//        yield InvalidCoupon(message: "کد تکراری است");
//      }
//    } else if (event is RemoveCoupon) {
//      if (_addedCoupons.map((c) => c.code).contains(event.code)) {
//        _addedCoupons.removeWhere((c) => c.code == event.code);
//        if (_addedCoupons.isNotEmpty) {
//          yield CouponsAvailable(_addedCoupons);
//        } else {
//          yield NoCoupons();
//        }
//      } else {
//        yield InvalidCoupon();
//      }
//    }
//  }
//}
//
//class CouponState extends BlocState {}
//
//class LoadingCoupon extends CouponState {}
//
//class CouponsAvailable extends CouponState {
//  final List<ValidCoupon> coupons;
//
//  CouponsAvailable(this.coupons);
//}
//
//class NoCoupons extends CouponState {}
//
//class InvalidCoupon extends CouponState {
//  final String message;
//
//  InvalidCoupon({this.message = ''});
//}
//
//class CouponEvent extends BlocEvent {}
//
//class AddCoupon extends CouponEvent {
//  final String code;
//  final List<int> sellers;
//
//  AddCoupon(this.code, this.sellers);
//}
//
//class RemoveCoupon extends CouponEvent {
//  final String code;
//
//  RemoveCoupon(this.code);
//}
///*
//class Coupon {
//  final Price discount;
//  final String code;
//
//  Coupon(this.discount, this.code);
//}*/
