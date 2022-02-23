import 'package:flutter/material.dart';

import 'main.dart';

class ResultView extends StatelessWidget {
  const ResultView({Key? key, required this.resultSpider}) : super(key: key);

  final Spider resultSpider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Marvel Finder"),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(child: Image.network(resultSpider.thumbnail)),
                Text(resultSpider.name),
              ],
            ),
            Text(resultSpider.description)
          ],
        ),
      ),
    );
  }
}
