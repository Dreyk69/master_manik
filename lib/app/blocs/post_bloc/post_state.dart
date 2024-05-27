part of 'post_bloc.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

class PostSetSuccess extends PostState {}

class PostGetSuccess extends PostState {
  final List<Map<String, dynamic>> post;

  const PostGetSuccess(this.post);
  
  @override
  List<Object> get props => [post];
}

class PostFailure extends PostState {}

class PostProcess extends PostState {}
