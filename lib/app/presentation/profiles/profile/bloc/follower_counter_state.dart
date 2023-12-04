part of 'follower_counter_bloc.dart';

 class FollowerCounterState extends  Equatable {
   const FollowerCounterState({

     this.numberOfFollowers = 0,
     this.numberOfFollowings = 0,
     this.numberOfSubscribers = 0,
     this.isFollowed = false,

   });

   final int numberOfFollowers;
   final int numberOfFollowings;
   final int numberOfSubscribers;
  final bool isFollowed;

   FollowerCounterState copyWith({

     int? numberOfFollowers,
     int? numberOfFollowings,
     int? numberOfSubscribers,
     bool? isFollowed,



   }) => FollowerCounterState(

       numberOfFollowers: numberOfFollowers ?? this.numberOfFollowers,
       numberOfFollowings: numberOfFollowings ?? this.numberOfFollowings,
       numberOfSubscribers: numberOfSubscribers ?? this.numberOfSubscribers,
       isFollowed: isFollowed ?? this.isFollowed
   );
   @override
   List<Object?> get props => [numberOfFollowers,numberOfFollowings,numberOfSubscribers,isFollowed];

 }


