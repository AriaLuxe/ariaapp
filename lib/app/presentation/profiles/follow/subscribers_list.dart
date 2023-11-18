import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/header.dart';
import 'bloc/follow_bloc.dart';

class SubscribersList extends StatelessWidget {
  const SubscribersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Header(title: 'Subscriptores', onTap: () {
                  Navigator.pop(context);

                }),
                BlocBuilder<FollowBloc, FollowState>(
                  builder: (context, state) {
                    switch (state.subscribersStatus) {
                      case FollowStatus.error:
                        return const Center(
                          child: Text(
                            'Error al cargar subscribers',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      case FollowStatus.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case FollowStatus.success:
                        if (state.subscribers.isEmpty) {
                          return const Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 50.0),
                                  child: Text(
                                    'No se encontraron resultados',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white),

                    ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: state.subscribers.length,
                            itemBuilder: (context, index) {
                              final subscriber = state.subscribers[index];
                              return ListTile(
                                title: Text('${subscriber.nameUser} ${subscriber.lastName}'),
                                subtitle: Text(subscriber.nickName),
                                trailing: TextButton(onPressed: () {
                                }, child: const Text('Seguir'),),
                                onTap: () {

                                },
                              );
                            },
                          );
                        }
                      default:
                        return const Center(
                          child: Text(
                            'Comuníquese por email a aia@gmail.com',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
