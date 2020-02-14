import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:store/common/constants.dart';

class CreateProductRepository {
  Future<bool> sendNewProduct(
    File image,
    String name,
    int brandId,
    String variantCode,
    String properties,
    int colorId,
    String description,
    int sellerId,
    int shippingTime,
    int originalPrice,
    int salePrice,
    int maximumOrder,
    int stockQuantity,
  ) async {
    /*final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    new Directory(path).create(recursive: true)
    // The created directory is returned as a Future.
        .then((Directory directory) {
      print(directory.path);
    });

    final File newImage = await image.copy('$path/image1.jpg');*/
    var request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            '${AppUrls.base_url}/epet24-upload/public/api/sendnewproductbyseller'));
    print('image path:' + image.path);

    var rng = new Random();
    var code = rng.nextInt(1000);

    request.fields['product_score'] = '3';
    request.fields['product_brand'] = brandId.toString();
    request.fields['is_active'] = '1';
    request.fields['product_title_fa'] = name;
    request.fields['variant_code'] = variantCode;
    request.fields['properties'] = properties;
    request.fields['prd_colors_id'] = colorId.toString();
    request.fields['variant_description'] = description;
    request.fields['seller_id'] = sellerId.toString();
    request.fields['shipment_time'] = shippingTime.toString();
    request.fields['guaranty_id'] = '1';
    request.fields['main_price'] = originalPrice.toString();
    request.fields['sale_price'] = salePrice.toString();
    request.fields['sale_discount'] = (originalPrice - salePrice).toString();
    request.fields['maximum_orderable'] = maximumOrder.toString();
    request.fields['is_bounded'] = '1';
    request.fields['stock_quantity'] = stockQuantity.toString();
    request.fields['sale_description'] = description;
    request.fields['description'] = description;
    request.fields['is_exist'] = '1';
    request.fields['tag_id'] = '1';
    request.fields['tag_is_active'] = '1';
    request.fields['product_code'] = 'user_created_product_$code';
    request.files.add(await http.MultipartFile.fromPath(
      'product_main_image',
      /*'$path/image1.jpg'*/ image.path,
    ));

    print(request.fields.toString());

    print(request.toString());

    request.send().then((response) async {
      final resStr = await response.stream.bytesToString();
      print('making new products response: ' + resStr);
    }).catchError((err) => print('err: ' + err));
  }
}
