import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_view_model.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách yêu thích'),
      ),
      body: vm.favoriteArticles.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 70, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Chưa có bài viết yêu thích',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Hãy quay lại màn hình chi tiết để thêm bài viết vào yêu thích.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: vm.favoriteArticles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final article = vm.favoriteArticles[index];
          return ArticleCard(
            article: article,
            isFavorite: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}