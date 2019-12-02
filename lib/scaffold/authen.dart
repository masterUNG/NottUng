import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nottung/models/user_model.dart';
import 'package:nottung/scaffold/my_service.dart';
import 'package:nottung/utility/my_style.dart';
import 'package:nottung/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  // Explicit
  String user, password;
  final formKey = GlobalKey<FormState>();
  UserModel userModel;
  bool remember = false; //false ==> unCheck, true ==> Check

  // Method
  @override
  void initState() { 
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin()async{

    try {

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      user = sharedPreferences.getString('User');
      password = sharedPreferences.getString('Password');

      if (user != null) {
        checkAuthen();
      }
      
    } catch (e) {
    }

  }

  Widget rememberCheckBox() {
    return Container(
      width: 250.0,
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          'Remember Me',
          style: TextStyle(color: MyStyle().textColor),
        ),
        value: remember,
        onChanged: (bool value) {
          setState(() {
            remember = value;
          });
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: 250.0,
      child: OutlineButton(
        child: Text(
          'Login',
          style: TextStyle(color: MyStyle().textColor),
        ),
        onPressed: () {
          formKey.currentState.save();
          print('user = $user, password = $password');
          checkAuthen();
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    if (user.isEmpty || password.isEmpty) {
      // Have Space
      normalDialog(context, 'Have Space', 'Please Fill All Blank');
    } else {
      // No Space
      String url =
          '${MyStyle().getUserWhereUserAndPass}?username=$user&password=$password';
      Response response = await get(url);
      var result = json.decode(response.body);
      print('result = $result');

      int statusInt = result['status'];
      print('status = $statusInt');

      if (statusInt == 0) {
        String message = result['message'];
        normalDialog(context, 'Login False', message);
      } else {
        Map<String, dynamic> map = result['data'];
        print('map = $map');
        userModel = UserModel.fromJson(map);

        if (remember) {
          saveSharePreferance();
        }else{
          routeToMyService();
        }

        
      }
    } // if1
  }

  Future<void> saveSharePreferance()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('User', user);
    sharedPreferences.setString('Password', password);

    routeToMyService();

  }

  void routeToMyService() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) {
      return MyService(
        userModel: userModel,
      );
    });
    Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
        (Route<dynamic> route) {
      return false;
    });
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextFormField(
        // initialValue: 'nott',
        onSaved: (String string) {
          user = string.trim();
        },
        decoration: InputDecoration(
          labelText: 'User :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget passwordForm() {
    return Container(
      width: 250.0,
      child: TextFormField(
        // initialValue: '123456789',
        onSaved: (String string) {
          password = string.trim();
        },
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'Nott Ung',
      style: TextStyle(
        fontSize: MyStyle().h1,
        color: MyStyle().textColor,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        fontFamily: MyStyle().fontName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, MyStyle().mainColor],
              radius: 1.3,
              center: Alignment(0.0, -0.3),
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    showLogo(),
                    showAppName(),
                    userForm(),
                    passwordForm(),
                    rememberCheckBox(),
                    loginButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
