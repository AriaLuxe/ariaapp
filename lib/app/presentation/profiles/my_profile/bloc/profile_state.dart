part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, error, success }

class ProfileState extends Equatable {
  const ProfileState({
    this.name = '',
    this.lastName = '',
    this.email = '',
    this.state = '',
    this.urlProfile = '',
    this.numberOfFollowers = 0,
    this.numberOfFollowings = 0,
    this.numberOfSubscribers = 0,
    this.isFollowed = false,
    this.isBlock = false,
    this.chatId = 0,
    //this.profileStatus = ProfileStatus.initial,
  });

  final String name;
  final String lastName;
  final String email;
  final String state;
  final String urlProfile;
  final int numberOfFollowers;
  final int numberOfFollowings;
  final int numberOfSubscribers;
  final bool isFollowed;
  final bool isBlock;
  final int chatId;
  //final ProfileStatus profileStatus;

  ProfileState copyWith({
    String? name,
    String? lastName,
    String? email,
    String? state,
    String? urlProfile,
    int? numberOfFollowers,
    int? numberOfFollowings,
    int? numberOfSubscribers,
    bool? isFollowed,
    bool? isBlock,
    int? chatId,
   // ProfileStatus? profileStatus,
  }) =>
      ProfileState(
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        state: state ?? this.state,
        urlProfile: urlProfile ?? this.urlProfile,
        numberOfFollowers: numberOfFollowers ?? this.numberOfFollowers,
        numberOfFollowings: numberOfFollowings ?? this.numberOfFollowings,
        numberOfSubscribers: numberOfSubscribers ?? this.numberOfSubscribers,
        isFollowed: isFollowed ?? this.isFollowed,
        isBlock: isBlock ?? this.isBlock,
        chatId: chatId ?? this.chatId,
        //profileStatus: profileStatus ?? this.profileStatus,
      );

  @override
  List<Object?> get props => [
        //profileStatus,
        chatId,
        name,
        lastName,
        email,
        state,
        urlProfile,
        numberOfFollowers,
        numberOfFollowings,
        numberOfSubscribers,
        isFollowed,
        isBlock
      ];
}
