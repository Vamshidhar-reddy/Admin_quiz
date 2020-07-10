import 'package:admin_website/uploadData.dart';
import 'package:flutter/material.dart';
import 'package:admin_website/group.dart';
class Selection extends StatefulWidget {
  @override
  _SelectionState createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selection'), backgroundColor: Colors.red),
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
            color: Colors.blue,
            height: 200.0,
            width: 100.0,
            child: ListTile(
                title: Center(
                    child: Text(
                  'News',
                  style: TextStyle(fontSize: 50.0),
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new UploadData()));
                }),
          ),
          Padding(padding: EdgeInsets.all(15.0)),
          Container(
            color: Colors.green,
            height: 200.0,
            width: 100.0,
            child: ListTile(
                title: Center(
                    child: Text(
                  'Paperback',
                  style: TextStyle(fontSize: 50.0),
                )),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new Group()));
                }),
          ),
        ],
      ),
    );
  }
}
