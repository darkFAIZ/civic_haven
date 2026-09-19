import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataService {
  DataService._();

  static final instance = DataService._();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get history => firestore
      .collection('users')
      .doc(uid)
      .collection('history');

  Stream<QuerySnapshot<Map<String, dynamic>>> watchHistory() {
    return history.orderBy('createdAt', descending: true).snapshots();
  }

  Future<String?> uploadBytes({
    required Uint8List bytes,
    required String fileName,
    required String folder,
  }) async {
    final ref = storage.ref('users/$uid/$folder/${DateTime.now().millisecondsSinceEpoch}_$fileName');
    final task = await ref.putData(bytes);
    return task.ref.getDownloadURL();
  }

  Future<void> addHistory({
    required String type,
    required String title,
    required Map<String, dynamic> details,
  }) {
    return history.add({
      'type': type,
      'title': title,
      'details': details,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
