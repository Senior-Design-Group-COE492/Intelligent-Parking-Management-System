import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHandler {
  static final firestore = FirebaseFirestore.instance;
  static DocumentReference? user;
  static DocumentSnapshot? _latestSnapshot;

  static Future<DocumentSnapshot> getUserInformation(String uid) async {
    final snapshot = (user != null) ? user!.get() : _setDocumentReference(uid);
    _latestSnapshot = await snapshot;
    return snapshot;
  }

  static Future<void> addFavorite(String carParkID) {
    final currentFavorites =
        _latestSnapshot!.data()!['favorites'] as List<dynamic>;
    currentFavorites.add(carParkID);
    return user!.update({'favorites': currentFavorites});
  }

  static Future<void> removeFavorite(String carParkID) {
    final currentFavorites =
        _latestSnapshot!.data()!['favorites'] as List<dynamic>;
    currentFavorites.remove(carParkID);
    return user!.update({'favorites': currentFavorites});
  }

  static void _addUserDocumentToFirestore(String uid) {
    user = firestore.collection('users').doc(uid);
    user!.set({'favorites': []});
  }

  static Future<DocumentSnapshot> _setDocumentReference(String uid) async {
    // sets the document reference and returns the snapshot
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        user = firestore.collection('users').doc(uid);
        return doc;
      } else {
        // add a document for this user since they are not in the collection
        _addUserDocumentToFirestore(uid);
        return firestore.collection('users').doc(uid).get();
      }
    } catch (e) {
      throw (e);
    }
  }
}
