part of 'favorites_messages_bloc.dart';

sealed class FavoritesMessagesEvent extends Equatable {
  const FavoritesMessagesEvent();
  @override

  List<Object?> get props => [];
}
class FavoriteMessageFetched extends FavoritesMessagesEvent {

  final int idUserLooking;
  const FavoriteMessageFetched(this.idUserLooking);

}