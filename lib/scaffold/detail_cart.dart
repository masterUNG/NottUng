import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/price_list_model.dart';
import 'package:nottung/models/product_all_model.dart';
import 'package:nottung/models/user_model.dart';

class DetailCart extends StatefulWidget {
  final UserModel userModel;
  DetailCart({Key key, this.userModel}) : super(key: key);

  @override
  _DetailCartState createState() => _DetailCartState();
}

class _DetailCartState extends State<DetailCart> {
  // Explicit
  UserModel myUserModel;

  List<PriceListModel> priceListSModels = List();
  List<PriceListModel> priceListMModels = List();
  List<PriceListModel> priceListLModels = List();

  List<ProductAllModel> productAllModels = List();
  List<Map<String, dynamic>> sMap = List();
  List<Map<String, dynamic>> mMap = List();
  List<Map<String, dynamic>> lMap = List();
  int amountCart = 0;
  String newQTY;

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
    setState(() {
      readCart();
    });
  }

  Future<void> readCart() async {
    clearArray();

    String memberId = myUserModel.id;
    String url =
        'http://ptnpharma.com/app/json_loadmycart.php?memberId=$memberId';

    Response response = await get(url);
    var result = json.decode(response.body);

    var cartList = result['cart'];

    for (var map in cartList) {
      ProductAllModel productAllModel = ProductAllModel.fromJson(map);

      Map<String, dynamic> priceListMap = map['price_list'];

      Map<String, dynamic> sizeSmap = priceListMap['s'];
      if (sizeSmap == null) {
        sMap.add({'lable': ''});
        PriceListModel priceListModel = PriceListModel.fromJson({'lable': ''});
        priceListSModels.add(priceListModel);
      } else {
        sMap.add(sizeSmap);
        PriceListModel priceListModel = PriceListModel.fromJson(sizeSmap);
        priceListSModels.add(priceListModel);
      }

      Map<String, dynamic> sizeMmap = priceListMap['m'];
      if (sizeMmap == null) {
        mMap.add({'lable': ''});
        PriceListModel priceListModel = PriceListModel.fromJson({'lable': ''});
        priceListMModels.add(priceListModel);
      } else {
        mMap.add(sizeMmap);
        PriceListModel priceListModel = PriceListModel.fromJson(sizeMmap);
        priceListMModels.add(priceListModel);
      }

      Map<String, dynamic> sizeLmap = priceListMap['l'];
      if (sizeLmap == null) {
        lMap.add({'lable': ''});
        PriceListModel priceListModel = PriceListModel.fromJson({'lable': ''});
        priceListLModels.add(priceListModel);
      } else {
        lMap.add(sizeLmap);
        PriceListModel priceListModel = PriceListModel.fromJson(sizeLmap);
        priceListLModels.add(priceListModel);
      }

      setState(() {
        amountCart++;
        productAllModels.add(productAllModel);
      });
    }
  }

  void clearArray() {
    productAllModels.clear();

    priceListSModels.clear();
    priceListMModels.clear();
    priceListLModels.clear();

    sMap.clear();
    mMap.clear();
    lMap.clear();
  }

  Widget showCart() {
    return Container(
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
    );
  }

  Widget showTitle(int index) {
    return Text(productAllModels[index].title);
  }

  Widget editButton(int index, String size) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        myAlertDialog(index, size);
      },
    );
  }

  Widget alertTitle() {
    return ListTile(
      leading: Icon(
        Icons.edit,
        size: 36.0,
      ),
      title: Text('Edit Cart'),
    );
  }

  Widget alertContent(int index, String size) {
    String quantity = '';
    if (size == 's') {
      quantity = priceListSModels[index].quantity;
      newQTY = quantity;
    } else if (size == 'm') {
      quantity = priceListMModels[index].quantity;
      newQTY = quantity;
    } else {
      quantity = priceListLModels[index].quantity;
      newQTY = quantity;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(productAllModels[index].title),
        Text('Size = $size'),
        Container(
          // color: Colors.grey,
          width: 30.0,
          child: TextFormField(
            onChanged: (String string) {
              newQTY = string.trim();
            },
            initialValue: quantity,
          ),
        ),
      ],
    );
  }

  void myAlertDialog(int index, String size) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: alertTitle(),
            content: alertContent(index, size),
            actions: <Widget>[
              cancelButton(),
              okButton(index, size),
            ],
          );
        });
  }

  Widget okButton(int index, String size) {
    String productID = productAllModels[index].id;
    String unitSize = size;
    String memberID = myUserModel.id;

    return FlatButton(
      child: Text('OK'),
      onPressed: () {
        print(
            'productID = $productID, unitSize = $unitSize, memberID = $memberID, newQTY = $newQTY');
        editDetailCart(productID, unitSize, memberID);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> editDetailCart(
      String productID, String unitSize, String memberID) async {
    String url =
        'http://ptnpharma.com/app/json_updatemycart.php?productID=$productID&unitSize=$unitSize&newQTY=$newQTY&memberID=$memberID';

    await get(url).then((response) {
      print('Edit OK');
      readCart();
    }).catchError((error) {
      print('error = $error');
    });
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget deleteButton(int index, String size) {
    return IconButton(
      icon: Icon(Icons.remove_circle_outline),
      onPressed: () {
        confirmDelete(index, size);
      },
    );
  }

  void confirmDelete(int index, String size) {
    String titleProduct = productAllModels[index].title;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Do You Want Delete $titleProduct'),
            actions: <Widget>[
              cancelButton(),
              confirmButton(index, size),
            ],
          );
        });
  }

  Widget confirmButton(int index, String size) {
    return FlatButton(
      child: Text('Confirm'),
      onPressed: () {
        deleteCart(index, size);
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> deleteCart(int index, String size) async {
    String productID = productAllModels[index].id;
    String unitSize = size;
    String memberID = myUserModel.id;
    print('productID = $productID, unitSize = $unitSize, memberID = $memberID');

    String url =
        'http://ptnpharma.com/app/json_removeitemincart.php?productID=$productID&unitSize=$unitSize&memberID=$memberID';

    await get(url).then((response) {
      readCart();
    });
  }

  Widget editAndDeleteButton(int index, String size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        editButton(index, size),
        deleteButton(index, size),
      ],
    );
  }

  Widget showSText(int index) {
    String price = sMap[index]['price'];
    String lable = sMap[index]['lable'];
    String quality = sMap[index]['quantity'];

    print('Qua ======>>>>>> $quality');

    return lable.isEmpty
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$price bth/$lable'),
              Text('Qua $quality'),
              editAndDeleteButton(index, 's'),
            ],
          );
  }

  Widget showMText(int index) {
    String price = mMap[index]['price'];
    String lable = mMap[index]['lable'];
    String quality = mMap[index]['quantity'];

    print('labelm = $lable');

    return lable.isEmpty
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$price bth/$lable'),
              Text('Qua $quality'),
              editAndDeleteButton(index, 'm'),
            ],
          );
  }

  Widget showLText(int index) {
    String price = lMap[index]['price'];
    String lable = lMap[index]['lable'];
    String quality = lMap[index]['quantity'];

    return lable.isEmpty
        ? SizedBox()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$price bth/$lable'),
              Text('Qua $quality'),
              editAndDeleteButton(index, 'l'),
            ],
          );
  }

  Widget showListCart() {
    return ListView.builder(
      itemCount: productAllModels.length,
      itemBuilder: (BuildContext buildContext, int index) {
        return Column(
          children: <Widget>[
            showTitle(index),
            showSText(index),
            showMText(index),
            showLText(index),
            Divider(),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Cart'),
      ),
      body: showListCart(),
    );
  }
}
