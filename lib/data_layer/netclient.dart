import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:quiver/core.dart';
import 'package:store/common/constants.dart';

class PostResponse extends Equatable {}

class SuccessResponse extends PostResponse {
  final dynamic data;

  SuccessResponse({this.data = const {}});
}

class FailedResponse extends PostResponse {
  final String msg;

  FailedResponse({this.msg});
}

class PostRequest {
  final Map<String, dynamic> body;
  final EndPoint endPoint;

  PostRequest(this.body, this.endPoint);

  @override
  bool operator ==(other) {
    return other is PostRequest &&
        this.endPoint == other.endPoint &&
        this.body == other.body;
  }

  @override
  int get hashCode {
    return hash2(endPoint.toString(), body.toString());
  }

  @override
  String toString() {
    return endPoint.toString() + body.toString();
  }
}

class Net {
  Map<String, PostResponse> _cache = Map();

  Future<PostResponse> post(EndPoint endPoint,
      {Map<String, dynamic> body = const {}, bool cacheEnabled = true}) async {
    var initRequest = PostRequest(body, endPoint);
    if (cacheEnabled && _cache.containsKey(initRequest.toString())) {
      return _cache[initRequest.toString()];
    } else {
      String url = '';
      if (endPoint == EndPoint.START_CHAT ||
          endPoint == EndPoint.SEND_MESSAGE ||
          endPoint == EndPoint.GET_ALL_CENTER_CHATS ||
          endPoint == EndPoint.GET_ALL_USER_CHATS ||
          endPoint == EndPoint.SEEN_CHAT ||
          endPoint == EndPoint.GET_CHAT_WITH) {
        url = AppUrls.alt_api_url + getSubUrl(endPoint);
      } else {
        url = AppUrls.api_url + getSubUrl(endPoint);
      }

      print("\n>>>>>>>>>>>>>>>>>>>>>>>$endPoint>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
          "sending request: \n"
          "------------------------------\n"
          "url: $url\n"
          "body: $body\n"
          ">>>>>>>>>>>>>>>>>>>>>>>>>>>$endPoint>>>>>>>>>>>>>>>>>>>>>>>\n");

      var first = true;
      var err = false;
      var remainedTries = 1;
      var nextRetryAfter = 0;

      Dio dio = Dio();

      dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) {
        // Do some pre processing before returning the response data
        return response; // continue
      }, onError: (DioError e) {
        // Do some pre processing when the request fails
        print('dio error: headers: ${e.response.headers}');
        if (e.response.statusCode == 429) {
          nextRetryAfter = int.parse(e.response.headers['retry-after'].first,
              onError: (_) => 0);
          print('retry afterr ${e.response.realUri}:' +
              nextRetryAfter.toString());
        }
        err = true;
        return e; //continue
      }));

      while (first || err && remainedTries > 0) {
        first = false;

        var jsonBody;

        FormData formData = new FormData.fromMap(body);

        try {
          Response res = await dio.post(url, data: formData);
          if (res.statusCode == 200) {
            nextRetryAfter = 0;
            if (res.data is Map) {
              jsonBody = Map<String, dynamic>.from(res.data);
            } else {
              jsonBody = json.decode(res.data);
            }
          } else {
            err = true;
            print(
                "STATUS ERROR LOADING URL: status: ${res.statusCode} $endPoint $body remaind tries: $remainedTries  ");
          }
        } catch (e, stacktrace) {
          await Future.delayed(Duration(seconds: nextRetryAfter));
          err = true;
          remainedTries--;
          print(
              "ERROR LOADING URL: $endPoint $body remaind tries: $remainedTries" +
                  e.toString());
          print(stacktrace);
        }

        if (!err) {
          int apiStatus = int.parse(jsonBody['api_status'].toString());
          String apiMessage = jsonBody['api_message'];
          var data = jsonBody['data'];

          if (apiStatus == 1) {
            if (data != null) {
              print(
                  "\n<<<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<<<\n"
                  "success response: $url $body \n"
                  "------------------------------\n"
                  "api message: $apiMessage\n"
                  "data: \n $data\n"
                  "<<<<<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<\n");

              if (cacheEnabled) {
                _cache.putIfAbsent(
                    initRequest.toString(), () => SuccessResponse(data: data));
              }

              return SuccessResponse(data: data);
            } else {
              print(
                  "\n<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
                  "success response: $url $body \n"
                  "------------------------------\n");
              print("no data field\n");
              print(
                  "<<<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<<<\n");
              if (cacheEnabled) {
                _cache.putIfAbsent(
                    initRequest.toString(), () => SuccessResponse());
              }
              return SuccessResponse();
            }
          } else {
            print(
                "\n<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<<<<<"
                "failed: $url $body\n"
                "------------------------------\n"
                "error: $apiMessage\n"
                "<<<<<<<<<<<<<<<<<<<<<<<<<$endPoint<<<<<<<<<<<<<<<<<<<<<<<<<\n");
            return FailedResponse();
          }
        }
      }
    }
  }

  Future<String> get(EndPoint endPoint) async {
    String url = '';

//    url = AppUrls.api_url + getSubUrl(endPoint);
    url = 'http://server.epet24.ir/ip.php';

    print("\n>>>>>>>>>>>>>>>>>>>>>>>$endPoint>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
        "sending GET request: \n"
        "------------------------------\n"
        "url: $url\n"
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>$endPoint>>>>>>>>>>>>>>>>>>>>>>>\n");

    var first = true;
    var err = false;
    var remainedTries = 1;
    var nextRetryAfter = 0;

    Dio dio = Dio();

//    dio.interceptors.add(InterceptorsWrapper(onResponse: (Response response) {
//      // Do some pre processing before returning the response data
//      return response; // continue
//    }, onError: (DioError e) {
//      // Do some pre processing when the request fails
//      print(e);
//      /*
//      if (e.response.statusCode == 429) {
//        nextRetryAfter = int.parse(e.response.headers['retry-after'].first,
//            onError: (_) => 0);
//        print(
//            'retry afterr ${e.response.realUri}:' + nextRetryAfter.toString());
//      }*/
//      err = true;
//      return e; //continue
//    }));

    while (first || err && remainedTries > 0) {
      first = false;

      var responseString;

      try {
        Response res = await dio.get(url);
        if (res.statusCode == 200) {
          nextRetryAfter = 0;
          responseString = res.data;
        } else {
          err = true;
          print(
              "STATUS ERROR LOADING URL: status: ${res
                  .statusCode} $endPoint remaind tries: $remainedTries  ");
        }
      } catch (e, stacktrace) {
        await Future.delayed(Duration(seconds: nextRetryAfter));
        err = true;
        remainedTries--;
        print("ERROR LOADING URL: $endPoint remaind tries: $remainedTries" +
            e.toString());
        print(stacktrace);
      }

      if (!err) {
        return responseString;
      }
    }
  }
}

