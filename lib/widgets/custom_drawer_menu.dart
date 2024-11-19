import 'package:flutter/material.dart';
import 'package:vitral_app/components/drawer_button.dart' as CustomButton;
import '../components/icon_text_button.dart';
import '../components/underlined_button.dart';
import '../components/image_button.dart';
import '../uikit/custom_icons.dart';
import '../uikit/ui_colors.dart';
import '../uikit/images.dart';
import '../uikit/text_style.dart';
import '../navigation_page.dart';

class CustomDrawerMenu extends StatelessWidget {
  final Function(SecondaryView) onNavigate;

  const CustomDrawerMenu({
    super.key,
    required this.onNavigate,
  });

  // Close drawer using Scaffold
  void _closeDrawer(BuildContext context) {
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState?.isDrawerOpen ?? false) {
      scaffoldState!.closeDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: UIColor.darkPurple,
        child: Builder(
          builder: (drawerContext) {
            return Column(
              children: <Widget>[
                // Header Section
                Container(
                  padding: const EdgeInsets.only(
                    top: 40, bottom: 20, left: 40, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ImageAssets.logoHorizontal,
                        height: 45,
                      ),
                      ImageButton(
                        imagePath: CustomIcons.verticalMenu,
                        onPressed: () {
                          _closeDrawer(drawerContext);
                        },
                      ),
                    ],
                  ),
                ),

                // Buttons Section
                Container(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      CustomButton.DrawerButton(
                        iconName: CustomIcons.information,
                        text: 'Sobre o projeto',
                        onPressed: () {
                          _closeDrawer(drawerContext);
                          onNavigate(SecondaryView.aboutTheProject);
                        },
                      ),
                      CustomButton.DrawerButton(
                        iconName: CustomIcons.mail,
                        text: 'Entre em contato',
                        onPressed: () {
                          _closeDrawer(drawerContext);
                          onNavigate(SecondaryView.temporaryView);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32.0),

                // Settings Section
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    padding: const EdgeInsets.only(
                      top: 32, left: 24, right: 24, bottom: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Configurações'.toUpperCase(),
                          style: CustomTextStyle.title2.copyWith(
                            color: UIColor.black,
                          ),
                        ),
                        const SizedBox(height: 40),
                        IconTextButton(
                          iconName: CustomIcons.accessibility,
                          text: "Acessibilidade",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                        const SizedBox(height: 32),
                        IconTextButton(
                          iconName: CustomIcons.languages,
                          text: "Idiomas",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                        const SizedBox(height: 32),
                        IconTextButton(
                          iconName: CustomIcons.theme,
                          text: "Mudar tema",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                        const SizedBox(height: 32),
                        IconTextButton(
                          iconName: CustomIcons.help,
                          text: "Ajuda",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                        const SizedBox(height: 32),
                        UnderlinedButton(
                          text: "Política de Privacidade",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                        const SizedBox(height: 16),
                        UnderlinedButton(
                          text: "Termos de Uso",
                          onPressed: () {
                            _closeDrawer(drawerContext);
                            onNavigate(SecondaryView.temporaryView);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
