import 'package:flutter/material.dart';
import '../view_models/home_view_model.dart';
import '../components/menu_button.dart';
import '../uikit/ui_colors.dart';
import '../uikit/images.dart';

class HomeView extends StatelessWidget {
  final HomeViewModel viewModel = HomeViewModel();
  final Function(int) onNavigate;

  HomeView({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIColor.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageAssets.logoVertical, width: 218),
            const SizedBox(height: 64),
            MenuButton(
              image: ImageAssets.stars,
              text: 'Comece a interação',
              onPressed: () {
                onNavigate(1);
              },
            ),
            MenuButton(
              image: ImageAssets.magnifyingGlass,
              text: 'Conheça sobre vitrais',
              onPressed: () {
                onNavigate(2);
              },
            ),
          ],
        ),
      ),
    );
  }
}