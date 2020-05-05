import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:store/common/constants.dart';
import 'package:store/common/widgets/app_widgets.dart';
import 'package:store/common/widgets/form_fields.dart';
import 'package:store/data_layer/brands/brands_repository.dart';
import 'package:store/data_layer/management/create_product_repo.dart';
import 'package:store/store/structure/model.dart';
import 'package:store/store/structure/structure_selection_widget.dart';

import '../model.dart';

class CreateProductPage extends StatefulWidget {
  static const String routeName = 'createproduct';

  final ShopIdentifier shop;

  CreateProductPage({@required this.shop});

  @override
  _CreateProductPageState createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameFaCtrl = TextEditingController();
  final TextEditingController nameEnCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController unitCtrl = TextEditingController(text: 'کیلوگرم');
  final TextEditingController originalPriceCtrl = TextEditingController();
  final TextEditingController salePriceCtrl = TextEditingController();
  final TextEditingController stockQuantityCtrl = TextEditingController();
  final TextEditingController maximumOrderCtrl = TextEditingController();
  final TextEditingController shippingTimeCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController sizeCtrl = TextEditingController();
  final TextEditingController colorCtrl = TextEditingController();

  final BehaviorSubject<File> imageStream = BehaviorSubject();
  final BehaviorSubject<Brand> brandStream = BehaviorSubject.seeded(null);
  final BehaviorSubject<Identifier> categoryStream =
      BehaviorSubject.seeded(NAIdentifier());
  final BehaviorSubject<bool> validateCategories =
      BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> showImageError = BehaviorSubject.seeded(false);

  Widget _structureSelectionWidget;

  _CreateProductPageState() {
    _structureSelectionWidget = StructureSelectionRow(
      categoryStream.add,
      required: validateCategories,
    );
  }

  final List<Brand> allBrands = [];

  @override
  void dispose() {
    brandStream.close();
    imageStream.close();
    categoryStream.close();
    validateCategories.close();
    showImageError.close();
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
      appBar: CustomAppBar(
        altMainColor: true,
        titleText: 'ثبت کالای جدید',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: _structureSelectionWidget,
              ),
              FormFields.text('عنوان فارسی', nameFaCtrl, noBorder: true),
              FormFields.text('عنوان انگلیسی', nameEnCtrl, noBorder: true),
              Container(
                child: StreamBuilder<List<Brand>>(
                  stream: Provider.of<BrandsRepository>(context)
                      .fetch()
                      .asBroadcastStream(),
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
                            height: 60,
                            margin: EdgeInsets.symmetric(
                                horizontal: 9, vertical: 9),
                            child: DropdownButton<Brand>(
                              itemHeight: 60,
                              underline: Container(),
                              isExpanded: true,
                              hint: Text("برند"),
                              value: snapshot.data,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.grey[900], fontSize: 14),
                              onChanged: brandStream.add,
                              items: brandsToShow
                                  .map<DropdownMenuItem<Brand>>((Brand value) {
                                return DropdownMenuItem<Brand>(
                                  value: value,
                                  child: Text(
                                      value == null ? "برند" : value.nameFa),
                                );
                              }).toList(),
                            ));
                      },
                    );
                  },
                ),
              ),
              Divider(),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: FormFields.text('وزن محصول', weightCtrl,
                        noBorder: true),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                      child: DropdownButtonFormField<String>(
//                        key: _formKey,
                          onChanged: (newValue) {
                            unitCtrl.text = newValue;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              labelText: 'واحد اندازه گیری وزن'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'این فیلد نباید خالی باشد';
                            }
                            return null;
                          },
                          value: unitCtrl.value.text,
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
                    ),
                  ),
                ],
              ),
              Container(
                child:
                    FormFields.text('سایز (اختیاری)', sizeCtrl, noBorder: true),
              ),
              Container(
                  child: FormFields.text('رنگ (اختیاری)', colorCtrl,
                      noBorder: true)),
              FormFields.text('توضیحات (اختیاری)', descriptionCtrl,
                  noBorder: true),
              FormFields.text('قیمت اصلی بدون تخفیف ', originalPriceCtrl,
                  noBorder: true),
              FormFields.text('قیمت فروش ', salePriceCtrl, noBorder: true),
              FormFields.text('زمان تحویل (ساعت) ', shippingTimeCtrl,
                  noBorder: true),
              FormFields.text(
                  'حداکثر تعداد قابل سفارش توسط مشتری ', maximumOrderCtrl,
                  noBorder: true),
              FormFields.text(
                  'عداد قابل فروش در سایت (کالایی که در صورت فروش باید موجود باشد) ',
                  stockQuantityCtrl,
                  noBorder: true),
              Container(
                color: Colors.grey[100],
                height: 100,
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
              StreamBuilder(
                stream: showImageError,
                builder: (context, snapshot) {
                  return snapshot.data != null && snapshot.data
                      ? Container(
                          padding: EdgeInsets.only(right: 10, top: 6),
                          child: Text(
                            'عکس محصول را انتخاب کنید',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Container();
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 13.0, horizontal: 40),
                child: RaisedButton(
                  color: AppColors.main_color,
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false
                    // otherwise.

                    var identifier = categoryStream.value;
                    print(identifier.toString());

                    if (imageStream.value == null) {
                      showImageError.add(true);
                    } else {
                      showImageError.add(false);
                    }

                    if (_formKey.currentState.validate() &&
                        identifier is StructSubCategory &&
                        imageStream.value != null) {
                      validateCategories.add(true);

                      int unitNo;
                      switch (unitCtrl.text) {
                        case 'کیلوگرم':
                          unitNo = 2;
                          break;
                        case 'گرم':
                          unitNo = 1;
                          break;
                        case 'بسته':
                          unitNo = 3;
                          break;
                      }

                      var success = await CreateProductRepository()
                          .sendNewProduct(
                              imageStream.value,
                              nameFaCtrl.text,
                              brandStream.value.id,
                              'variantCode',
                              'prop',
                              1,
                              descriptionCtrl.text,
                              int.parse(weightCtrl.text),
                              unitNo,
                              widget.shop.id,
                              int.parse(shippingTimeCtrl.text),
                              int.parse(originalPriceCtrl.text),
                              int.parse(salePriceCtrl.text),
                              int.parse(maximumOrderCtrl.text),
                              int.parse(stockQuantityCtrl.text),
                              identifier.petId,
                              identifier.catId,
                              identifier.id);
                      if (success) {
                        Helpers.showToast('محصول شما ثبت شد');
                        Navigator.of(context).pop();
                      } else {
                        Helpers.showErrorToast();
                      }
                    }
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
      ),
    );
  }
}
