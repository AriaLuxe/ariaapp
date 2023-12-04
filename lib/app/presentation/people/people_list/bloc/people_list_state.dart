part of 'people_list_bloc.dart';

enum PeopleListStatus { initial, loading, error, success }


 class PeopleListState extends Equatable {
  const PeopleListState({
    this.users = const <UserAria>[],
    this.peopleListStatus =  PeopleListStatus.initial,
    this.usersSearch = const <UserAria>[],
    this.hasMoreMessages = false,

  });
  final List<UserAria> users;
  final List<UserAria> usersSearch;
  final bool hasMoreMessages;

  PeopleListState copyWith({
     List<UserAria>? users,
     PeopleListStatus? peopleListStatus,
    bool? hasMoreMessages,


  }){
    return PeopleListState(
      users: users ?? this.users,
      peopleListStatus: peopleListStatus ?? this.peopleListStatus,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,

    );
  }

  final PeopleListStatus peopleListStatus;
  @override
  // TODO: implement props
  List<Object?> get props => [users, peopleListStatus,hasMoreMessages];
}



