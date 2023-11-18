import 'dart:async';

import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'follower_counter_event.dart';
part 'follower_counter_state.dart';

class FollowerCounterBloc extends Bloc<FollowerCounterEvent, FollowerCounterState> {
  final UserAriaRepository userRepository;
  FollowerCounterBloc() :
         userRepository = GetIt.instance<UserAriaRepository>(),
        super(const FollowerCounterState()) {
    on<FollowerCounterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchFollowers>(_onFetchDataProfile);
  }

  void _onFetchDataProfile(
      FetchFollowers event,
      Emitter<FollowerCounterState> emit,
      ) async {

    final numberOfFollowers = await userRepository.getFollowersCounter(event.userId);
    final numberOfFollowings = await userRepository.getFollowingCounter(event.userId);
    final numberOfSubscribers = await userRepository.getSubscribersCounter(event.userId);

    emit(state.copyWith(
      numberOfFollowers: numberOfFollowers,
      numberOfFollowings:  numberOfFollowings,
      numberOfSubscribers: numberOfSubscribers
    ));
  }

  void fetchFollowerCounter(int userId){
    add(FetchFollowers(userId));
  }
}
