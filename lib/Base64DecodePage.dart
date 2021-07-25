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
  html.TextAreaElement encodedTextAreaElement = html.TextAreaElement();
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
              Text('Base64 Decode', style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
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
                            encodedTextAreaElement.value = null;
                            textAreaElement.value = null;
                          },
                          icon: Icon(Icons.refresh)),
                      IconButton(
                          onPressed: () {
                            textAreaElement.select();
                            html.document.execCommand("copy");
                          },
                          icon: Icon(Icons.copy))
                    ],
                  ),
                ],
              ),
              Container(
                  height: 300,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: HtmlElementView(viewType: encodedTextAreaElement.name)),
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
                          if (encodedTextAreaElement.value != null && encodedTextAreaElement.value!.trim().isNotEmpty)
                            textAreaElement.text =
                                await Base64Decoder.decodeBase64ToText(encodedTextAreaElement.value!.trim())
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
                                 encodedTextAreaElement.value = reader.result.toString();
                                textAreaElement.text =
                                    await Base64Decoder.decodeBase64ToText(encodedTextAreaElement.value!)
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
                          icon: Icon(Icons.copy))
                    ],
                  ),
                ],
              ),
              Container(
                  height: 300,
                  decoration: BoxDecoration(border: Border.all(width: 1)),
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
    encodedTextAreaElement = html.TextAreaElement()
      ..required = true
      ..style.border = 'none';
    encodedTextAreaElement.placeholder = 'Enter base64 Encoded data';
    encodedTextAreaElement.name = 'encoded-text-area';
    encodedTextAreaElement.style.fontFamily = 'Open sans';
    encodedTextAreaElement.style.fontSize = '16px';

    textAreaElement = html.TextAreaElement()
      ..required = true
      ..style.border = 'none';
    textAreaElement.placeholder = 'Decoded data';
    textAreaElement.name = 'text-area';
    textAreaElement.style.fontFamily = 'Open sans';
    textAreaElement.style.fontSize = '16px';

    fileUploadInputElement.name = 'file-upload';

    ui.platformViewRegistry.registerViewFactory(encodedTextAreaElement.name, (int id) => encodedTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(textAreaElement.name, (int id) => textAreaElement);
    ui.platformViewRegistry.registerViewFactory(fileUploadInputElement.name!, (int id) => fileUploadInputElement);
  }
}
