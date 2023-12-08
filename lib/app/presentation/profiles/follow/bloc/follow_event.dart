part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object?> get props => [];
}

class FetchFollowers extends FollowEvent {
  final int userId;
  final int userLooking;

  const FetchFollowers(this.userId, this.userLooking);
}

class FetchFollowings extends FollowEvent {
  final int userId;

  final int userLooking;

  const FetchFollowings(this.userId, this.userLooking);
}

class FetchSubscribers extends FollowEvent {
  final int userId;

  const FetchSubscribers(this.userId);
}

class ToggleFollow extends FollowEvent {
  final int requestId;
  final bool isFollowing;
  final Follower follower;

  const ToggleFollow(this.requestId, this.isFollowing, this.follower);

  @override
  List<Object> get props => [requestId, isFollowing, follower];
}
