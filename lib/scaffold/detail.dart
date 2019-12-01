import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/product_all_model.dart';
import 'package:nottung/models/unit_size_model.dart';
import 'package:nottung/utility/my_style.dart';
import 'package:nottung/utility/normal_dialog.dart';

class Detail extends StatefulWidget {
  final ProductAllModel productAllModel;
  Detail({Key key, this.productAllModel}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // Explicit
  ProductAllModel currentProductAllModel;
  ProductAllModel productAllModel;
  List<UnitSizeModel> unitSizeModels = List();
  List<int> amounts = [
    0,
    0,
    0
  ]; //amounts[0] -> s, amounts[1] -> m,amounts[2] -> l

  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    getProductWhereID();
  }

  Future<void> getProductWhereID() async {
    if (currentProductAllModel != null) {
      String id = currentProductAllModel.id;
      String url = '${MyStyle().getProductWhereId}$id';
      Response response = await get(url);
      var result = json.decode(response.body);
      print('result = $result');

      var itemProducts = result['itemsProduct'];
      for (var map in itemProducts) {
        print('map = $map');

        setState(() {
          productAllModel = ProductAllModel.fromJson(map);

          Map<String, dynamic> priceListMap = map['price_list'];
          print('priceListMap = $priceListMap');

          Map<String, dynamic> sizeSmap = priceListMap['s'];
          print('sizeSmap = $sizeSmap');
          if (sizeSmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeSmap);
            unitSizeModels.add(unitSizeModel);
          }

          Map<String, dynamic> sizeMmap = priceListMap['m'];
          print('sizeSmap = $sizeMmap');
          if (sizeMmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeMmap);
            unitSizeModels.add(unitSizeModel);
          }

          Map<String, dynamic> sizeLmap = priceListMap['l'];
          print('sizeSmap = $sizeLmap');
          if (sizeLmap != null) {
            UnitSizeModel unitSizeModel = UnitSizeModel.fromJson(sizeLmap);
            unitSizeModels.add(unitSizeModel);
          }

          print('unitSizeModel label = ${unitSizeModels[0].lable}');
        });
      } // for
    }
  }

  Widget showImage() {
    return Container(
      height: 180.0,
      child: Image.network(productAllModel.photo),
    );
  }

  Widget showTitle() {
    return Text(productAllModel.title);
  }

  Widget showDetail() {
    return Text(productAllModel.detail);
  }

  Widget showPackage(int index) {
    return Text(unitSizeModels[index].lable);
  }

  Widget showPricePackage(int index) {
    return Text('${unitSizeModels[index].price} BHT / ');
  }

  Widget showChoosePricePackage(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        showDetailPrice(index),
        incDecValue(index),
      ],
    );
  }

  Widget showDetailPrice(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showPricePackage(index),
        showPackage(index),
      ],
    );
  }

  Widget decButton(int index) {
    int value = amounts[index];

    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      onPressed: () {
        print('dec index = $index');

        if (value == 0) {
          normalDialog(context, 'Cannot Decrease', 'Because Empty Cart');
        } else {
          setState(() {
            value--;
            amounts[index] = value;
          });
        }
      },
    );
  }

  Widget incButton(int index) {
    int value = amounts[index];

    return IconButton(
      icon: Icon(Icons.add_circle_outline),
      onPressed: () {
        setState(() {
          print('inc index = $index');
          value++;
          amounts[index] = value;
        });
      },
    );
  }

  Widget showValue(int value) {
    return Text('$value');
  }

  Widget incDecValue(int index) {
    int value = amounts[index];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        decButton(index),
        showValue(value),
        incButton(index),
      ],
    );
  }

  Widget showPrice() {
    return Container(
      // color: Colors.grey,
      height: 150.0,
      child: ListView.builder(
        itemCount: unitSizeModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return showChoosePricePackage(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: productAllModel == null ? showProgress() : showDetailList(),
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showDetailList() {
    return ListView(
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        showImage(),
        showTitle(),
        showDetail(),
        showPrice(),
      ],
    );
  }
}
