import 'package:firebase_auth/firebase_auth.dart';

import '../user_repository.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyClient> signUpForClient(MyClient myClient, String password);

  Future<MyManicurist> signUpForManicurist(
      MyManicurist myManicurist, String password);

  Future<void> resetPassword(String email);

  Future<void> setClientData(MyClient client);

  Future<void> setManicuristData(MyManicurist manicurist);

  Future<MyClient> getMyClient(String myClientId);

  Future<MyManicurist> getMyManicurist(String myManicuristId);

  Future<String> uploadPicture(String file, String userId);
}
