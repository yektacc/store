import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/data_layer/brands/brands_repository.dart';
import 'package:store/data_layer/shop_management/create_product_repo.dart';
import 'package:store/data_layer/shop_management/shop_repository.dart';

class CreateProductPage extends StatefulWidget {
  static const String routeName = 'createproduct';

  final ShopIdentifier shop;

  CreateProductPage({@required this.shop});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final BehaviorSubject<String> nameFaStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> nameEnStream = BehaviorSubject.seeded('');
  final BehaviorSubject<Brand> brandStream = BehaviorSubject.seeded(null);
  final BehaviorSubject<String> descriptionStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> unitStream = BehaviorSubject.seeded('کیلوگرم');
  final BehaviorSubject<String> originalPriceStream =
      BehaviorSubject.seeded('');
  final BehaviorSubject<String> salePriceStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> stockQuantityStream =
      BehaviorSubject.seeded('');
  final BehaviorSubject<String> maximumOrderStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> shippingTimeStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> weightStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> sizeStream = BehaviorSubject.seeded('');
  final BehaviorSubject<String> colorStream = BehaviorSubject.seeded('');
  final BehaviorSubject<File> imageStream = BehaviorSubject();

  final List<Brand> allBrands = [];

  @override
  void dispose() {
    nameFaStream.close();
    nameEnStream.close();
    brandStream.close();
    descriptionStream.close();
    unitStream.close();
    originalPriceStream.close();
    salePriceStream.close();
    stockQuantityStream.close();
    maximumOrderStream.close();
    stockQuantityStream.close();
    shippingTimeStream.close();
    weightStream.close();
    sizeStream.close();
    colorStream.close();
    imageStream.close();
    super.dispose();
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageStream.add(image);
  }

  Future getImageCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    imageStream.add(image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ثبت کالای جدید'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: nameFaStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'عنوان فارسی'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: nameEnStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'عنوان انگلیسی'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            StreamBuilder<List<Brand>>(
              stream: Provider.of<BrandsRepository>(context).fetch(),
              builder: (context, allBrandsSnp) {
                List<Brand> brandsToShow;

                if (allBrands.isNotEmpty) {
                  brandsToShow = allBrands;
                } else if (allBrandsSnp != null &&
                    allBrandsSnp.data != null &&
                    allBrandsSnp.data.isNotEmpty) {
                  brandsToShow = allBrandsSnp.data;
                  allBrands.addAll(allBrandsSnp.data);
                } else {
                  brandsToShow = [];
                }

                return StreamBuilder<Brand>(
                  stream: brandStream,
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                      child: DropdownButtonFormField<Brand>(
                        onChanged: brandStream.add,
                        decoration: InputDecoration(labelText: 'برند '),
                        value: snapshot.data,
                        validator: (value) {
                          if (value == null) {
                            return 'این فیلد نباید خالی باشد';
                          }
                          return null;
                        },
                        items: brandsToShow
                            .map<DropdownMenuItem<Brand>>(
                                (br) => DropdownMenuItem<Brand>(
                                      child: Text(br.nameFa),
                                      value: br,
                                    ))
                            .toList(),
                      ),
                    );
                  },
                );
              },
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: weightStream.add,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(labelText: 'وزن محصول'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'این فیلد نباید خالی باشد';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: new StreamBuilder<String>(
                    stream: unitStream,
                    builder: (context, snapshot) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                        child: DropdownButtonFormField<String>(
                            onChanged: unitStream.add,
                            decoration: InputDecoration(
                                labelText: 'واحد اندازه گیری وزن'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'این فیلد نباید خالی باشد';
                              }
                              return null;
                            },
                            value: snapshot.data,
                            items: <DropdownMenuItem<String>>[
                              DropdownMenuItem(
                                child: Text('کیلوگرم'),
                                value: 'کیلوگرم',
                              ),
                              DropdownMenuItem(
                                child: Text('گرم'),
                                value: 'گرم',
                              )
                            ]),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: sizeStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'سایز (اختیاری)'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: colorStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'رنگ (اختیاری)'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: descriptionStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'توضیحات (اختیاری) '),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: originalPriceStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'قیمت اصلی '),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: salePriceStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'قیمت فروش '),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: shippingTimeStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'زمان تحویل (ساعت) '),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: maximumOrderStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'حداکثر سفارش '),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
              child: TextFormField(
                onChanged: stockQuantityStream.add,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(labelText: 'تعداد موجودی '),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'این فیلد نباید خالی باشد';
                  }
                  return null;
                },
              ),
            ),
            Container(
              color: Colors.grey[100],
              height: 160,
              padding: EdgeInsets.only(bottom: 20, top: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      height: 70,
                      child: FlatButton(
                          color: Colors.white,
                          onPressed: () {
                            getImageCamera();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'گرفتن عکس',
                                style: TextStyle(fontSize: 10),
                              ),
                              Icon(Icons.camera_alt)
                            ],
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 7),
                      height: 70,
                      child: FlatButton(
                          color: Colors.white,
                          onPressed: () {
                            getImageGallery();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                'از گالری',
                                style: TextStyle(fontSize: 10),
                              ),
                              Icon(Icons.attach_file)
                            ],
                          )),
                    ),
                  ),
                  StreamBuilder<File>(
                    stream: imageStream,
                    builder: (context, snapshot) {
                      return Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: snapshot.data != null
                                ? Image.file(snapshot.data)
                                : Container(),
                          ));
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40),
              child: RaisedButton(
                color: AppColors.main_color,
                onPressed: () async {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
/*                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }*/

                  await CreateProductRepository().sendNewProduct(
                      imageStream.value,
                      nameFaStream.value,
                      brandStream.value.id,
                      'variantCode',
                      'prop',
                      1,
                      descriptionStream.value,
                      widget.shop.sellerId,
                      int.parse(shippingTimeStream.value),
                      int.parse(originalPriceStream.value),
                      int.parse(salePriceStream.value),
                      int.parse(maximumOrderStream.value),
                      int.parse(stockQuantityStream.value));
                },
                child: Text(
                  'ثبت اطلاعات',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
