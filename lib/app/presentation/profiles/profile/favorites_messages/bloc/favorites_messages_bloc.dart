import 'dart:async';
import 'dart:ui';

import 'package:ariapp/app/domain/entities/message.dart';
import 'package:ariapp/app/infrastructure/repositories/message_repository.dart';
import 'package:ariapp/app/presentation/profiles/profile/favorites_messages/widgets/favorites_messages_widget.dart';
import 'package:ariapp/app/security/shared_preferences_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

part 'favorites_messages_event.dart';

part 'favorites_messages_state.dart';

class FavoritesMessagesBloc
    extends Bloc<FavoritesMessagesEvent, FavoritesMessagesState> {
  final MessageRepository messageRepository;

  FavoritesMessagesBloc()
      : messageRepository = GetIt.instance<MessageRepository>(),
        super(const FavoritesMessagesState()) {
    on<FavoritesMessagesEvent>((event, emit) {});
    on<FavoriteMessageFetched>(_onFavoriteMessageFetched);
  }

  Future<void> _onFavoriteMessageFetched(
    FavoriteMessageFetched event,
    Emitter<FavoritesMessagesState> emit,
  ) async {
    emit(state.copyWith(
        favoritesMessagesStatus: FavoritesMessagesStatus.loading));
    try {
      int? userId = await SharedPreferencesManager.getUserId();

      final List<Message> favoritesMessages = await messageRepository
          .getFavoritesMessages(userId!, event.idUserLooking);

      final favoritesMessageProcess =
          _processFavoritesMessages(favoritesMessages, userId);

      emit(state.copyWith(
        favoritesMessages: favoritesMessageProcess,
        favoritesMessagesStatus: FavoritesMessagesStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
          favoritesMessagesStatus: FavoritesMessagesStatus.error));
    }
  }

  void favoritesMessageFetched(int idUserLooking) {
    add(FavoriteMessageFetched(idUserLooking));
  }

  List<FavoritesMessageWidget> _processFavoritesMessages(
      List<Message> messages, int userId) {
    final List<AudioPlayer> audioControllers = [];
    final List<FavoritesMessageWidget> chatMessages = [];

    for (final message in messages) {
      String? audioUrl;
      AudioPlayer? audioPlayer;

      audioUrl = message.content;
      if (audioUrl != null) {
        audioPlayer = AudioPlayer();
        audioPlayer.setUrl(
            'https://uploadsaria.blob.core.windows.net/files/$audioUrl');
        audioControllers.add(audioPlayer);
      }

      chatMessages.add(FavoritesMessageWidget(
        color: const Color(0xFF354271),
        audioPlayer: audioPlayer!,
        audioUrl: audioUrl,
        dateTime: message.date,
        read: message.read,
        isMe: message.sender == userId,
      ));
    }
    return chatMessages;
  }
}
