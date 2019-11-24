import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit

  // Method
  @override
  void initState(){
    super.initState();

  }

  Future<void> readPromotion()async{
    String url = 'http://ptnpharma.com/app/json_promotion.php';

  }


  Widget promotion() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
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
