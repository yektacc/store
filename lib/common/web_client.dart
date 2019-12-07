/*
import 'dart:collection';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:store/common/log/log.dart';
import 'package:store/store/petstore/pet_store.dart';
import 'package:store/store/products/filter/filter.dart';
import 'package:store/store/products/product/product.dart';
import 'package:store/store/structure/model.dart';
import 'package:quiver/core.dart';

abstract class WebRequest extends Equatable {}

abstract class WebResponse extends Equatable {}

class PropTypes {
  static PropType brand() => PropType(1, "brand");
}

class WebClient {
  final Map<WebRequest, WebResponse> _cache = HashMap();

  Stream<WebResponse> handleRequest(WebRequest request) {
    Nik.e(request.toString());
    if (_cache.containsKey(request)) {
      return Stream.fromFuture(Future.value(_cache[request]));
    } else {
      if (request is ProductReq) {
        return _handleProductsRequest(request);
      } else if (request is StructureReq) {
        return _handleStructureRequest(request);
      } else {
        return Stream.fromFuture(Future.value(FailedRes(ResError.BAD_REQUEST)));
      }
    }
  }

*/
/*  Stream<ProductRes> _handleProductsRequest(ProductReq req) async* {

  }*//*


  Stream<StructureRes> _handleStructureRequest(StructureReq req) async* {
    var res = await http
        .post('http://51.254.65.54/epet24/public/api/getcategorystructure');
    String body = res.body;

    var jsonBody = json.decode(body)['data'];



    yield StructureRes(pets);
  }

  Stream<StructureRes> _handleProductDetailRequest(StructureReq req) async* {
    var res = await http
        .post('http://51.254.65.54/epet24/public/api/getcategorystructure');
    String body = res.body;

    var jsonBody = json.decode(body)['data'];

    List<Map<String, dynamic>> list =
        new List<Map<String, dynamic>>.from(jsonBody);

    List<StructPet> pets = list.map((p) => StructPet.fromJson(p)).toList();

    yield StructureRes(pets);
  }
}

// request and response classes
enum ResError { NO_INTERNET, BAD_REQUEST, UNKNOWN }

class FailedRes extends WebResponse {
  final ResError err;

  FailedRes(this.err);
}


*/
