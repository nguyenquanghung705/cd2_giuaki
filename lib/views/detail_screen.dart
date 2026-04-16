import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../viewmodels/news_view_model.dart';

class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewsViewModel>(context);
    final isFavorite = vm.isFavorite(article);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết tin tức'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'article_image_${article.id}',
              child: Image.network(
                article.imageUrl,
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 260,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Chip(
                        label: Text(article.category),
                        avatar: const Icon(Icons.category, size: 18),
                      ),
                      Chip(
                        label: Text(article.date),
                        avatar: const Icon(Icons.calendar_today, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        child: Icon(Icons.person, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        article.author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${article.content}\n\n${article.content}\n\n${article.content}',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await vm.toggleFavorite(article);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    vm.isFavorite(article)
                                        ? 'Đã thêm vào yêu thích'
                                        : 'Đã xóa khỏi yêu thích',
                                  ),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                          ),
                          label: Text(
                            isFavorite ? 'Đã yêu thích' : 'Yêu thích',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}