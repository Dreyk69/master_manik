import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../user_repository.dart';

class FirebaseUserRepository implements UserRepository {
  FirebaseUserRepository({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final clientCollection = FirebaseFirestore.instance.collection('client');
  final manicuristCollection =
      FirebaseFirestore.instance.collection('manicurist');

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser;
      return user;
    });
  }

  @override
  Future<MyClient> signUpForClient(MyClient myClient, String password) async {
    try {
      UserCredential client =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: myClient.email,
        password: password,
      );

      myClient = myClient.copyWith(id: client.user!.uid);

      return myClient;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyManicurist> signUpForManicurist(
      MyManicurist myManicurist, String password) async {
    try {
      UserCredential manicurist =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: myManicurist.email,
        password: password,
      );

      myManicurist = myManicurist.copyWith(id: manicurist.user!.uid);

      return myManicurist;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setClientData(MyClient client) async {
    try {
      await clientCollection.doc(client.id).set(client.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setManicuristData(MyManicurist manicurist) async {
    try {
      await manicuristCollection
          .doc(manicurist.id)
          .set(manicurist.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyClient> getMyClient(String myClientId) async {
    try {
      return clientCollection.doc(myClientId).get().then((value) =>
          MyClient.fromEntity(MyClientEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyManicurist> getMyManicurist(String myManicuristId) async {
    try {
      return manicuristCollection.doc(myManicuristId).get().then((value) =>
          MyManicurist.fromEntity(
              MyManicuristEntity.fromDocument(value.data()!)));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> uploadPicture(String file, String userId) async {
    try {
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/PP/${userId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      await manicuristCollection.doc(userId).update({'avatar': url});
      return url;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> uploadListPicture(String file, String userId) async {
    try {
      var uuid = const Uuid();
      final String randomId = uuid.v4();
      File imageFile = File(file);
      Reference firebaseStoreRef =
          FirebaseStorage.instance.ref().child('$userId/SpisokFotoRabot/${randomId}_lead');
      await firebaseStoreRef.putFile(imageFile);
      String url = await firebaseStoreRef.getDownloadURL();
      DocumentSnapshot userSnapshot  = await manicuristCollection.doc(userId).get();
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      List<dynamic> currentPhotoList = userData['photoRabot'];
      if (currentPhotoList[0] != '') {
        currentPhotoList.add(url);
      } else {
        currentPhotoList[0] = url;
      }
      await manicuristCollection.doc(userId).update({'photoRabot': currentPhotoList});
      return currentPhotoList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Map<String, int>>> uploadListUslug(String usluga, String cena, String userId) async {
    DocumentSnapshot userSnapshot  = await manicuristCollection.doc(userId).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    List<dynamic> uslugiDynamicList = userData['uslugi'];
    List<Map<String, int>> currentUslugiList = [];
    currentUslugiList = uslugiDynamicList.map((item) {
      if (item is Map) {
        return item.map((key, value) => MapEntry(key.toString(), value as int));
      } else {
        return <String, int>{}; // Вернуть пустую карту, если элемент не карта
      }
    }).toList();
    int cena1 = int.parse(cena);
    if (currentUslugiList[0].isNotEmpty) {
      currentUslugiList.add({usluga: cena1});
    } else {
      currentUslugiList[0] = {usluga: cena1};
    }
    await manicuristCollection.doc(userId).update({'uslugi': currentUslugiList});
    return currentUslugiList;
  }
}
