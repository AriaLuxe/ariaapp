import 'dart:async';

import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/entities/user_aria.dart';
import '../../../../security/shared_preferences_manager.dart';

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
  }

  Future<void> _onPeopleFetched(
      PeopleFetched event,
      Emitter<PeopleListState> emit,
      ) async {
    emit(state.copyWith(peopleListStatus: PeopleListStatus.loading));
    // print(userLogged.userAria.id!);
    try {
      final List<UserAria> users =
      await usersRepository.getAllFriends();
      List<UserAria> usersUpdated = [];

      for (final user in users) {
        usersUpdated.add(user);
      }
      emit(
        state.copyWith(
          peopleListStatus:  PeopleListStatus.success,
          users: usersUpdated,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(peopleListStatus:  PeopleListStatus.error));
    }
  }

  void peopleFetched() {
    add(PeopleFetched());
  }

  Future<void> _onSearchPeople(
      SearchPeople event,
      Emitter<PeopleListState> emit,
      ) async {
    emit(state.copyWith(peopleListStatus: PeopleListStatus.loading));

    try {

      final List<UserAria> searchResults = await usersRepository.searchUser(event.keyword);
      emit(
        state.copyWith(
          peopleListStatus: PeopleListStatus.success,
          users: searchResults,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(peopleListStatus: PeopleListStatus.error));
    }
  }
  void searchPeople(String keyword){
    add(SearchPeople(keyword));
  }
}
