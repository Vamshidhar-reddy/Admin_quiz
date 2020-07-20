import 'package:admin_website/GroupA.dart';
import 'package:admin_website/model/state.dart';
import 'package:admin_website/selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news.dart';
class NewsGroup extends StatefulWidget {
  @override
  _NewsGroupState createState() => _NewsGroupState();
}

class _NewsGroupState extends State<NewsGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('News Group'), backgroundColor: Colors.red),
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
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Selection()));
        },
        child: ListView(
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
                    Provider.of<Params>(context, listen: false)
                        .onNewsTap("GroupA");
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new News()));
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
                    Provider.of<Params>(context, listen: false)
                        .onNewsTap("GroupB");

                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => News()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
