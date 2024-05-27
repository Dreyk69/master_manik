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

  Future<List<dynamic>> uploadListPicture(String file, String userId);

  Future<List<Map<String, int>>> uploadListUslug(
      String usluga, String cena, String userId);

  Future<Map<DateTime, List<String>>> uploadListOkohek(
      DateTime day, String formattedTime, String userId);

  Future<void> saveZapisClient({
    required String id,
    required DateTime selectedDate,
    required String selectedTime,
    required String selectedService,
    required int selectedPrice,
    required String nameMaster,
    required String emailMaster,
  });

  Future<void> saveZapisManicurist({
    required String id,
    required DateTime selectedDate,
    required String selectedTime,
    required String selectedService,
    required int selectedPrice,
    required String nameUser,
    required String emailUser,
  });
}
