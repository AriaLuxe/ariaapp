import 'dart:async';
import 'dart:developer';

import 'package:ariapp/app/domain/entities/follower.dart';
import 'package:ariapp/app/infrastructure/repositories/user_aria_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../security/shared_preferences_manager.dart';

part 'follow_event.dart';

part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final UserAriaRepository userAriaRepository;

  FollowBloc()
      : userAriaRepository = GetIt.instance<UserAriaRepository>(),
        super(const FollowState()) {
    on<FollowEvent>((event, emit) {});

    on<FetchFollowers>(_onFollowersFetched);
    on<FetchFollowings>(_onFollowingFetched);
    on<FetchSubscribers>(_onSubscribersFetched);
    on<ToggleFollow>(_onToggleFollow);
  }

  Future<void> _onFollowersFetched(
    FetchFollowers event,
    Emitter<FollowState> emit,
  ) async {
    emit(state.copyWith(followersStatus: FollowStatus.initial));
    try {
      final List<Follower> followers = await userAriaRepository.getFollowers(
          event.userId, event.userLooking);
      List<Follower> followersUpdated = [];
      for (final chat in followers) {
        followersUpdated.add(chat);
      }
      emit(
        state.copyWith(
          followersStatus: FollowStatus.success,
          followers: followersUpdated,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        followersStatus: FollowStatus.success,
      ));
    }
  }

  void followersFetched(int userId, int userLooking) {
    add(FetchFollowers(userId, userLooking));
  }

  Future<void> _onFollowingFetched(
      FetchFollowings event, Emitter<FollowState> emit) async {
    emit(state.copyWith(followingStatus: FollowStatus.loading));

    try {
      final List<Follower> following = await userAriaRepository.getFollowing(
          event.userId, event.userLooking);
      List<Follower> followersUpdated = [];
      for (final chat in following) {
        followersUpdated.add(chat);
      }
      emit(state.copyWith(
        followingStatus: FollowStatus.success,
        following: following,
      ));
    } catch (e) {
      emit(state.copyWith(followingStatus: FollowStatus.error));
    }
  }

  void followingsFetched(int userId, int userLooking) {
    add(FetchFollowings(userId, userLooking));
  }

  Future<void> _onSubscribersFetched(
      FetchSubscribers event, Emitter<FollowState> emit) async {
    emit(state.copyWith(subscribersStatus: FollowStatus.loading));

    try {
      final List<Follower> subscribers =
          await userAriaRepository.getSubscribers(event.userId);

      emit(state.copyWith(
        subscribersStatus: FollowStatus.success,
        subscribers: subscribers,
      ));
    } catch (e) {
      emit(state.copyWith(subscribersStatus: FollowStatus.error));
    }
  }

  void subscribersFetched(int userId) {
    add(FetchSubscribers(userId));
  }

  Future<void> _onToggleFollow(
      ToggleFollow event, Emitter<FollowState> emit) async {
    try {
      int? userId = await SharedPreferencesManager.getUserId();

      if (event.isFollowing) {
        final response =
            await userAriaRepository.follow(userId!, event.follower.idUser);
        log(response);
      } else {
        final response = await userAriaRepository.unFollow(event.requestId);
        if (response == 'Request deleted') {
          log('se dejo de seguir');
        } else {
          log('error');
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void toggleFollow(int requestId, bool isFollowing, Follower follower) {
    add(ToggleFollow(requestId, isFollowing, follower));
  }
}
