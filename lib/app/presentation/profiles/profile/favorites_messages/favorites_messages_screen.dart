import 'package:ariapp/app/presentation/profiles/profile/favorites_messages/bloc/favorites_messages_bloc.dart';
import 'package:ariapp/app/presentation/profiles/profile/favorites_messages/widgets/header_favorites_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PositionData {
  const PositionData(
    this.position,
    this.bufferedPosition,
    this.duration,
  );

  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class FavoritesMessagesScreen extends StatelessWidget {
  const FavoritesMessagesScreen({Key? key, required this.userLookingId})
      : super(key: key);
  final int userLookingId;

  @override
  Widget build(BuildContext context) {
    return FavoritesMessages(
      userLookingId: userLookingId,
    );
  }
}

class FavoritesMessages extends StatefulWidget {
  const FavoritesMessages({Key? key, required this.userLookingId})
      : super(key: key);
  final int userLookingId;

  @override
  State<FavoritesMessages> createState() => _FavoritesMessagesState();
}

class _FavoritesMessagesState extends State<FavoritesMessages> {
  late final String url;

  int? userId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<FavoritesMessagesBloc, FavoritesMessagesState>(
        builder: (context, state) {
          final messages = state.favoritesMessages;

          if (state.favoritesMessagesStatus ==
              FavoritesMessagesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.favoritesMessagesStatus ==
              FavoritesMessagesStatus.error) {
            return const Center(child: Text('Error fetching messages'));
          } else if (state.favoritesMessagesStatus ==
              FavoritesMessagesStatus.success) {
            //var messagesOrder = messages.reversed.toList();
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: size.width * 0.9,
                      //TODO: Agregar navegacion hacia el perfile al tocar la foto
                      child: HeaderFavoritesMessages(
                        title: 'Mensajes favoritos',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(color: Color(0xFF354271), thickness: 2),
                  state.favoritesMessages.isEmpty
                      ? const Expanded(
                          child: Center(
                              child: Text(
                          'Manda tu primer mensaje',
                          style: TextStyle(color: Colors.white),
                        )))
                      : Expanded(
                          child: ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages.toList();
                                return message[index];
                              }),
                        ),
                  const SizedBox(),
                ],
              ),
            );
          }
          return const Center(
            child: Text('Comuníquese al email@gmail.com'),
          );
        },
      ),
    );
  }
}