enum EndPoint {
  ADD_ADDRESS,
  DELETE_ADDRESS,
  EDIT_ADDRESS,
  EDIT_PROFILE,
  EMPTY_SHOPPING_CART,
  GET_ADS,
  GET_ANIMAL_TYPES,
  GET_STRUCTURE,
  GET_DISTRICT_NAME,
  GET_FC_TYPES,
  GET_FC_LIST,
  GET_FILTERED_PRODUCTS,
  GET_PAYMENT_TYPES,
  GET_SELLER_PRODUCTS_TAG,
  GET_PRODUCT_DETAIL,
  GET_PRODUCT_PICS,
  GET_PRODUCTS,
  GET_BRANDS,
  GET_PRODUCT_BY_SELLER,
  GET_PRODUCTS_TAG,
  GET_PRICING_PRODUCTS,
  GET_PROVINCE_CITY,
  GET_FC_REQUEST_CATEGORY,
  GET_SHIPPING_COST,
  GET_SHOPPING_CART,
  GET_SHOPPING_ORDERS,
  GET_SITE_INFO,
  GET_CENTER_TYPES,
  GET_CENTERS,
  GET_CENTER_SERVICES,
  GET_CENTER_PICTURES,
  GET_SERVICES_TYPES,
  SEND_CENTER_SCORE,
  GET_USER_ADDRESSES,
  GET_USER_PROFILE,
  REMOVE_ORDER,
  SAVE_FINAL_ORDER,
  GET_PAID_ORDERS,
  SAVE_PAYMENT_INFO,
  SAVE_ORDER,
  CHANGE_PASSWORD,
  ADD_FC_REQUEST,
  REQUEST_PASSWORD_CHANGE,
  LOG_IN,
  LOG_OUT,
  GET_IP,
  SEND_REGISTER_INFO,
  SEND_SHOPPING_CART,
  SEND_VERIFICATION_CODE,
  GET_PRODUCT_OF_SELLER,
  SELLER_LOGIN,
  ADD_SELLER_PRODUCT,
  GET_POST_TARIFF,
  SEND_PRODUCT_SCORE,
  EDIT_SELLER_PRODUCT,
  GET_COMMENTS,
  SEND_COMMENT,
  SEND_USER_FCM_TOKEN,
  SEND_MNG_FCM_TOKEN,
  GET_USER_PET,
  SEND_USER_PET,
  EDIT_USER_PET,
  DELETE_USER_PET,
  SEND_SELLER_REQUEST,
  START_CHAT,
  SEND_MESSAGE,
  GET_ALL_CENTER_CHATS,
  GET_ALL_USER_CHATS,
  GET_CHAT_WITH,
  SEEN_CHAT,
  GET_CONTACT_INFO,
  SAVE_TRANSACTION,
  SEND_COUPON,
  GET_FAVORITES,
  ADD_FAVORITE,
  DELETE_FAVORITE,
  PAYMENT_FINAL_TRANSACTION,
  ORDER_PRODUCT_PACKED,
  ORDER_SENT
}

