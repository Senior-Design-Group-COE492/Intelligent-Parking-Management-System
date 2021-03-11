import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHandler {
  static final firestore = FirebaseFirestore.instance;
  static DocumentReference? user;
  static bool isInitialized = false;

  static Future<DocumentSnapshot> getUserInformation(String uid) async {
    final snapshot = user?.get() ?? _setDocumentReference(uid);
    isInitialized = true;
    return snapshot;
  }

  static Future<Stream<DocumentSnapshot>> getUserInformationStream(
      String uid) async {
    // note: get user information must be called first!
    if (user == null) await _setDocumentReference(uid);
    final stream = user!.snapshots();
    return stream;
  }

  static Future<void> addFavorite(String carParkID) {
    print('entered handler!');
    return user!.update({
      'favorites': FieldValue.arrayUnion([carParkID])
    });
  }

  static Future<void> removeFavorite(String carParkID) {
    return user!.update({
      'favorites': FieldValue.arrayRemove([carParkID])
    });
  }

  static void _createUserDocument(String uid) {
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
        _createUserDocument(uid);
        return firestore.collection('users').doc(uid).get();
      }
    } catch (e) {
      throw (e);
    }
  }

  static Future<void> signOutFromFirestore() async {
    user = null;
  }
}
