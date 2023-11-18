part of 'follow_bloc.dart';

enum FollowStatus {
  initial, loading, error, success
}

class FollowState extends Equatable {
  const FollowState({
    this.followersStatus = FollowStatus.initial,
    this.followingStatus = FollowStatus.initial,
    this.subscribersStatus = FollowStatus.initial,
    this.followers = const [],
    this.following = const [],
    this.subscribers = const [],
  });

  final FollowStatus followersStatus;
  final FollowStatus followingStatus;
  final FollowStatus subscribersStatus;
  final List<Follower> followers;
  final List<Follower> following;
  final List<Follower> subscribers;


  FollowState copyWith({
    FollowStatus? followersStatus,
    FollowStatus? followingStatus,
    FollowStatus? subscribersStatus,
    List<Follower>? followers,
    List<Follower>? following,
    List<Follower>? subscribers,
  }) {
    return FollowState(
      followersStatus: followersStatus ?? this.followersStatus,
      followingStatus: followingStatus ?? this.followingStatus,
      subscribersStatus: subscribersStatus ?? this.subscribersStatus,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      subscribers: subscribers ?? this.subscribers,
    );
  }
  @override
  List<Object?> get props => [followersStatus, followingStatus, subscribersStatus, followers, following, subscribers];

}
