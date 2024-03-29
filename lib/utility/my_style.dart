import 'package:flutter/material.dart';

class MyStyle {
  double h1 = 24.0, h2 = 18.0;
  Color textColor = Color.fromARGB(0xff, 0x00, 0x4c, 0x8c);
  Color mainColor = Color.fromARGB(0xff, 0x02, 0x77, 0xbd);

  String fontName = 'Pacifico';

  // For Server
  String readAllProduct = 'http://ptnpharma.com/app/json_product.php';
  String readProductWhereMode =  'http://ptnpharma.com/app/json_product.php?product_mode=';
  String getUserWhereUserAndPass = 'http://ptnpharma.com/app/json_login_get.php';
  String getProductWhereId = 'http://ptnpharma.com/app/json_productdetail.php?id=';

  MyStyle();
}
