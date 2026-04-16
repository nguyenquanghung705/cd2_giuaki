import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/news_view_model.dart';
import '../widgets/article_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal News App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade700,
                  Colors.blue.shade400,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Xin chào 👋',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Khám phá tin tức mới nhất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    vm.searchArticles(value);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm theo tiêu đề...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        vm.searchArticles('');
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear),
                    )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vm.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = vm.categories[index];
                      final isSelected = vm.selectedCategory == category;

                      return ChoiceChip(
                        label: Text(
                          category,
                          style: TextStyle(
                            color: isSelected ? Colors.blue : Colors.black87, // 👈 FIX CHÍNH
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          vm.filterByCategory(category);
                        },

                        // nền
                        selectedColor: Colors.white,
                        backgroundColor: Colors.white,

                        // viền
                        side: BorderSide(
                          color: isSelected ? Colors.blue : Colors.grey.shade300,
                          width: 1.5,
                        ),

                        // dấu tick
                        checkmarkColor: Colors.blue,
                        showCheckmark: true,

                        // bo góc đẹp hơn
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (vm.errorMessage.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(vm.errorMessage)),
                    );
                  });

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.wifi_off, size: 70, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text(
                            'Không thể tải dữ liệu',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            vm.errorMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: vm.fetchArticles,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (vm.articles.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: vm.refreshArticles,
                    child: ListView(
                      children: const [
                        SizedBox(height: 180),
                        Center(
                          child: Column(
                            children: [
                              Icon(Icons.article_outlined, size: 70, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Không có bài báo phù hợp',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: vm.refreshArticles,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: vm.articles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final article = vm.articles[index];

                      return ArticleCard(
                        article: article,
                        isFavorite: vm.isFavorite(article),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}