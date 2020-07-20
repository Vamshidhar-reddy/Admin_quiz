import 'dart:io';
import 'package:admin_website/model/state.dart';
import 'package:admin_website/paperback.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'cover.dart';

class PaperBack extends StatefulWidget {
  @override
  _PaperBackState createState() => _PaperBackState();
}

class _PaperBackState extends State<PaperBack> {
  String grpName;
  DocumentSnapshot d;
  File sampleImage;
  int _myValue;
  String _docId;
  String _description;
  String postUrl;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, String> Topic;
  List<String> cover = [];

  var url;

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  // @override
  // void initState() {
  //   grpName = widget.wchGrp;

  //   super.initState();
  //   d = widget.d;
  //   // print(" ${cover.values.toList()[1]}");
  // }

  void uploadStatusImage(BuildContext context) async {
    if (validateAndSave()) {
      print("this is doc id");
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("$grpName/${d.documentID}");

      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child("T$_myValue-$_description").putFile(sampleImage);

      var PostUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      postUrl = PostUrl.toString();
      print("Post Url =" + postUrl);
      saveToDatabase(postUrl);
      getName(context);
      setState(() {
        sampleImage = null;
      });
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => PaperBack()));
    }
  }

  void saveToDatabase(String url) {
    final ref = Firestore.instance.collection("$grpName");
    print(grpName);
    Map<String, dynamic> Topic = d.data["Topic"];

    Topic.putIfAbsent("$_myValue??$_description??$postUrl",
        () => cover); //0 is id 1 is name 2 is link
    // d.data["Topic"].putIfAbsent(
    //   "$_myValue-$_description-$postUrl.toString()",
    //   () => cover,
    // );
    var data = {"Topic": Topic};
    ref.document(d.documentID).updateData(data);
  }

  getName(BuildContext context) async {
    final db = Firestore.instance;
    DocumentSnapshot qs;
    qs = await Firestore.instance
        .collection(grpName)
        .document(d.documentID)
        .get();
    print("doc");
    // print(d.data["Topic"].keys.toList()[0]);
    print("get name function end");

    // setState(() {
    d = qs;
    Provider.of<Params>(context, listen: false).updateDoc(d);

    // });
    // });
    return d;
  }

  @override
  Widget build(BuildContext context) {
    grpName = Provider.of<Params>(context).grpName;
    d = Provider.of<Params>(context).docSnap;
    Future getDisplayImage() async {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        sampleImage = tempImage;
      });
      // enableUpload(context);
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, "groupA");
        },
        child: Column(
          children: <Widget>[
            new Center(
                child: sampleImage == null
                    ? Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(
                          "$grpName ${d.documentID} Topic Images Screen",
                          style: TextStyle(fontSize: 30.0),
                        ),
                      )
                    : enableUpload(context)),
            // FutureBuilder(
            //     future: getName(),
            //     builder: (context, snap) {
            //       if (snap.connectionState == ConnectionState.done) {
            //         return
            Consumer<Params>(builder: (context, obj, _) {
              d = obj.docSnap ?? d;
              return Expanded(
                child: GridView.builder(
                  // reverse: true,
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  itemCount: d.data["Topic"].keys.toList().length,
                  itemBuilder: (context, i) {
                    print("inside grid");
                    // print(d.data["Topic"].keys.toList()[i].split('??')[i]);
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          print("navigating");
                          Provider.of<Params>(context, listen: false).topicTap(
                              '''$grpName/${d.documentID}/T${d.data["Topic"].keys.toList()[i].split('??')[0]}-${d.data["Topic"].keys.toList()[i].split('??')[1]}''',
                              d.data["Topic"].keys.toList()[i],
                              i);
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              print(grpName);
                              return Cover();
                            },
                          ));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 4.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: GridTile(
                                    // child:
                                    //  Hero(
                                    //   tag: i,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          // "http://via.placeholder.com/350x200",

                                          d.data["Topic"].keys
                                              .toList()[i]
                                              .split('??')[2],
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator()),
                                      errorWidget: (_, str, dynamic) => Center(
                                        child: Icon(Icons.error),
                                      ),
                                    ),
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                                child: Text(
                                    "Topic " +
                                        d.data["Topic"].keys
                                            .toList()[i]
                                            .split('??')[0] +
                                        "\n" +
                                        d.data["Topic"].keys
                                            .toList()[i]
                                            .split('??')[1],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)))
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                ),
              );
            })
            //     ;
            //   }

            //   if (snap.connectionState == ConnectionState.waiting) {
            //     return Center(child: CircularProgressIndicator());
            //   }
            // })
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
        onPressed: getDisplayImage,
      ),
    );
    // return Container(
    //     color: Colors.amber,
    //     child: Center(
    //       child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             sampleImage == null
    //                 ? RaisedButton(
    //                     onPressed: getDisplayImage,
    //                     child: Text(
    //                       "Make A Post",
    //                       style: TextStyle(fontSize: 40),
    //                       textAlign: TextAlign.center,
    //                     ))
    //                 : enableUpload(),
    //           ]),
    //     ));
  }

  Widget enableUpload(BuildContext contex) {
    return Dialog(
      child: SingleChildScrollView(
        child: Center(
          child: Container(
              margin: EdgeInsets.only(top: 40),
              width: MediaQuery.of(contex).size.width * 0.8,
              height: MediaQuery.of(contex).size.height - 200,
              child: new Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Image.file(sampleImage,
                                  height: 250, width: 150, fit: BoxFit.fill)),
                        ),
                      ],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(labelText: 'Topic No'),
                      validator: (value) {
                        return value.isEmpty ? 'Topic No is required' : null;
                      },
                      onSaved: (value) {
                        return _myValue = int.parse(value);
                      },
                    ),
                    TextFormField(
                      decoration: new InputDecoration(labelText: 'Topic Name'),
                      validator: (value) {
                        return value.isEmpty ? 'Topic Name is required' : null;
                      },
                      onSaved: (value) {
                        return _description = value;
                      },
                    ),
                    // TextFormField(
                    //   decoration: new InputDecoration(labelText: 'd'),
                    //   validator: (value) {
                    //     return value.isEmpty ? 'd is required' : null;
                    //   },
                    //   onSaved: (value) {
                    //     return _d = value;
                    //   },
                    // ),
                    SizedBox(height: 15.0),
                    RaisedButton(
                      color: Colors.black,
                      onPressed: () => uploadStatusImage(context),
                      elevation: 4.0,
                      splashColor: Colors.blueGrey,
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
