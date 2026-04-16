import 'package:flutter/material.dart';
import '../models/article.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;
  final bool isFavorite;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Hero(
                    tag: 'article_image_${article.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        article.imageUrl,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 190,
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (isFavorite)
                    const Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.favorite, color: Colors.red, size: 18),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      article.author,
                      style: TextStyle(color: Colors.grey.shade700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(
                    article.date,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}