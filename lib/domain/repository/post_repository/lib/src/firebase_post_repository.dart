import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../post_repository.dart';

class FirebasePostRepository implements PostRepository {
  FirebasePostRepository();

  final postCollection = FirebaseFirestore.instance.collection('post');

  @override
  Future<void> setPostData(MyPost post) async {
    try {
      await postCollection.doc(post.id).set(post.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMyPost() async {
    try {
      QuerySnapshot querySnapshot = await postCollection.get();
      final allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      return allData;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
