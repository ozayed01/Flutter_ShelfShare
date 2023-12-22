import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final _searchControllr = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          width: 350,
          child: TextField(
            controller: _searchControllr,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search here...',
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                print(_searchControllr.text);
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: const Text("this is search"),
    );
  }
}