String getSubUrl(EndPoint endPoint) {
  var subUrl = '';
  switch (endPoint) {
    case EndPoint.ADD_ADDRESS:
      subUrl = 'adduseraddress';
      break;
    case EndPoint.DELETE_ADDRESS:
      subUrl = 'deleteuseraddress';
      break;
    case EndPoint.EDIT_ADDRESS:
      subUrl = 'edituseraddress';
      break;
    case EndPoint.EDIT_PROFILE:
      subUrl = 'edituserprofile';
      break;
    case EndPoint.EMPTY_SHOPPING_CART:
      subUrl = 'emptyshoppingcart';
      break;
    case EndPoint.GET_ADS:
      subUrl = 'getadvlist';
      break;
    case EndPoint.GET_ANIMAL_TYPES:
      subUrl = 'getanimalstype';
      break;
    case EndPoint.GET_STRUCTURE:
      subUrl = 'getcategorystructure';
      break;
    case EndPoint.GET_DISTRICT_NAME:
      subUrl = 'getdistricstname';
      break;
    case EndPoint.GET_FC_TYPES:
      subUrl = 'getfccategories';
      break;
    case EndPoint.GET_FC_LIST:
      subUrl = 'getfcrequestlist';
      break;
    case EndPoint.GET_FILTERED_PRODUCTS:
      subUrl = 'getfilteredproducts';
      break;
    case EndPoint.GET_PAYMENT_TYPES:
      subUrl = 'getpaymenttypes';
      break;
    case EndPoint.GET_SELLER_PRODUCTS_TAG:
      subUrl = 'getprdsellerproducttags';
      break;
    case EndPoint.GET_PRODUCT_DETAIL:
      subUrl = 'getproductdetails';
      break;
    case EndPoint.GET_PRODUCT_PICS:
      subUrl = 'getproductpictures';
      break;
    case EndPoint.GET_PRODUCTS:
      subUrl = 'getproducts';
      break;
    case EndPoint.GET_BRANDS:
      subUrl = 'getproductsbrands';
      break;
    case EndPoint.GET_PRODUCT_BY_SELLER:
      subUrl = 'getproductsbyseller';
      break;
    case EndPoint.GET_PRODUCTS_TAG:
      subUrl = 'getproducttags';
      break;
    case EndPoint.GET_PRICING_PRODUCTS:
      subUrl = 'getproducttitles';
      break;
    case EndPoint.GET_PROVINCE_CITY:
      subUrl = 'getprovincecityname';
      break;
    case EndPoint.GET_FC_REQUEST_CATEGORY:
      subUrl = 'getfccategories';
      break;
    case EndPoint.GET_SHIPPING_COST:
      subUrl = 'getshipmentcost';
      break;
    case EndPoint.GET_SHOPPING_CART:
      subUrl = 'getshipmentcost';
      break;
    case EndPoint.GET_SHOPPING_ORDERS:
      subUrl = 'getshoppingorders';
      break;
    case EndPoint.GET_SITE_INFO:
      subUrl = 'getsiteinfo';
      break;
    case EndPoint.GET_CENTER_TYPES:
      subUrl = 'getsrvcategoriesname';
      break;
    case EndPoint.GET_CENTERS:
      subUrl = 'getsrvcenters';
      break;
    case EndPoint.GET_CENTER_SERVICES:
      subUrl = 'getsrvcenterservices';
      break;
    case EndPoint.GET_SERVICES_TYPES:
      subUrl = 'getsrvcategoriesname';
      break;
    case EndPoint.GET_USER_ADDRESSES:
      subUrl = 'getuseraddresses';
      break;
    case EndPoint.GET_USER_PROFILE:
      subUrl = 'getuserprofile';
      break;
    case EndPoint.REMOVE_ORDER:
      subUrl = 'removeshoppingorder';
      break;
    case EndPoint.SAVE_FINAL_ORDER:
      subUrl = 'savefinalshoppingorder';
      break;
    case EndPoint.SAVE_PAYMENT_INFO:
      subUrl = 'savepaymentinfo';
      break;
    case EndPoint.SAVE_ORDER:
      subUrl = 'saveshoppingorder';
      break;
    case EndPoint.CHANGE_PASSWORD:
      subUrl = 'sendchangedpasswordinfo';
      break;
    case EndPoint.ADD_FC_REQUEST:
      subUrl = 'sendfcrequest';
      break;
    case EndPoint.REQUEST_PASSWORD_CHANGE:
      subUrl = 'sendforgottenpasswordinfo';
      break;
    case EndPoint.LOG_IN:
      subUrl = 'sendlogininfo';
      break;
    case EndPoint.LOG_OUT:
      subUrl = 'sendlogoutinfo';
      break;
    case EndPoint.SEND_REGISTER_INFO:
      subUrl = 'sendregisterationinfo';
      break;
    case EndPoint.SEND_SHOPPING_CART:
      subUrl = 'sendshoppingcart';
      break;
    case EndPoint.SEND_VERIFICATION_CODE:
      subUrl = 'sendverificationcode';
      break;
    case EndPoint.GET_PRODUCT_OF_SELLER:
      subUrl = 'getproductsofseller';
      break;
    case EndPoint.SELLER_LOGIN:
      subUrl = 'sendsellerlogininfo';
      break;
    case EndPoint.ADD_SELLER_PRODUCT:
      subUrl = 'sendsellernewproduct';
      break;
    case EndPoint.GET_POST_TARIFF:
      subUrl = 'getpostcitytariff';
      break;
    case EndPoint.GET_CENTER_PICTURES:
      subUrl = 'getsrvcenterspicture';
      break;
    case EndPoint.SEND_CENTER_SCORE:
      subUrl = 'sendsrvcenterscore';
      break;
    case EndPoint.GET_PAID_ORDERS:
      subUrl = 'getpaidorders';
      break;
    case EndPoint.SEND_PRODUCT_SCORE:
      subUrl = 'sendprdsaleitemscore';
      break;
    case EndPoint.EDIT_SELLER_PRODUCT:
      subUrl = 'editproductofseller';
      break;
    case EndPoint.GET_COMMENTS:
      subUrl = 'getprdproductcomments';
      break;
    case EndPoint.SEND_COMMENT:
      subUrl = 'sendprdproductcomment';
      break;
    case EndPoint.SEND_USER_FCM_TOKEN:
      subUrl = 'updateuserfcmtoken';
      break;
    case EndPoint.GET_USER_PET:
      subUrl = 'getamlanimals';
      break;
    case EndPoint.SEND_USER_PET:
      subUrl = 'sendamlanimals';
      break;
    case EndPoint.EDIT_USER_PET:
      subUrl = 'editamlanimals';
      break;
    case EndPoint.DELETE_USER_PET:
      subUrl = 'deleteamlanimals';
      break;
    case EndPoint.SEND_SELLER_REQUEST:
      subUrl = 'sendnewsellerprofile';
      break;
    case EndPoint.START_CHAT:
      subUrl = 'startchat';
      break;
    case EndPoint.SEND_MESSAGE:
      subUrl = 'sendchat';
      break;
    case EndPoint.GET_ALL_CENTER_CHATS:
      subUrl = 'getsrvcenterallchats';
      break;
    case EndPoint.SEEN_CHAT:
      subUrl = 'setseen';
      break;
    case EndPoint.GET_CHAT_WITH:
      subUrl = 'getappuserchats';
      break;
    case EndPoint.GET_CONTACT_INFO:
      subUrl = 'getappusers';
      break;
    case EndPoint.SEND_MNG_FCM_TOKEN:
      subUrl = 'updatesellerfcmtoken';
      break;
    case EndPoint.GET_ALL_USER_CHATS:
      subUrl = 'getappuserallchats';
      break;
    case EndPoint.SAVE_TRANSACTION:
      subUrl = 'prdordersellertransaction';
      break;
    case EndPoint.SEND_COUPON:
      subUrl = 'sendcouponcode';
      break;
    case EndPoint.GET_IP:
      subUrl = 'temp';
      break;
    case EndPoint.GET_FAVORITES:
      subUrl = 'getappuserprdlike';
      break;
    case EndPoint.ADD_FAVORITE:
      subUrl = 'sendappuserprdlike';
      break;
    case EndPoint.DELETE_FAVORITE:
      subUrl = 'deleteappuserprdlike';
      break;

    case EndPoint.PAYMENT_FINAL_TRANSACTION:
      subUrl = 'formfinancialtransaction';
      break;

    case EndPoint.ORDER_PRODUCT_PACKED:
    // TODO: Handle this case.
      break;
    case EndPoint.ORDER_SENT:
    // TODO: Handle this case.
      break;
  }
  return subUrl;
}
