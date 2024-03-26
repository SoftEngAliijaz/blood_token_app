import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<String> _items = List.generate(50, (index) => 'Item $index');

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = _items
        .where((item) => item.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _clearSearch();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildListItem(filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchText = '';
    });
  }

  Widget _buildListItem(String item) {
    return ListTile(
      title: Text(item),
      onTap: () {
        // Handle item tap
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
