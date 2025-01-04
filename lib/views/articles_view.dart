import 'package:flutter/material.dart';
import 'package:vitral_app/models/article.dart';
import '../view_models/articles_view_model.dart';
import '../components/article_card.dart';
import '../uikit/ui_colors.dart';
import '../uikit/text_style.dart';
import 'article_detail_view.dart';
import '../navigation_page.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key});

  @override
  _ArticlesViewState createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  final ArticlesViewModel viewModel = ArticlesViewModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticles().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _updateParentBackButtonState() {
    final navPageState = context.findAncestorStateOfType<NavigationPageState>();
    if (navPageState != null) {
      navPageState.updateBackButtonState();
    }
  }

  void _onCardTap(Article article) {
    final navigatorKey = context.findAncestorStateOfType<NavigationPageState>()?.navigatorKeys[2];

    navigatorKey?.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(article: article),
      ),
    );
    _updateParentBackButtonState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: UIColor.white,
        width: double.infinity,
        height: double.infinity,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0), // Add leading and trailing padding
                      child: Text(
                        viewModel.title,
                        style: CustomTextStyle.title1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16.0)),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final article = viewModel.articles[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0), // Add leading and trailing padding for cards
                          child: ArticleCard(
                            imageUrl: article.image,
                            title: article.title,
                            description: article.shortContent,
                            onCardTap: () => _onCardTap(article),
                            onButtonTap: () => _onCardTap(article),
                          ),
                        );
                      },
                      childCount: viewModel.articles.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16.0)), // Optional space at the bottom
                ],
              ),
      ),
    );
  }
}