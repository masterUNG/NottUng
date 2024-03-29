import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/product_all_model.dart';
import 'package:nottung/models/unit_size_model.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/detail_cart.dart';
import 'package:nottung/utility/my_style.dart';
import 'package:nottung/utility/normal_dialog.dart';

class Detail extends StatefulWidget {
  final ProductAllModel productAllModel;
  final UserModel userModel;

  Detail({Key key, this.productAllModel, this.userModel}) : super(key: key);

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
  int amountCart = 0;
  UserModel myUserModel;
  String id;

  /// ==> productID

  // Method
  @override
  void initState() {
    super.initState();
    currentProductAllModel = widget.productAllModel;
    myUserModel = widget.userModel;
    setState(() {
      getProductWhereID();
      readCart();
    });
  }

  Future<void> getProductWhereID() async {
    if (currentProductAllModel != null) {
      id = currentProductAllModel.id;
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

  Future<void> readCart() async {
    amountCart = 0;
    String memberId = myUserModel.id;
    String url =
        'http://ptnpharma.com/app/json_loadmycart.php?memberId=$memberId';

    Response response = await get(url);
    var result = json.decode(response.body);

    var cartList = result['cart'];
    for (var map in cartList) {
      setState(() {
        amountCart++;
      });
    }
  }

  Widget showCart() {
    return GestureDetector(
      onTap: () {
        routeToDetailCart();
      },
      child: Container(
        margin: EdgeInsets.only(top: 4.0, right: 4.0),
        width: 36.0,
        height: 36.0,
        child: Stack(
          children: <Widget>[
            Image.asset('images/shopping_cart.png'),
            Text(
              '$amountCart',
              style: TextStyle(
                backgroundColor: Colors.yellow,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void routeToDetailCart() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return DetailCart(
        userModel: myUserModel,
      );
    });
    Navigator.of(context).push(materialPageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[showCart()],
        backgroundColor: MyStyle().textColor,
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

  Widget addButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                color: MyStyle().textColor,
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  String productID = id;
                  String memberID = myUserModel.id;

                  int index = 0;
                  List<bool> status = List();
                  for (var object in unitSizeModels) {
                    if (amounts[index] == 0) {
                      status.add(true);
                    } else {
                      status.add(false);
                    }

                    index++;
                  }
                  bool sumStatus; //True ==> Alert, False Upload
                  if (status.length == 1) {
                    sumStatus = status[0];
                  } else if (status.length == 2) {
                    sumStatus = status[0] && status[1];
                  }

                  if (sumStatus) {
                    normalDialog(
                        context, 'Do Not Choose Item', 'Please Choose Item');
                  } else {
                    int index = 0;
                    for (var object in unitSizeModels) {
                      String unitSize = unitSizeModels[index].unit;
                      int qTY = amounts[index];

                      print(
                          'priductID = $productID, memberID = $memberID, unitSize = $unitSize , QTY = $qTY,');

                      if (qTY != 0) {
                        addCart(productID, unitSize, qTY, memberID);
                      }

                      index++;
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addCart(
      String productID, String unitSize, int qTY, String memberID) async {
    String url =
        'http://ptnpharma.com/app/json_savemycart.php?productID=$productID&unitSize=$unitSize&QTY=$qTY&memberID=$memberID';

    Response response = await get(url).then((response) {
      print('upload OK');
      readCart();
      MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext buildContext){return DetailCart(userModel: myUserModel,);});
      Navigator.of(context).push(materialPageRoute);

    });
  }

  Widget showDetailList() {
    return Stack(
      children: <Widget>[
        showControler(),
        addButton(),
      ],
    );
  }

  ListView showControler() {
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
