import 'package:flutter/material.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String query) {
    // Aquí puedes realizar la búsqueda de usuarios
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: 'Buscar usuarios',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              String query = _searchController.text;
              _onSearchSubmitted(query);
            },
          ),
        ],
      ),
    );
  }
}
