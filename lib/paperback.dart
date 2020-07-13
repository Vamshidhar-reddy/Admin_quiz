import 'dart:io';
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

class PaperBack extends StatefulWidget {
  DocumentSnapshot d;
  PaperBack({this.d});
  @override
  _PaperBackState createState() => _PaperBackState();
}

class _PaperBackState extends State<PaperBack> {
  DocumentSnapshot d;
  File sampleImage;
  String _myValue;
  String _description;
  String postUrl;
  String cardUrl;
  String _d;
  String _group;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<String> image = List<String>();
  Map<String, String> cover;

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

  @override
  void initState() {
    Map cover = {
      "_myValue": "postUrl",
      "_myValu": "postUrl",
    };
    super.initState();
    d = widget.d;
    print(" ${cover.values.toList()[1]}");
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef = FirebaseStorage.instance
          .ref()
          .child("PaperBacks/GroupA/${d.data["title"]}");

      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask = postImageRef
          .child(path.basenameWithoutExtension(sampleImage.path))
          .putFile(sampleImage);

      var PostUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      postUrl = PostUrl.toString();
      print("Post Url =" + postUrl);
      saveToDatabase(postUrl);
      getName();
      Navigator.of(context, rootNavigator: true).pop();
      //     context, MaterialPageRoute(builder: (context) => PaperBack()));
    }
  }

  void saveToDatabase(String url) {
    final ref = Firestore.instance.collection("GroupA");

    Map<String, dynamic> cover = d.data["Cover"];
    cover.putIfAbsent( _myValue,() => postUrl.toString() );
    d.data["Cover"].putIfAbsent(
      _myValue,() => postUrl.toString(),
    );
    var data = {"Cover": cover};
    ref.document("${d.data["title"]}").updateData(data);
  }

  getName() async {
    final db = Firestore.instance;
    DocumentSnapshot qs;
    qs = await Firestore.instance
        .collection("GroupA")
        .document(d.data["title"])
        .get();
    print("doc");
    setState(() {
      d = qs;
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Future getDisplayImage() async {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        sampleImage = tempImage;
      });
      enableUpload(context);
    }

    return new Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () { Navigator.pushReplacementNamed(context, "groupA");},
              child: Column(
        
          children: <Widget>[
            new Center(
                child: Padding(
              padding: EdgeInsets.all(50),
              child: Text(
                "Cover Images Screen",
                style: TextStyle(fontSize: 30.0),
              ),
            )),
            // FutureBuilder<List<DocumentSnapshot>>(
            //     future: getName(),
            //     builder: (context, snap) {
            //       if (snap.connectionState == ConnectionState.done) {
            //         print(snap.data.length);
            // return
            Expanded(
                        child: GridView.builder(
                scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                itemCount: d.data["Cover"].keys.toList().length,
                itemBuilder: (context, i) {
                  print("inside grid");

                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        print("navigating");

                        // Navigator.pushNamed(context, "cover",
                        //     arguments: snap.data);
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

                                        d.data["Cover"].values
                                            .toList()[i]
                                            .toString(),
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
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
                                  d.data["Cover"].keys.toList()[i].toString(),
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
            )

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

  enableUpload(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Material(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height - 200,
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
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.contain)),
                          ),
                        ],
                      ),
                      TextFormField(
                        decoration: new InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          return value.isEmpty ? 'Title is required' : null;
                        },
                        onSaved: (value) {
                          return _myValue = value;
                        },
                      ),
                      TextFormField(
                        decoration:
                            new InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          return value.isEmpty
                              ? 'Description is required'
                              : null;
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
                        onPressed: uploadStatusImage,
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
      ),
    );
  }
}
