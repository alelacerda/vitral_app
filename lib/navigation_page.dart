import 'dart:io';

import 'package:flutter/material.dart';
import '../components/rounded_button.dart';
import '../models/location.dart';
import '../models/article.dart';
import '../uikit/custom_icons.dart';
import '../uikit/text_style.dart';
import '../uikit/ui_colors.dart';
import 'views/about_view.dart';
import 'views/ar_view.dart';
import 'views/article_detail_view.dart';
import 'views/articles_view.dart';
import 'views/home_view.dart';
import 'views/internal_map_view.dart';
import 'views/locations_view.dart';
import 'views/temporary_view.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_drawer_menu.dart';
import 'widgets/custom_nav_bar.dart';
import 'package:flutter/services.dart';

enum SecondaryView {
  aboutTheProject,
  temporaryView,
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});
  static const MethodChannel _methodChannel = MethodChannel('ar_view_channel');

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  // MARK: - State variables
  int _selectedIndex = 0;
  SecondaryView? _secondaryView;

  // MARK: - Global keys
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // MARK: - Notifiers
  final ValueNotifier<bool> _showBackButtonNotifier = ValueNotifier<bool>(false);

  // MARK: - Bottom sheet controller
  PersistentBottomSheetController? _bottomSheetController;

  

  // MARK: - Navigation methods
  void navigateToArticleDetails(Article article) {
    final navigatorKey = navigatorKeys[2];
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(article: article),
      ),
    );
    updateBackButtonState();
  }

  void navigateToArticleDetailsFromAR(BuildContext arContext, Article article) {
    //pop the ARView
    Navigator.of(arContext).pop();

    // navigate to the article detail view
    final navigatorKey = navigatorKeys[2];
    _onItemTapped(2);
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => ArticleDetailView(article: article),
      ),
    );
    updateBackButtonState();
  }

  void navigateToInternalMap(BuildContext context, Location location) {
    Navigator.of(context).pop();

    final navigatorKey = navigatorKeys[1];
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => InternalMapView(imageUrl: location.internalMapUrl),
      ),
    );
    updateBackButtonState();
  }

  void navigateToSecondaryView(SecondaryView view) {
    setState(() {
      _secondaryView = view;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _secondaryView = null;
    });
    navigatorKeys[_selectedIndex].currentState?.popUntil((route) => route.isFirst);
    updateBackButtonState();
    dismissBottomSheet();
  }

  void _onWillPop(bool value) async {
    final isFirstRouteInCurrentTab = !await navigatorKeys[_selectedIndex]
        .currentState!
        .maybePop();
    if (isFirstRouteInCurrentTab && mounted) {
      Navigator.of(context).pop();
    }
    updateBackButtonState();
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => PopScope(
            onPopInvokedWithResult: (value, result) {
              if (navigatorKeys[index].currentState!.canPop()) {
                navigatorKeys[index].currentState!.pop();
                updateBackButtonState();
              }
            },
            child: child,
          ),
        );
      },
    );
  }

  // MARK: - Bottom sheet methods
  void showLocationDetailsBottomSheet(BuildContext context, Location location) {
    _bottomSheetController?.close();
    _bottomSheetController = showBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 64,
      ),
      elevation: 2.0,
      backgroundColor: UIColor.lightLilac,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: CustomTextStyle.title2.copyWith(
                      color: UIColor.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location.address,
                    style: CustomTextStyle.body2.copyWith(
                      color: UIColor.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundedButton(
                    text: 'Iniciar',
                    iconName: CustomIcons.start,
                    onPressed: () {

                      if (Platform.isAndroid) {
                        NavigationPage._methodChannel.invokeMethod('launchAndroidActivity');

                      } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ARView(onNavigateToArticle: navigateToArticleDetailsFromAR),
                          fullscreenDialog: true,
                        ),
                      );
                      }
                    },
                    color: UIColor.purple,
                    textColor: UIColor.white,
                  ),
                  RoundedButton(
                    text: 'Ver mapa interno',
                    onPressed: () {
                      navigateToInternalMap(context, location);
                    },
                    color: UIColor.white,
                    textColor: UIColor.purple,
                    borderColor: UIColor.purple,
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void dismissBottomSheet() {
    _bottomSheetController?.close();
  }

  // MARK: - UI update methods
  Future<void> updateBackButtonState() async {
    bool canPop = navigatorKeys[_selectedIndex].currentState?.canPop() ?? false;
    _showBackButtonNotifier.value = canPop;
  }

  Widget _buildCustomView() {
    switch (_secondaryView) {
      case SecondaryView.aboutTheProject:
        return const AboutView();
      case SecondaryView.temporaryView:
        return const TemporaryView();
      default:
        return const Text('View not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, result) => _onWillPop(value),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder<bool>(
            valueListenable: _showBackButtonNotifier,
            builder: (context, showBackButton, child) {
              return CustomAppBar(
                title: 'vitRAl',
                onLeftButtonPressed: () {
                  if (showBackButton) {
                    navigatorKeys[_selectedIndex].currentState?.pop();
                    updateBackButtonState();
                  } else {
                    _scaffoldKey.currentState?.openDrawer();
                  }
                },
                onRightButtonPressed: () {},
                leftIcon: Icons.menu_rounded,
                rightIcon: Icons.help_outline,
                showBackButton: showBackButton,
                hideLogo: _selectedIndex == 0 && _secondaryView == null,
              );
            },
          ),
        ),
        drawer: CustomDrawerMenu(onNavigate: navigateToSecondaryView),
        body: _secondaryView != null
            ? _buildCustomView()
            : IndexedStack(
                index: _selectedIndex,
                children: [
                  _buildNavigator(0, HomeView(onNavigate: _onItemTapped)),
                  _buildNavigator(1, LocationsView(openLocationDetails: showLocationDetailsBottomSheet)),
                  _buildNavigator(2, ArticlesView(onNavigate: navigateToArticleDetails)),
                ],
              ),
        bottomNavigationBar: CustomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
