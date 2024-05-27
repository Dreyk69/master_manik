import 'dart:async';

import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_data_event.dart';
part 'get_data_state.dart';

class GetDataBloc extends Bloc<GetDataEvent, GetDataState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  GetDataBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(GetDataInitial()) {
    _userSubscription = userRepository.user.listen((authUser) {
      add(GetDataUser(authUser));
      add(GetDataZapisUser(authUser));
    });
    on<GetDataUser>((event, emit) async {
      emit(GetDataProcess());
      final id = event.user?.uid.toString();
      QuerySnapshot client =
          await firestore.collection('client').where('id', isEqualTo: id).get();
      QuerySnapshot manicurist = await firestore
          .collection('manicurist')
          .where('id', isEqualTo: id)
          .get();

      if (client.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot =
            await firestore.collection('client').doc(id).get();
        
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        emit(GetDataSuccess(client: userData));
      } else if (manicurist.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot =
            await firestore.collection('manicurist').doc(id).get();
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        emit(GetDataSuccess(manicurist: userData));
      } else {
        emit(GetDataFailure());
      }
    });
    on<GetDataZapisUser>((event, emit) async {
      emit(GetDataZapisProcess());
      final id = event.user?.uid.toString();
      QuerySnapshot client =
          await firestore.collection('client').where('id', isEqualTo: id).get();
      QuerySnapshot manicurist = await firestore
          .collection('manicurist')
          .where('id', isEqualTo: id)
          .get();
      if (client.docs.isNotEmpty) {
        CollectionReference appointments =
            firestore.collection('client').doc(id).collection('zapis');
            QuerySnapshot querySnapshot = await appointments.get();
      final allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();   
          emit(GetDataZapisSuccess(zapis: allData));
      } else if (manicurist.docs.isNotEmpty) {
        CollectionReference appointments =
            firestore.collection('manicurist').doc(id).collection('zapis');
      QuerySnapshot querySnapshot = await appointments.get();
      final allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          emit(GetDataZapisSuccess(zapis: allData));
      } else {
        emit(GetDataZapisFailure());
      }
    });
  }
  @override
    Future<void> close() {
      _userSubscription.cancel();
      return super.close();
    }
}
