class Article {
  final int id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String date;
  final String category;
  final String author;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.date,
    required this.category,
    required this.author,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] ?? 0;

    final categories = [
      'Technology',
      'Business',
      'Sports',
      'Education',
      'Health',
    ];

    final authors = [
      'Admin',
      'News Editor',
      'Daily Reporter',
      'Tech Writer',
      'Global Desk',
    ];

    return Article(
      id: id,
      title: json['title'] ?? 'No title',
      description: (json['body'] ?? 'No description').toString(),
      content: (json['body'] ?? 'No content').toString(),
      imageUrl: 'https://picsum.photos/seed/news$id/800/500',
      date: '2026-04-${(id % 28 + 1).toString().padLeft(2, '0')}',
      category: categories[id % categories.length],
      author: authors[id % authors.length],
    );
  }
}