part of 'people_list_bloc.dart';

abstract class PeopleListEvent extends Equatable {
  const PeopleListEvent();
  @override
  List<Object> get props => [];
}

class PeopleFetched extends PeopleListEvent{}

class SearchPeople extends PeopleListEvent {
  final String keyword;

  const SearchPeople(this.keyword);

  @override
  List<Object> get props => [keyword];
}