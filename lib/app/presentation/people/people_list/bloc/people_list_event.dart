part of 'people_list_bloc.dart';

abstract class PeopleListEvent extends Equatable {
  const PeopleListEvent();
  @override
  List<Object> get props => [];
}

class PeopleFetched extends PeopleListEvent{
  final int page;
  final int pageSize;
  const PeopleFetched(this.page,this.pageSize);
}

class SearchPeople extends PeopleListEvent {
  final String keyword;

  const SearchPeople(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class LoadMoreUsers extends PeopleListEvent {
  const LoadMoreUsers(
      this.page,
      this.pageSize,
      );

  final int page;
  final int pageSize;

  @override
  List<Object> get props => [page, pageSize];
}