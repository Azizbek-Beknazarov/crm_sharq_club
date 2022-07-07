import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({Key? key}) : super(key: key);

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5
        ),
        child: Container(child: Column(children: [],),),
      ),
    );
  }
}
