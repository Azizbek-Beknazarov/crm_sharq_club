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
    return DefaultTabController(length: 4, child: Scaffold(
      appBar: AppBar(title: Text('Service'),
      bottom: TabBar(tabs: [
        Tab(text: 'Cars',),
        Tab(text: 'Club',),
        Tab(text: 'Photo',),
        Tab(text: 'Album',),
      ],),),
      body: TabBarView(children: [
        Center(child: Text('Cars'),),
        Center(child: Text('Club'),),
        Center(child: Text('Photo'),),
        Center(child: Text('Album'),),
      ],),
    ));
  }
}
