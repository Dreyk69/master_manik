import 'package:ananasik_nails/domain/repository/post_repository/lib/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;
  PostBloc({required PostRepository myPostRepository})
      : postRepository = myPostRepository,
        super(PostInitial()) {
    on<GetPost>((event, emit) async {
      emit(PostProcess());
      try {
        List<Map<String, dynamic>> post = await postRepository.getMyPost();
        emit(PostGetSuccess(post));
      } catch (e) {
        emit(PostFailure());
      }
    });
    add(const GetPost());
    on<SetPost>((event, emit) async {
      emit(PostProcess());
      try {
        await postRepository.setPostData(event.myPost);
        emit(PostSetSuccess());
      } catch (e) {
        emit(PostFailure());
      }
    });
  }
}
