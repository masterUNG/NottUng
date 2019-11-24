import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/promote_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit
  // List<PromoteModel> promoteModels = List();
  List<Widget> promoteLists = List();

  // Method
  @override
  void initState() {
    super.initState();
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
        promoteLists.add(Image.network(urlImage));
      });
    }
  }

  Widget myCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget promotion() {
    return Container(padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      height: MediaQuery.of(context).size.height * 0.25,
      child: promoteLists.length == 0
          ? myCircularProgress()
          : CarouselSlider(
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              pauseAutoPlayOnTouch: Duration(seconds: 5),
              autoPlay: true,
              autoPlayAnimationDuration: Duration(seconds: 5),
              items: promoteLists,
            ),
    );
  }

  Widget suggest() {
    return Container(
      color: Colors.grey.shade400,
      height: MediaQuery.of(context).size.height * 0.25,
    );
  }

  Widget category() {
    return Container(
      color: Colors.grey.shade600,
      height: MediaQuery.of(context).size.height * 0.5 - 81,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          promotion(),
          suggest(),
          category(),
        ],
      ),
    );
  }
}
