part of 'follower_counter_bloc.dart';

@immutable
abstract class FollowerCounterEvent extends Equatable {
  const FollowerCounterEvent();
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FetchFollowers extends FollowerCounterEvent{
  final int userId;
  const FetchFollowers( this.userId);

  @override
  List<Object?> get props => [userId];

}