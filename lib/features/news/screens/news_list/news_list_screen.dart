import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_app/features/news/screens/news_list/widgets/news_card.dart';
import '../../providers/news_provider.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);

    return Scaffold(

      body: RefreshIndicator(
        onRefresh: () => ref.refresh(newsProvider.future),
        child: CustomScrollView(
          slivers: [

            SliverAppBar(
              floating: true,
              snap: true,
              toolbarHeight: 80,
              titleSpacing: 24,
              centerTitle: false,
              title: const Text(
                "News",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),


            newsAsync.when(

              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),

              error: (err, _) => SliverFillRemaining(
                child: Center(child: Text('$err')),
              ),

              data: (newsList) => SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => NewsCard(news: newsList[index]),
                    childCount: newsList.length,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}