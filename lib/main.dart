import 'package:admin_website/group.dart';
import 'package:admin_website/model/state.dart';
import 'package:admin_website/paperback.dart';
import 'package:admin_website/selection.dart';
import 'package:admin_website/news.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'groupA.dart';
import 'login.dart';

bool jwt;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  jwt = await prefs.getBool("login");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Params>(
        create: (context) => Params(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/login': (BuildContext context) => Login(),
              'news': (BuildContext context) => News(),
              'cover': (BuildContext context) => PaperBack(),
              'groupA': (BuildContext context) => GroupA(),
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: jwt != null ? Selection() : Login()));
  }
}
