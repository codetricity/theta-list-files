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
  String responseText = "Lorem ipsum dolor sit amet, consectetur "
  "adipiscing elit, sed do eiusmod tempor incididunt "
  "ut labore et dolore magna aliqua. Ut enim ad minim veniam, "
  "quis nostrud exercitation ullamco laboris nisi ut aliquip "
  "ex ea commodo consequat. Duis aute irure dolor in reprehenderit "
  "in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
  "Excepteur sint occaecat cupidatat non proident, sunt in "
  "culpa qui officia deserunt mollit anim id est laborum.";


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
      responseText = prettyPrint(response.body.toString());

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
                  message = "blue was pressed last";
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
                  message = "red was pressed last";
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
