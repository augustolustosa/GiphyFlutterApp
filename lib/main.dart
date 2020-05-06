
import 'package:flutter/material.dart';
import 'package:flutterapp4/ui/home_page.dart';

void main()=>runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App giphy",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData.dark(),

    );
  }
}
