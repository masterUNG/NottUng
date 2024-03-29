import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/product_all_model.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/detail.dart';
import 'package:nottung/scaffold/detail_cart.dart';
import 'package:nottung/utility/my_style.dart';

class ListProduct extends StatefulWidget {
  final int index;
  final UserModel userModel;

  ListProduct({Key key, this.index, this.userModel}) : super(key: key);

  @override
  _ListProductState createState() => _ListProductState();
}

// class
class Debouncer {
  // Explicit
  final int milliseconds;
  VoidCallback action;
  Timer timer;

  // Consturctor
  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (timer != null) {
      timer.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ListProductState extends State<ListProduct> {
  // Explicit
  int myIndex;
  List<ProductAllModel> productAllModels = List();
  List<ProductAllModel> filterProductAllModels = List();
  int amountListView = 6;
  ScrollController scrollController = ScrollController();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  bool statusStart = true;
  int amountCart = 0;
  UserModel myUserModel;

  // Method
  @override
  void initState() {
    super.initState();
    myIndex = widget.index;
    myUserModel = widget.userModel;

    createController();

    setState(() {
      readData();
      readCart();
    });
  }

  void createController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print('At the End');

        setState(() {
          amountListView = amountListView + 2;
          if (amountListView > filterProductAllModels.length) {
            amountListView = filterProductAllModels.length;
          }
        });
      }
    });
  }

  Future<void> readData() async {
    String url = MyStyle().readAllProduct;

    if (myIndex != 0) {
      url = '${MyStyle().readProductWhereMode}$myIndex';
    }

    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');

    var itemProducts = result['itemsProduct'];

    for (var map in itemProducts) {
      ProductAllModel productAllModel = ProductAllModel.fromJson(map);
      setState(() {
        productAllModels.add(productAllModel);
        filterProductAllModels = productAllModels;
      });
    }
  }

  Widget showName(int index) {
    return Text(filterProductAllModels[index].title);
  }

  Widget showStock(int index) {
    return Text(filterProductAllModels[index].stock);
  }

  Widget showText(int index) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.5,
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          showName(index),
          showStock(index),
        ],
      ),
    );
  }

  Widget showImage(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width * 0.5,
        child: Image.network(filterProductAllModels[index].photo),
      ),
    );
  }

  Widget showProductItem() {
    return Expanded(
      child: ListView.builder(
        controller: scrollController,
        itemCount: amountListView,
        itemBuilder: (BuildContext buildContext, int index) {
          return GestureDetector(
            child: Row(
              children: <Widget>[
                showImage(index),
                showText(index),
              ],
            ),
            onTap: () {
              MaterialPageRoute materialPageRoute =
                  MaterialPageRoute(builder: (BuildContext buildContext) {
                return Detail(
                  productAllModel: filterProductAllModels[index],
                  userModel: myUserModel,
                );
              });
              Navigator.of(context).push(materialPageRoute);
            },
          );
        },
      ),
    );
  }

  Widget showProgressIndicate() {
    return Center(
      child:
          statusStart ? CircularProgressIndicator() : Text('Search not Found'),
    );
  }

  // Widget myLayout() {
  //   return Column(
  //     children: <Widget>[
  //       searchForm(),
  //       showProductItem(),
  //     ],
  //   );
  // }

  Widget searchForm() {
    return Container(
      // color: Colors.grey,
      padding:
          EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
      child: TextField(
        decoration: InputDecoration(hintText: 'Search'),
        onChanged: (String string) {
          statusStart = false;
          debouncer.run(() {
            setState(() {
              filterProductAllModels =
                  productAllModels.where((ProductAllModel productAllModel) {
                return (productAllModel.title
                    .toLowerCase()
                    .contains(string.toLowerCase()));
              }).toList();
              amountListView = filterProductAllModels.length;
            });
          });
        },
      ),
    );
  }

  Widget showContent() {
    return filterProductAllModels.length == 0
        ? showProgressIndicate()
        : showProductItem();
  }

  Future<void> readCart() async {
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
    return GestureDetector(onTap: (){routeToDetailCart();},
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
        backgroundColor: MyStyle().textColor,
        actions: <Widget>[showCart()],
        title: Text('List Product'),
      ),
      // body: filterProductAllModels.length == 0
      //     ? showProgressIndicate()
      //     : myLayout(),
      body: Column(
        children: <Widget>[
          searchForm(),
          showContent(),
        ],
      ),
    );
  }
}
