import 'package:admin_website/group.dart';
import 'package:admin_website/paperback.dart';
import 'package:admin_website/selection.dart';
import 'package:admin_website/uploadData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'groupA.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  //     .then((_){
  // runApp(MyApp());
  //     });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Login(),
        'upload': (BuildContext context) => UploadData(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: Login(),
      home:GroupA()
    );
  }
}
