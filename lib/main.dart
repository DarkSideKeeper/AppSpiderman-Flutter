import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/result.dart';
import 'result.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var client = http.Client();

  List<Spider>? items = [];
  List<Spider>? filterItems = [];

  TextEditingController textEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (items!.isEmpty) {
      callApi();
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: CircularProgressIndicator()
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: textEdit,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'input',
                      ),
                    ),
                  ),
                  MaterialButton(
                    minWidth: 32,
                    onPressed: () {
                      String searchValue = textEdit.text;
                      filterItems = items?.where((i) => i.name.toLowerCase().contains(searchValue)).toList();
                      setState(() {
                        
                      });
                    },
                    child: const Text("Search"),
                  )
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filterItems!.length,
                  itemBuilder: (context, index) {
                    String title = filterItems![index].name;
                    return ListTile(
                      title: Text(title),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ResultView(resultSpider: filterItems![index])),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void callApi() {
    client
        .get(Uri.parse(
            "https://gateway.marvel.com/v1/public/characters?nameStartsWith=spider-man&apikey=b5c6cdc04250b4541d07403317c93445&ts=2010&hash=5b131b2233c0103b25ea4d17a46a1044"))
        .then((response) {
      return response.body;
    }).then((bodyString) {
      Map<String, dynamic> json = jsonDecode(bodyString);
      for (var result in json["data"]["results"]) {
        items?.add(Spider.fromJson(result));
      }
      setState(() {});
    });
  }
}

class Spider {
  final String name;
  final String thumbnail;
  final String description;

  Spider(this.name, this.thumbnail, this.description);

  Spider.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        thumbnail = json['thumbnail']["path"] + "." + json['thumbnail']["extension"],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': thumbnail,
        'description': description,
      };
}
