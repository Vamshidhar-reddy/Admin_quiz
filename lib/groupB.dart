import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class GroupB extends StatefulWidget {
  @override
  _GroupBState createState() => _GroupBState();
}

class _GroupBState extends State<GroupB> {
  File sampleImage;
  String _myValue;
  String _description;
  String postUrl;
  String cardUrl;
  String _category;
  String _group;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future getDisplayImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadStatusImage() async {
    if (validateAndSave()) {
      final StorageReference postImageRef =
          FirebaseStorage.instance.ref().child("PaperBacks/GroupB/");

      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".png").putFile(sampleImage);

      var PostUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      postUrl = PostUrl.toString();
      print("Post Url =" + postUrl);
      saveToDatabase(postUrl);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GroupB()));
    }
  }

  void saveToDatabase(String url) {
    var dbTimeKey = new DateTime.now();
    var formatDate = new DateFormat('MMM d, yyyy');
    var formatTime = new DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "postImage": postUrl,
      "title": _myValue,
      "date": date,
      "time": time,
      "description": _description,
      "category": _category,
    };
    ref.child("PaperBacks/GroupB/").push().set(data);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.deepOrange[200],
      body: new Center(
        child: sampleImage == null
            ? Text(
                "Select an Image",
                style: TextStyle(fontSize: 50.0),
              )
            : enableUpload(),
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

  Widget enableUpload() {
    return Dialog(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          child: new Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Center(
                        child: Image.file(sampleImage,
                            height: 200, width: 150, fit: BoxFit.contain)),
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
                  decoration: new InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    return value.isEmpty ? 'Description is required' : null;
                  },
                  onSaved: (value) {
                    return _description = value;
                  },
                ),
                TextFormField(
                  decoration: new InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    return value.isEmpty ? 'Category is required' : null;
                  },
                  onSaved: (value) {
                    return _category = value;
                  },
                ),
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
    );
  }
}
