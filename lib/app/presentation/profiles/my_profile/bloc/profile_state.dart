part of 'profile_bloc.dart';

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

  }) => ProfileState(
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
  );
  @override
  List<Object?> get props => [chatId,name, lastName, email, state, urlProfile,numberOfFollowers,numberOfFollowings,numberOfSubscribers,isFollowed, isBlock];
}


