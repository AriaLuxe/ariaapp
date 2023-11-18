import 'dart:async';
import 'dart:convert';

import 'package:ariapp/app/security/user_logged.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/repositories/user_aria_repository.dart';
import '../../../../security/shared_preferences_manager.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserAriaRepository userAriaRepository;
  ProfileBloc() :
        userAriaRepository = GetIt.instance<UserAriaRepository>(),
        super(const ProfileState()) {
    on<ProfileEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchDataProfile>(_onFetchDataProfile);
    on<CheckFollowStatus>(_onCheckFollowStatus);
    on<ToggleFollow>(_onToggleFollow);

    on<CheckBlockStatus>(_onCheckBlockStatus);
    on<ToggleBlock>(_onToggleBlock);
    on<ProfileDefaultPhoto>(_onProfilePhotoDefault);



  }

  void _onFetchDataProfile(
      FetchDataProfile event,
      Emitter<ProfileState> emit,
      ) async {
    //final userId = await SharedPreferencesManager.getUserId();
    final user = await userAriaRepository.getUserById(event.userId);

    final numberOfFollowers = await userAriaRepository.getFollowersCounter(event.userId);
    final numberOfFollowings = await userAriaRepository.getFollowingCounter(event.userId);

    emit(state.copyWith(
      name: user.nameUser,
      lastName: user.lastName,
      email:user.email,
      state: user.state,
      urlProfile: user.imgProfile,
      numberOfFollowers: numberOfFollowers,
        numberOfFollowings:  numberOfFollowings,
    ));
  }

  void fetchDataProfile(int userId){
    add(FetchDataProfile(userId));
  }

  void _onCheckFollowStatus(CheckFollowStatus event, Emitter<ProfileState> emit) async {

  try{
    print('event.userLooking');

    print(event.userLooking);
    final currentUserId = await SharedPreferencesManager.getUserId();
    final response = await userAriaRepository.checkFollow(currentUserId!, event.userLooking);

      if(response == 'false'){
        emit(state.copyWith(isFollowed: false));
      }else {
          emit(state.copyWith(isFollowed: true));
      }


    }catch(e){
    //emit(state.copyWith(isFollowed: false));

}

  }
  void checkFollow(int userLooking){
    add(CheckFollowStatus(userLooking));
  }

  Future<void> _onToggleFollow(ToggleFollow event, Emitter<ProfileState> emit) async {

    try{
      int? userId = await SharedPreferencesManager.getUserId();

      if(!event.isFollowing){
        emit(state.copyWith(isFollowed: true));

        final response = await userAriaRepository.follow(userId!,event.userLooking);

      }
      else {
        emit(state.copyWith(isFollowed: false));

        final follower = await userAriaRepository.checkFollow(userId!, event.userLooking);
        final followerDecode = jsonDecode(follower);

        final response = await userAriaRepository.unFollow(followerDecode['idRequest']);

        if(response == 'Request deleted' ){
          print('se dejo de seguir');
        }else {
          print('error');
        }
        print(response);
      }
    }catch(e){
      print(e);
    }

  }
  void toggleFollowProfile(int userLooking, bool isFollowing){
    add(ToggleFollow(userLooking, isFollowing));
  }

  void _onCheckBlockStatus(CheckBlockStatus event, Emitter<ProfileState> emit) async {

    try{

      final currentUserId = await SharedPreferencesManager.getUserId();

      final response = await userAriaRepository.checkBlock(currentUserId!, event.userLooking);


      if(response == false){
        print('no esta bloqueado');
        emit(state.copyWith(isBlock: false));
      }else {
        print('esta bloqueado');
        emit(state.copyWith(isBlock: true));
      }


    }catch(e){
      emit(state.copyWith(isBlock: false));

    }

  }
  void checkBlock(int userLooking){
    add(CheckBlockStatus(userLooking));
  }

  Future<void> _onToggleBlock(ToggleBlock event, Emitter<ProfileState> emit) async {

    try{
      int? userId = await SharedPreferencesManager.getUserId();

      print(event.isBlock);
      if(!event.isBlock){
        emit(state.copyWith(isBlock: true));

        final response = await userAriaRepository.block(userId!,event.idBlocked);

        print('se bloqueo');


      }
      else {
        emit(state.copyWith(isBlock: false));

        final response = await userAriaRepository.unBlock(userId!, event.idBlocked);


        if(response == 'User unblock successfully' ){
          print('se dejo de bloquear');
        }else {
          print('error');
        }
        print(response);
      }
    }catch(e){
      print(e);
    }

  }


  void toggleBlockProfile(int userLooking, bool isFollowing){
    add(ToggleBlock(userLooking, isFollowing));
  }

  void _onProfilePhotoDefault(
      ProfileDefaultPhoto event,
      Emitter<ProfileState> emit,
      ) async {
    //final userId = await SharedPreferencesManager.getUserId();

    print(event.url);
    emit(state.copyWith(
      urlProfile: event.url,

    ));
  }

  void updateDefaultPhoto(String urlPhoto){
    add(ProfileDefaultPhoto(urlPhoto));
  }

}
