import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './home_page.dart';

void main() async {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CryptoPro',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: defaultTargetPlatform == TargetPlatform.iOS
            ? Colors.grey[100]
            : null),
      home: new HomePage(),
    );
  }
}
