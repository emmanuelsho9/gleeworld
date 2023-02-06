import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Book.dart';

class SProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   var d = Provider.of<List<Book>>(context);
    return Scaffold(
      body: Container(
        child: ListView.builder(itemCount: d.length,itemBuilder: (context, index) {
          return Text(d[index].age);
        },),
      ),
    );
  }
}