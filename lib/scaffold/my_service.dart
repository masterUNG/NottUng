import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/result_code.dart';
import 'package:nottung/utility/my_style.dart';
import 'package:nottung/widget/contact.dart';
import 'package:nottung/widget/home.dart';

class MyService extends StatefulWidget {
  final UserModel userModel;
  MyService({Key key, this.userModel}) : super(key: key);

  @override
  _MyServiceState createState() => _MyServiceState();
}

class _MyServiceState extends State<MyService> {
  // Explicit
  UserModel myUserModel;
  Widget currentWidget = Home();
  String qrString;
  

  // Method
  @override
  void initState() {
    super.initState();
    myUserModel = widget.userModel;
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
          currentWidget = Home();
        });
        Navigator.of(context).pop();
      },
    );
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

  Future<void> readQRcode()async{

    try {

      qrString = await BarcodeScanner.scan();

      print('QR code = $qrString');

      if (qrString != null) {

        MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext buildContext){return ResultCode(result: qrString,);});
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
          menuContace(),menuReadQRcode(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: MyStyle().textColor,
        title: Text('My Service'),
      ),
      body: currentWidget,
      drawer: showDrawer(),
    );
  }
}
