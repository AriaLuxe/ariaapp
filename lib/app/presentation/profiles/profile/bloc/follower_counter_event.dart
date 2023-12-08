part of 'follower_counter_bloc.dart';

@immutable
abstract class FollowerCounterEvent extends Equatable {
  const FollowerCounterEvent();

  @override
  List<Object?> get props => [];
}

class FetchFollowers extends FollowerCounterEvent {
  final int userId;

  const FetchFollowers(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ToggleFollow extends FollowerCounterEvent {
  final int userLooking;
  final bool isFollowing;

  const ToggleFollow(this.userLooking, this.isFollowing);

  @override
  List<Object> get props => [userLooking, isFollowing];
}
