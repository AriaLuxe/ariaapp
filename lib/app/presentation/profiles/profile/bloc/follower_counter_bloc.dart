import 'dart:async';
import 'dart:convert';

import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'follower_counter_event.dart';

part 'follower_counter_state.dart';

class FollowerCounterBloc
    extends Bloc<FollowerCounterEvent, FollowerCounterState> {
  final UserAriaRepository userRepository;
  final UserAriaRepository userAriaRepository;

  FollowerCounterBloc()
      : userAriaRepository = GetIt.instance<UserAriaRepository>(),
        userRepository = GetIt.instance<UserAriaRepository>(),
        super(const FollowerCounterState()) {
    on<FollowerCounterEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchFollowers>(_onFetchDataProfile);
    on<ToggleFollow>(_onToggleFollow);
  }

  void _onFetchDataProfile(
    FetchFollowers event,
    Emitter<FollowerCounterState> emit,
  ) async {
    final numberOfFollowers =
        await userRepository.getFollowersCounter(event.userId);
    final numberOfFollowings =
        await userRepository.getFollowingCounter(event.userId);
    final numberOfSubscribers =
        await userRepository.getSubscribersCounter(event.userId);
    print('numberOfFollowers');
    print(numberOfFollowers);
    emit(state.copyWith(
        numberOfFollowers: numberOfFollowers,
        numberOfFollowings: numberOfFollowings,
        numberOfSubscribers: numberOfSubscribers));
  }

  void fetchFollowerCounter(int userId) {
    add(FetchFollowers(userId));
  }

  Future<void> _onToggleFollow(
      ToggleFollow event, Emitter<FollowerCounterState> emit) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();

      if (!event.isFollowing) {
        emit(state.copyWith(isFollowed: true));

        await userAriaRepository.follow(userId!, event.userLooking);
        final numberOfFollowers =
            await userAriaRepository.getFollowersCounter(event.userLooking);
        emit(state.copyWith(
          numberOfFollowers: numberOfFollowers,
        ));
      } else {
        emit(state.copyWith(isFollowed: false));
        final follower =
            await userAriaRepository.checkFollow(userId!, event.userLooking);
        final followerDecode = jsonDecode(follower);

        final response =
            await userAriaRepository.unFollow(followerDecode['idRequest']);

        if (response == 'Request deleted') {
          final numberOfFollowers =
              await userAriaRepository.getFollowersCounter(event.userLooking);
          emit(state.copyWith(
            numberOfFollowers: numberOfFollowers,
          ));
          print('se dejo de seguir');
        } else {
          print('error');
        }
        print(response);
      }
    } catch (e) {
      print(e);
    }
  }

  void toggleFollowProfile(int userLooking, bool isFollowing) {
    add(ToggleFollow(userLooking, isFollowing));
  }
}
