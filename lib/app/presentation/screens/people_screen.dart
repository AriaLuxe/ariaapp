import 'package:ariapp/app/domain/entities/user_aria.dart';
import 'package:ariapp/app/infrastructure/data_sources/users_data_provider.dart';
import 'package:ariapp/app/presentation/widgets/search_users.dart';
import 'package:flutter/material.dart';

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<UserAria>? users;

  final usersDataProvider = UsersDataProvider();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const SearchUser(),
          Expanded(
            child: Container(
              height: 500.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: FutureBuilder<List<UserAria>>(
                  future: usersDataProvider.getUsers(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          UserAria user = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 16,
                                  children: [
                                    Column(
                                      children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.blue,
                                          child: Icon(Icons.person,
                                              color: Colors.white),
                                        ),
                                        const SizedBox(
                                          height: 6.0,
                                        ),
                                        Text(
                                          user.nameUser,
                                          style: const TextStyle(
                                            color: Color(
                                                0xFF202248), //Colors.blueGrey,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                      );
                    } else {
                      return const Center(
                        child: Text('loading'),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
