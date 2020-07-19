import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Params extends ChangeNotifier {
  String _grpName, _folder;
  String _topicKey;
  int _topicIndex;
  DocumentSnapshot _docSnap=null;
  DocumentSnapshot get docSnap => _docSnap;

  String get grpName => _grpName;
  String get folder => _folder;
  String get topicKey => _topicKey;

  int get topicIndex => _topicIndex;

  void onGrpTap(String grp) {
    _grpName = grp;
    notifyListeners();
  }

  void topicTap(String fol, String tkey, int ind) {
    _folder = fol;
    _topicKey = tkey;
    _topicIndex = ind;
    notifyListeners();
  }

  void updateDoc(DocumentSnapshot doc) {
    _docSnap = doc;
    notifyListeners();
  }
}
