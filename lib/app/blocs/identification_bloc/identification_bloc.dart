import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ananasik_nails/domain/repository/user_repository/lib/user_repository.dart';

part 'identification_event.dart';
part 'identification_state.dart';

class IdentificationBloc
    extends Bloc<IdentificationEvent, IdentificationState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  IdentificationBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(IdentificationInitial()) {
    _userSubscription = userRepository.user.listen((authUser) {
      add(IdentificationUser(authUser));
    });

    on<IdentificationUser>((event, emit) async {
      final id = event.user?.uid.toString();
      QuerySnapshot client =
          await firestore.collection('client').where('id', isEqualTo: id).get();
      QuerySnapshot manicurist = await firestore
          .collection('manicurist')
          .where('id', isEqualTo: id)
          .get();

      if (client.docs.isNotEmpty) {
        emit(IdentificationClient());
      } else if (manicurist.docs.isNotEmpty) {
        emit(IdentificationManicurist());
      } else {
        emit(IdentificationFailure());
      }
    });
  }
  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
