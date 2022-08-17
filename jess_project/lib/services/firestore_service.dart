import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jess_project/utilitys/user.dart';

class FirestoreService {
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Future<void> addAccountData(
    String email,
    String user,
    int phone,
    String pic,
  ) async {
    var docRef = FirestoreService().profileCollection.doc();
    print('add docref: ' + docRef.id);

    await profileCollection.doc(docRef.id).set({
      'uid': docRef.id,
      'email': email,
      'user': user,
      'phone': phone,
      'pic': pic,
    });
  }

  Future<List<Profile>> readAccountData() async {
    List<Profile> userList = [];
    QuerySnapshot snapshot = await profileCollection.get();

    snapshot.docs.forEach((document) {
      Profile user = Profile.fromMap(document.data());
      userList.add(user);
    });
    print('Accountlist: $userList');
    return userList;
  }

  Future<void> deleteAccountData(String docid) async {
    profileCollection.doc(docid).delete();

    print('deleting uid: ' + docid);
  }

  Future<void> updateAccountData(
      String id, String email, String user, int phone, String pic) async {
    await profileCollection.doc(id).update({
      'uid': id,
      'email': email,
      'user': user,
      'phone': phone,
      'pic': pic,
    });
  }

  Future<void> deleteAccountDoc() async {
    await profileCollection.get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
