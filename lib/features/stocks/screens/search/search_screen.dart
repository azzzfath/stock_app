import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/search_provider.dart';
import '../../providers/search_history_provider.dart';
import 'widgets/search_result_list.dart';
import 'widgets/search_history_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchResults = ref.watch(searchProvider);
    final isLoading = ref.watch(isSearchLoadingProvider);
    final searchHistory = ref.watch(searchHistoryProvider);

    return Scaffold(
      appBar: AppBar(

        // Search Bar
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search..',
            hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
            border: InputBorder.none,
          ),
          onSubmitted: (value) {
            ref.read(searchProvider.notifier).searchStocks(value);
          },
        ),

        // Empty search bar
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              ref.read(searchProvider.notifier).clear();
            },
          )
        ],

      ),


      body: Column(
        children: [
          if (isLoading) const LinearProgressIndicator(),
          Expanded(
            child: searchResults.isEmpty && !isLoading
                ? SearchHistoryList(history: searchHistory)
                : SearchResultList(results: searchResults),
          ),
        ],
      ),



    );
  }
}