import 'dart:async';

import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/user_aria.dart';

part 'people_list_event.dart';

part 'people_list_state.dart';

class PeopleListBloc extends Bloc<PeopleListEvent, PeopleListState> {
  final UserAriaRepository usersRepository;

  PeopleListBloc()
      : usersRepository = GetIt.instance<UserAriaRepository>(),
        super(const PeopleListState()) {
    on<PeopleListEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PeopleFetched>(_onPeopleFetched);
    on<SearchPeople>(_onSearchPeople);
    on<LoadMoreUsers>(_onLoadMoreUsers);
  }

  Future<void> _onPeopleFetched(
    PeopleFetched event,
    Emitter<PeopleListState> emit,
  ) async {
    emit(state.copyWith(peopleListStatus: PeopleListStatus.loading));
    try {
      final List<UserAria> users =
          await usersRepository.getAllFriends(event.page, event.pageSize);
      List<UserAria> usersUpdated = [];

      for (final user in users) {
        if (!user.enabled!) {
          usersUpdated.add(user);
        }
      }
      emit(
        state.copyWith(
          peopleListStatus: PeopleListStatus.success,
          users: usersUpdated,
        ),
      );
    } catch (e) {
      emit(state.copyWith(peopleListStatus: PeopleListStatus.error));
    }
  }

  void peopleFetched(int page, int pageSize) {
    add(PeopleFetched(page, pageSize));
  }

  Future<void> _onSearchPeople(
    SearchPeople event,
    Emitter<PeopleListState> emit,
  ) async {
    emit(state.copyWith(peopleListStatus: PeopleListStatus.loading));

    try {
      final List<UserAria> searchResults =
          await usersRepository.searchUser(event.keyword);

      List<UserAria> usersUpdated = [];
      if (event.keyword.isEmpty) {
        for (final user in searchResults) {
          if (!user.enabled!) {
            usersUpdated.add(user);
          }
        }
      } else {
        for (final user in searchResults) {
          if (user.enabled!) {
            usersUpdated.add(user);
          }
        }
      }

      emit(
        state.copyWith(
          peopleListStatus: PeopleListStatus.success,
          users: usersUpdated,
        ),
      );
    } catch (e) {
      emit(state.copyWith(peopleListStatus: PeopleListStatus.error));
    }
  }

  void searchPeople(String keyword) {
    add(SearchPeople(keyword));
  }

  Future<void> _onLoadMoreUsers(
    LoadMoreUsers event,
    Emitter<PeopleListState> emit,
  ) async {
    try {
      final List<UserAria> users =
          await usersRepository.getAllFriends(event.page, event.pageSize);
      List<UserAria> moreUsers = [];

      for (final user in users) {
        moreUsers.add(user);
      }
      emit(
        state.copyWith(
          peopleListStatus: PeopleListStatus.success,
          users: [...state.users, ...moreUsers],
          hasMoreMessages: moreUsers.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(state.copyWith(peopleListStatus: PeopleListStatus.error));
    }
  }

  void loadMoreUsers(int page, int pageSize) {
    add(LoadMoreUsers(page, pageSize));
  }
}
