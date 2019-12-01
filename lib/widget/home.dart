import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/promote_model.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/list_product.dart';

class Home extends StatefulWidget {
  final UserModel userModel;
  Home({Key key, this.userModel}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit

  List<Widget> promoteLists = List();
  List<String> urlImages = List();

  int amountCart = 0;
  UserModel myUserModel;

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel=widget.userModel;
    readPromotion();
  }

  Future<void> readPromotion() async {
    String url = 'http://ptnpharma.com/app/json_promotion.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    var mapItemProduct = result['itemsProduct'];

    for (var map in mapItemProduct) {
      PromoteModel promoteModel = PromoteModel.fromJson(map);
      String urlImage = promoteModel.photo;
      setState(() {
        // promoteModels.add(promoteModel);
        promoteLists.add(
          GestureDetector(
            child: Container(
              child: Image.network(urlImage),
            ),
            onTap: () {
              print('You Click ${promoteModel.title}');
            },
          ),
        );
        urlImages.add(urlImage);
      });
    }
  }

  Widget myCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget showCarouseSlider() {
    return CarouselSlider(
      enlargeCenterPage: true,
      aspectRatio: 16 / 9,
      pauseAutoPlayOnTouch: Duration(seconds: 5),
      autoPlay: true,
      autoPlayAnimationDuration: Duration(seconds: 5),
      items: promoteLists,
      // items: <Widget>[],
    );
  }

  Widget promotion() {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      height: MediaQuery.of(context).size.height * 0.25,
      child:
          promoteLists.length == 0 ? myCircularProgress() : showCarouseSlider(),
    );
  }

  Widget suggest() {
    return Container(
      // color: Colors.grey.shade400,
      height: MediaQuery.of(context).size.height * 0.25,
      child:
          promoteLists.length == 0 ? myCircularProgress() : showCarouseSlider(),
    );
  }

  void routeToListProduct(int index) {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return ListProduct(
        index: index,userModel: myUserModel,
      );
    });
    Navigator.of(context).push(materialPageRoute);
  }

  Widget topLeft() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.purple,
          child: Container(
            alignment: Alignment(0.0, 0.0),
            child: Text(
              'TopLeft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onTap: () {
          print('You Click Me');
          routeToListProduct(0);
        },
      ),
    );
  }

  Widget topRight() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.pink,
          child: Container(
            alignment: Alignment(0.0, 0.0),
            child: Text(
              'TopRight',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onTap: () {
          print('You Click Me');
          routeToListProduct(1);
        },
      ),
    );
  }

  Widget bottomLeft() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.green,
          child: Container(
            alignment: Alignment(0.0, 0.0),
            child: Text(
              'BottomLeft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onTap: () {
          print('You Click Me');
          routeToListProduct(2);
        },
      ),
    );
  }

  Widget bottomRight() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 80.0,
      child: GestureDetector(
        child: Card(
          color: Colors.brown,
          child: Container(
            alignment: Alignment(0.0, 0.0),
            child: Text(
              'BottomRight',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        onTap: () {
          print('You Click Me');
          routeToListProduct(3);
        },
      ),
    );
  }

  Widget topMenu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        topLeft(),
        topRight(),
      ],
    );
  }

  Widget bottomMenu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        bottomLeft(),
        bottomRight(),
      ],
    );
  }

  Widget homeMenu() {
    return Container(
      alignment: Alignment(0.0, 0.0),
      // color: Colors.blue.shade600,
      height: MediaQuery.of(context).size.height * 0.5 - 81,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          topMenu(),
          bottomMenu(),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          promotion(),
          suggest(),
          homeMenu(),
        ],
      ),
    );
  }
}
