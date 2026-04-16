import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.take(30).map((item) => Article.fromJson(item)).toList();
    } else {
      throw Exception('Không thể tải dữ liệu từ API');
    }
  }
}