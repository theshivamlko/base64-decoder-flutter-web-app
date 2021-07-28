import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'AppConstant.dart';
import 'Base64DecodePage.dart';
import 'Error404Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: 'Base64 Decoder | Navoki.com',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),
      //   home: html.document.domain!.isNotEmpty
     home: html.document.domain==domain
          ? Base64DecodePage()
          : HtmlElementView(viewType: ErrorPage.create().tagName),
    );
  }
}
