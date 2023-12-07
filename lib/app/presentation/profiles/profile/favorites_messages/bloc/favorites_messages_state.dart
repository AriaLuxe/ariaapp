part of 'favorites_messages_bloc.dart';
enum FavoritesMessagesStatus { initial, loading, error, success }

 class FavoritesMessagesState extends Equatable {

   final List<FavoritesMessageWidget> favoritesMessages;
   final FavoritesMessagesStatus favoritesMessagesStatus;

  const FavoritesMessagesState(
      {this.favoritesMessages = const <FavoritesMessageWidget>[],
        this.favoritesMessagesStatus = FavoritesMessagesStatus.initial,
      });

   FavoritesMessagesState copyWith({
      List<FavoritesMessageWidget>? favoritesMessages,
      FavoritesMessagesStatus? favoritesMessagesStatus,
   }){
     return FavoritesMessagesState(
         favoritesMessages: favoritesMessages ?? this.favoritesMessages,
         favoritesMessagesStatus: favoritesMessagesStatus ?? this.favoritesMessagesStatus,
     );
   }
  @override
  // TODO: implement props
  List<Object?> get props => [favoritesMessages,favoritesMessagesStatus];
}


