import '../post_repository.dart';

abstract class PostRepository {

  Future<void> setPostData(MyPost client);

  Future<List<Map<String, dynamic>>> getMyPost();
}