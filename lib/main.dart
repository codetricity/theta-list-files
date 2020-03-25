import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:textfield/prettier.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String message = "row";
  String responseText = "";


  Future<http.Response> getTestData () async {
    var url = 'https://jsonplaceholder.typicode.com/users';

    var response = await http.get(url);
    debugPrint(response.body);
    setState(() {
      responseText = response.body.toString();
      return responseText;
    });
  }

  Future<http.Response> listFiles () async {
    var listUrl = 'http://192.168.1.1/osc/commands/execute';

    Map data = {
      'name': 'camera.listFiles',
      'parameters': {
        'fileType': 'all',
        'entryCount': 12,
        'maxThumbSize': 0
      }
    };

    var body = jsonEncode(data);
    var response = await http.post(
      listUrl,
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: body
    );

    setState(() {
//      responseText = prettyPrint(response.body.toString());
    responseText = response.body.toString();
    });
    return response;
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('RICOH THETA List Images'),
        ),
        body: Column(
          children: <Widget>[
            FloatingActionButton.extended(
              label: Text('List Files'),
              onPressed: (() {
                listFiles();
                setState(() {
                  message = "Listing RICOH THETA Files";
                });

                print("pressed button");
              }),
            ),
            FloatingActionButton.extended(
              label: Text('Test Data'),
              backgroundColor: Colors.red,
              onPressed: (() {
                getTestData();
                setState(() {
                  message = "showing test data";
                });
              }
              ),

            ),
            Text('$message'),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Text('$responseText',
                style: TextStyle(
                  fontSize: 18,
                ),),
              )
            )
          ],
        )
      )
    );
  }
}
