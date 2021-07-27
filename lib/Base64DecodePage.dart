import 'dart:convert' as convert;
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:base64_encode_decode/AppConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Base64Decoder.dart';


class Base64DecodePage extends StatefulWidget {
  const Base64DecodePage({Key? key}) : super(key: key);

  @override
  _Base64DecodePageState createState() => _Base64DecodePageState();
}

class _Base64DecodePageState extends State<Base64DecodePage> {
  html.TextAreaElement decodedTextAreaElement = html.TextAreaElement();
  html.TextAreaElement textAreaElement = html.TextAreaElement();
  html.FileUploadInputElement fileUploadInputElement = html.FileUploadInputElement();

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Base64 Decode', style: TextStyle(color: textColor, fontSize: 40, fontWeight: FontWeight.bold)),
              Divider(),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Enter the text to Base64 Decode',
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            decodedTextAreaElement.value = null;
                            textAreaElement.value = null;
                          },
                          icon: Icon(Icons.refresh,color: accentIconColor,)),
                      IconButton(
                          onPressed: () {
                            decodedTextAreaElement.select();
                            html.document.execCommand("copy");
                          },
                          icon: Icon(Icons.copy,color: accentIconColor,))
                    ],
                  ),
                ],
              ),
              Container(
                  height: 300,
                  child: HtmlElementView(viewType: decodedTextAreaElement.name)),
              Padding(padding: EdgeInsets.all(20)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        height: 50,
                        color: buttonColor,
                        onPressed: () async {
                          if (decodedTextAreaElement.value != null && decodedTextAreaElement.value!.trim().isNotEmpty)
                            textAreaElement.value =
                                await Base64Decoder.decodeBase64ToText(decodedTextAreaElement.value!.trim())
                                    .catchError((error) {});
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cached,
                              color: Colors.white,
                            ),
                            Text(
                              "Base64 Decode",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: accentTextColor)),
                        child: MaterialButton(
                          height: 50,
                          color: Colors.white,
                          onPressed: () async {
                            html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                            uploadInput.click();

                            uploadInput.onChange.listen((event) {
                              html.File file = uploadInput.files!.first;
                              html.FileReader reader = html.FileReader();
                              reader.readAsText(file);

                              reader.onLoadEnd.listen((event) {}).onData((data) async {
                                print('onLoadEnd');
                                 decodedTextAreaElement.value = reader.result.toString();
                                textAreaElement.value =
                                    await Base64Decoder.decodeBase64ToText(decodedTextAreaElement.value!)
                                        .catchError((error) {});
                              });
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.upload,
                                color: accentTextColor,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                "File Upload",
                                style: TextStyle(color: accentTextColor, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  StreamBuilder<String>(
                      stream: Base64Decoder.resultStream.stream,
                      builder: (context, snapshot) {
                         if (snapshot.hasError)
                          return Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: errorTextColor),
                          );
                        return Container(
                          height: 1,
                          width: 1,
                        );
                      }),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Output Text', style: TextStyle(color: textColor, fontSize: 18),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            textAreaElement.select();
                            html.document.execCommand("copy");
                          },
                          icon: Icon(Icons.copy,color: accentIconColor,))
                    ],
                  ),
                ],
              ),
              Container(
                  height: 300,
                  child: HtmlElementView(viewType: textAreaElement.name)),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: accentTextColor)),
                  child: MaterialButton(
                    height: 50,
                    color: Colors.white,
                    onPressed: () async {
                      if(textAreaElement.value!=null)
                      html.AnchorElement()
                        ..href = '${Uri.dataFromString(textAreaElement.value!, mimeType: 'text/plain', encoding: convert.utf8)}'
                        ..download = 'base64-decode-navoki.com.txt'
                        ..style.display = 'none'
                        ..click();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_download_sharp,
                          color: accentTextColor,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Text(
                          "Download",
                          style: TextStyle(color: accentTextColor, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void init() {
    decodedTextAreaElement = html.TextAreaElement()
      ..required = true;
    decodedTextAreaElement.placeholder = 'Enter base64 Encoded data';
    decodedTextAreaElement.name = 'decoded-text-area';

    textAreaElement = html.TextAreaElement()
      ..required = true ;
    textAreaElement.placeholder = 'Decoded data';
    textAreaElement.name = 'text-area';

    fileUploadInputElement.name = 'file-upload';

    ui.platformViewRegistry.registerViewFactory(decodedTextAreaElement.name, (int id) => decodedTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(textAreaElement.name, (int id) => textAreaElement);
    ui.platformViewRegistry.registerViewFactory(fileUploadInputElement.name!, (int id) => fileUploadInputElement);
  }
}
