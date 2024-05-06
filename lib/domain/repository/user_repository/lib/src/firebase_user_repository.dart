import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
}
