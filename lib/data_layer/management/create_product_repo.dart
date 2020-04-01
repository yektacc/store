import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:store/common/constants.dart';

class CreateProductRepository {
  Future<bool> sendNewProduct(File image,
      String name,
      int brandId,
      String variantCode,
      String properties,
      int colorId,
      String description,
      int weight,
      int weightUnit,
      int sellerId,
      int shippingTime,
      int originalPrice,
      int salePrice,
      int maximumOrder,
      int stockQuantity,
      int baseCatId,
      int subCatId,
      int typeId,) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse('${AppUrls.alt_api_url}sendnewproductbyseller'));
    print('image path:' + image.path);

//    var rng = new Random();
//    var code = rng.nextInt(1000);

    request.fields['product_score'] = '3';
    request.fields['type'] = 'app';
    request.fields['product_brand'] = brandId.toString();
    request.fields['is_active'] = '1';
    request.fields['product_title_fa'] = name;
    request.fields['variant_code'] = variantCode;
    request.fields['properties'] = properties;
    request.fields['prd_colors_id'] = colorId.toString();
    request.fields['variant_description'] = '1';
    request.fields['seller_id'] = sellerId.toString();
    request.fields['shipment_time'] = shippingTime.toString();
    request.fields['guaranty_id'] = '1';
    request.fields['main_price'] = originalPrice.toString();
    request.fields['sale_price'] = salePrice.toString();
    request.fields['sale_discount'] = (originalPrice - salePrice).toString();
    request.fields['maximum_orderable'] = maximumOrder.toString();
    request.fields['is_bounded'] = '1';
    request.fields['stock_quantity'] = stockQuantity.toString();
    request.fields['sale_description'] = '1';
    request.fields['product_description'] = '1';
    request.fields['product_weight'] = weight.toString();
    request.fields['weight_unit'] = weightUnit.toString();
    request.fields['type_id'] = '';
    request.fields['is_exist'] = '1';
    request.fields['tag_id'] = '1';
    request.fields['tag_is_active'] = '1';
//    request.fields['product_code'] = 'user_created_product_$code';
    request.fields['basecategory_id'] = baseCatId.toString();
    request.fields['subcategory_id'] = subCatId.toString();
    request.fields['type_id'] = typeId.toString();
    request.files.add(await http.MultipartFile.fromPath(
      'product_main_image',
      image.path,
    ));

    print(request.fields.toString());

    print(request.toString());

    try {
      var response = request.send();
      final res = await response
          .asStream()
          .first;
      String resStr = await res.stream.bytesToString();
      print('final:' + resStr);
      Map<String, dynamic> json = jsonDecode(resStr);

      var apiStatus = json['api_status'];
      print('Create new products response: $resStr \n api status: $apiStatus');
      if (apiStatus == 1) {
        return true;
      } else {
        return false;
      }
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
      return false;
    }
  }
}
