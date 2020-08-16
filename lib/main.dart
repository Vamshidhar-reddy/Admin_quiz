import 'package:admin_website/group.dart';
import 'package:admin_website/paperback.dart';
import 'package:admin_website/selection.dart';
import 'package:admin_website/uploadData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'groupA.dart';
import 'login.dart';

bool jwt = false;

void main() {
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    jwt = await prefs.getBool("login");
    print(jwt);

// place();
    // SharedPreferences store = await SharedPreferences.getInstance();
    // store.("jwt");

    // print('jwt ${jwt}');
    runApp(MyApp());
  }
  // runApp(MyApp());
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
        'cover': (BuildContext context) => PaperBack(),
        'groupA': (BuildContext context) => GroupA(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(),
      // home: jwt == null ? Selection() : Login(), // home:GroupA()
    );
  }
}
