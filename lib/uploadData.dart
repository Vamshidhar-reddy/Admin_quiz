import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';



class UploadData extends StatefulWidget {
  @override
  _UploadDataState createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
  File sampleImage;
  String _myValue;
  String _description;
  String postUrl;
  String cardUrl;
  String _category;
  String _group;
  final formKey = new GlobalKey<FormState>();



  Future getDisplayImage() async
  {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage = tempImage;
    });
  }

  bool validateAndSave()
  {
    final form = formKey.currentState;

    if(form.validate())
    {
      form.save();
      return true;
    }
    else
    {
      return false;
    }
  }


void uploadStatusImage() async
{
if (validateAndSave())
{
  final StorageReference postImageRef = FirebaseStorage.instance.ref().child("Posts");

  var timeKey = new DateTime.now();
  final StorageUploadTask uploadTask = postImageRef.child(timeKey.toString()+".png").putFile(sampleImage);

  var PostUrl = await(await uploadTask.onComplete).ref.getDownloadURL();
  postUrl= PostUrl.toString();
  print("Post Url ="+ postUrl);
  saveToDatabase(postUrl);
  Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadData()));
}
}
void saveToDatabase(String url)
{
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
  ref.child("Posts").push().set(data);
}

  @override
  Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Colors.amberAccent,
//       body: new Center(
//         child: sampleImage == null ? Text("Select an Image")
//  : enableUpload(),      
//  ),
//  floatingActionButton: new FloatingActionButton(
//    tooltip: 'Add Image',
//    child: new Icon(Icons.add_a_photo),
//    onPressed: getDisplayImage,
//  ),
      
//     );
return Container(
  color: Colors.amber,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          sampleImage == null ? RaisedButton(onPressed: getDisplayImage, 
          child: Text("Make A Post", style: TextStyle(fontSize: 40), textAlign: TextAlign.center,)) : enableUpload(),
          ]
        ),
    )
);
  }

  Widget enableUpload()
  {
    return Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height-100,
        child: new Form(
          key: formKey,
          child: Column(children: <Widget>[
           Row(
             children: <Widget>[
               Center(child: Image.file(sampleImage, height: 200, width: 150,fit: BoxFit.contain)),
             ],
           ),            
            TextFormField(
              decoration: new InputDecoration(labelText: 'Title'),
              validator: (value){
                return value.isEmpty ? 'Title is required' : null;
              },
              onSaved: (value){
                return _myValue = value;
              },
            ),
             TextFormField(
              decoration: new InputDecoration(labelText: 'Description'),
              validator: (value){
                return value.isEmpty ? 'Description is required' : null;
              },
              onSaved: (value){
                return _description = value;
              },
            ),
             TextFormField(
              decoration: new InputDecoration(labelText: 'Category'),
              validator: (value){
                return value.isEmpty ? 'Category is required' : null;
              },
              onSaved: (value){
                return _category = value;
              },
            ),


            SizedBox(height: 15.0),

            RaisedButton(
              elevation: 10.0,
              child: Text("Add a new Post"),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed:(){ uploadStatusImage;
              
              })
          ],),
        )
      ),
    );
  }
}