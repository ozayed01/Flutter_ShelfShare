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
            keyboardType: TextInputType.emailAddress,
            onSubmitted: (value) {
              print(_searchControllr.text);
            },
            controller: _searchControllr,
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              prefixIcon: const Icon(
                Icons.search,
              ),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Search',
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            ),
          ),
        ],
      ),
      body: const Text("this is search"),
    );
  }
}
