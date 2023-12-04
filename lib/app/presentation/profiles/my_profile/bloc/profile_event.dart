part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class FetchDataProfile extends ProfileEvent {
  final int userId;
  const FetchDataProfile( this.userId);

  @override
  List<Object?> get props => [userId];


}

class CheckFollowStatus extends ProfileEvent {
  final int userLooking;
  const CheckFollowStatus( this.userLooking);

  @override
  List<Object?> get props => [userLooking];
}
class CheckBlockStatus extends ProfileEvent {
  final int userLooking;
  const CheckBlockStatus( this.userLooking);

  @override
  List<Object?> get props => [userLooking];
}
class ToggleFollow extends ProfileEvent {
  final int userLooking;
  final bool isFollowing;
  const ToggleFollow(this.userLooking, this.isFollowing);

  @override
  List<Object> get props => [userLooking,isFollowing];
}

class ToggleBlock extends ProfileEvent {
  final int idBlocked;
  final bool isBlock;
  const ToggleBlock(this.idBlocked, this.isBlock);

  @override
  List<Object> get props => [idBlocked,isBlock];
}

class ProfileDefaultPhoto extends ProfileEvent {
  final String url;
  const ProfileDefaultPhoto( this.url);

  @override
  List<Object?> get props => [url];
}


class LoadingDeleteChat extends ProfileEvent {
  final bool isLoadingDeleteChat;

  const LoadingDeleteChat(this.isLoadingDeleteChat);

  @override
  List<Object> get props => [isLoadingDeleteChat];
}
