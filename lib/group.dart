import 'package:admin_website/GroupA.dart';
import 'package:admin_website/groupB.dart';
import 'package:flutter/material.dart';
import 'GroupA.dart';
import 'groupB.dart';

class Group extends StatefulWidget {
  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Paperback'), backgroundColor: Colors.red),
      backgroundColor: Colors.white,
      // body: GridView.count(
      //   crossAxisCount: 2,
      //   children: List.generate(1, (index) {
      //     return Container(
      //       height: 100.0,
      //       padding: EdgeInsets.fromLTRB(30.0,60.0,15.0,30.0),
      //       child: Card(
      //         color: Colors.green,
      //         child: Center(child: Text('News')),
      //       ),
      //     );
      //   }),

      // ),

      // body: Row(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      //     children: <Widget>[
      //       SizedBox(
      //         height: 100,
      //         width: 100,

      //           child: InkWell(

      //             onTap: () {
      //             Navigator.push(
      //                 context,
      //                 new MaterialPageRoute(
      //                     builder: (context) => new UploadData()));
      //           }),
      //         ),
      //         // child: OutlineButton(
      //         //   onPressed: (){
      //         //   Navigator.push(context,
      //         //   new MaterialPageRoute(builder: (context) => new UploadData()));
      //         // }),

      //     ]),
      body: ListView(
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Container(
            color: Colors.tealAccent,
            height: 200.0,
            width: 100.0,
            child: ListTile(
                title: Center(
                    child: Text(
                  'Group A',
                  style: TextStyle(fontSize: 50.0),
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new GroupA()));
                }),
          ),
          Padding(padding: EdgeInsets.all(15.0)),
          Container(
            color: Colors.indigo,
            height: 200.0,
            width: 100.0,
            child: ListTile(
                title: Center(
                    child: Text(
                  'Group B',
                  style: TextStyle(fontSize: 50.0),
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new GroupB()));
                }),
          ),
        ],
      ),
    );
  }
}
