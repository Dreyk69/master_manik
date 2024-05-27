part of 'post_bloc.dart';

sealed class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class SetPost extends PostEvent {
  final MyPost myPost;

  const SetPost(this.myPost);

  @override
  List<Object> get props => [myPost];
}

class GetPost extends PostEvent {

  const GetPost();

  @override
  List<Object> get props => [];
}
