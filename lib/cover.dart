import 'dart:io';
import 'package:admin_website/paperback.dart';
import 'package:admin_website/variable.dart';
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

import 'model/state.dart';

class Cover extends StatefulWidget {
  @override
  _CoverState createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  String folder, topicKey;
  DocumentSnapshot d;
  int topicIndex;
  File sampleImage;
  int _myValue;
  String postUrl;
  String _d;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<dynamic> cover = [];

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

  void uploadStatusImage(BuildContext context) async {
    if (validateAndSave()) {
      print("this is doc id $folder");
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("${folder}");
      final StorageUploadTask uploadTask =
          postImageRef.child("c$_myValue-$_d").putFile(sampleImage);

      var PostUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      postUrl = PostUrl.toString();
      print("Post Url =" + postUrl);
      saveToDatabase(postUrl);
      getName(context);
      setState(() {
        sampleImage = null;
      });
      //     context, MaterialPageRoute(builder: (context) => PaperBack()));
    }
  }

  void saveToDatabase(String url) {
    final ref = Firestore.instance.collection("GroupA");

    Map<String, dynamic> Topic = d.data["Topic"];
    Topic.update("$topicKey", (e) {
      cover = e;
      if (e == null) {
        cover = List<String>();
        cover.add(postUrl);
      } else
        cover.insert(_myValue, postUrl);

      return cover;
    }); //0 is id 1 is name 2 is link
    // d.data["Topic"].putIfAbsent(
    //   "$_myValue-$_description-$postUrl.toString()",
    //   () => cover,
    // );
    var data = {"Topic": Topic};
    ref.document("${d.documentID}").updateData(data);
  }

  getName(BuildContext contex) async {
    final db = Firestore.instance;
    DocumentSnapshot qs;
    qs = await Firestore.instance
        .collection("${grpName}")
        .document(d.documentID)
        .get();
    print("doc");

    d = qs;
    Provider.of<Params>(contex, listen: false).updateDoc(d);
  }

  @override
  Widget build(BuildContext context) {
    d = Provider.of<Params>(context).docSnap;
    grpName = Provider.of<Params>(context).grpName;
    topicIndex = Provider.of<Params>(context).topicIndex;

    folder = Provider.of<Params>(context).folder;
    topicKey = Provider.of<Params>(context).topicKey;
    Future getDisplayImage() async {
      var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        sampleImage = tempImage;
      });
    }

    // print(" ${d.data["Topic"].values.toList()[topicIndex][0]}");
    return new Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => PaperBack()));
        },
        child: Column(
          children: <Widget>[
            new Center(
                child: sampleImage == null
                    ? Padding(
                        padding: EdgeInsets.all(50),
                        child: Text(
                          "$grpName\n${d.documentID} - ${d.data["title"]}\nTopic-$topicIndex - ${d.data["Topic"].keys.toList()[topicIndex].split('??')[1]}\n Cover Images Screen",
                          style: TextStyle(fontSize: 30.0),
                        ), 
                      )
                    : enableUpload(context)),

            // FutureBuilder<List<DocumentSnapshot>>(
            //     future: getName(),topicIndex
            //     builder: (context, snap) {
            //       if (snap.connectionState == ConnectionState.done) {
            //         print(snap.data.length);
            // return
            Consumer<Params>(builder: (context, cons, _) {
              d = cons.docSnap ?? d;
              return Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  itemCount: d.data["Topic"].values.toList()[topicIndex] == null
                      ? 0
                      : d.data["Topic"].values.toList()[topicIndex].length ?? 0,
                  itemBuilder: (context, i) {
                    print("inside grid");
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          print("navigating");

                          // Navigator.pushNamed(context, "Topic",
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
                                          d.data["Topic"].values
                                              .toList()[topicIndex][i]
                                              .toString(),
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
                              
                                child: Text("Cover $i\n ${d.data["Topic"].values.toList()[topicIndex][i].split(RegExp(r'(%2F)..*(%2F)'))[1].split(".")[0]}"
,
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
  }

  Widget enableUpload(BuildContext context) {
    return Dialog(
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
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(labelText: 'Cover No'),
                      validator: (value) {
                        return value.isEmpty ? 'Cover No is required' : null;
                      },
                      onSaved: (value) {
                        return _myValue = int.parse(value);
                      },
                    ),
                    TextFormField(
                      decoration:
                          new InputDecoration(labelText: 'Cover Image Name'),
                      validator: (value) {
                        return value.isEmpty
                            ? 'Cover Image Name is required'
                            : null;
                      },
                      onSaved: (value) {
                        return _d = value;
                      },
                    ),
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
