import 'dart:convert';
import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/detail_cart.dart';
import 'package:nottung/scaffold/result_code.dart';
import 'package:nottung/utility/my_style.dart';
import 'package:nottung/widget/contact.dart';
import 'package:nottung/widget/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyService extends StatefulWidget {
  final UserModel userModel;
  MyService({Key key, this.userModel}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Explicit
  UserModel myUserModel;
  Widget currentWidget;
  String qrString;
  int amountCart = 0;

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
      myUserModel = widget.userModel;
      currentWidget = Home(
        userModel: myUserModel,
      );
    });
    readCart();
  }

  Widget menuHome() {
    return ListTile(
      leading: Icon(
        Icons.home,
        size: 36.0,
      ),
      title: Text('Home'),
      subtitle: Text('Description Home'),
      onTap: () {
        setState(() {
          readCart();
          currentWidget = Home(
            userModel: myUserModel,
          );
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuLogOut() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
      ),
      title: Text('Log Out and Exit'),
      subtitle: Text('Log Out and Exit'),
      onTap: () {
        logOut();
      },
    );
  }

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    exit(0);
  }

  Widget menuContace() {
    return ListTile(
      leading: Icon(
        Icons.filter_2,
        size: 36.0,
      ),
      title: Text('Contact'),
      subtitle: Text('Description Contact'),
      onTap: () {
        setState(() {
          currentWidget = Contact();
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget menuReadQRcode() {
    return ListTile(
      leading: Icon(
        Icons.photo_camera,
        size: 36.0,
      ),
      title: Text('Read QR code'),
      subtitle: Text('Description Read QR code or Bar code'),
      onTap: () {
        readQRcode();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> readQRcode() async {
    try {
      qrString = await BarcodeScanner.scan();

      print('QR code = $qrString');

      if (qrString != null) {
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buildContext) {
          return ResultCode(
            result: qrString,
          );
        });
        Navigator.of(context).push(materialPageRoute);
      }
    } catch (e) {
      print('e = $e');
    }
  }

  Widget showAppName() {
    return Text('Nott Ung');
  }

  Widget showLogin() {
    String login = myUserModel.name;
    if (login == null) {
      login = '...';
    }
    return Text('Login by $login');
  }

  Widget showLogo() {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget headDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showLogo(),
          showAppName(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          headDrawer(),
          menuHome(),
          menuContace(),
          menuReadQRcode(),
          menuLogOut(),
        ],
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
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
