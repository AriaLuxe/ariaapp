part of 'people_list_bloc.dart';

enum PeopleListStatus { initial, loading, error, success }


 class PeopleListState extends Equatable {
  const PeopleListState({
    this.users = const <UserAria>[],
    this.peopleListStatus =  PeopleListStatus.initial,
    this.usersSearch = const <UserAria>[],
  });
  final List<UserAria> users;
  final List<UserAria> usersSearch;

  PeopleListState copyWith({
     List<UserAria>? users,
     PeopleListStatus? peopleListStatus,

  }){
    return PeopleListState(
      users: users ?? this.users,
      peopleListStatus: peopleListStatus ?? this.peopleListStatus,
    );
  }

  final PeopleListStatus peopleListStatus;
  @override
  // TODO: implement props
  List<Object?> get props => [users, peopleListStatus,];
}



