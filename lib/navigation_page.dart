import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/articles_view.dart';
import 'views/locations_view.dart';
import 'views/temporary_view.dart';
import 'views/about_view.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_nav_bar.dart';
import 'widgets/custom_drawer_menu.dart';

enum SecondaryView {
  aboutTheProject,
  temporaryView,
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => NavigationPageState();
}

class NavigationPageState extends State<NavigationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  SecondaryView? _secondaryView;

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final ValueNotifier<bool> _showBackButtonNotifier = ValueNotifier<bool>(false);

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
  }

  Future<void> updateBackButtonState() async {
    bool canPop = await navigatorKeys[_selectedIndex].currentState?.canPop() ?? false;
    _showBackButtonNotifier.value = canPop;
  }

  void _onWillPop(bool value) async {
    final isFirstRouteInCurrentTab = !await navigatorKeys[_selectedIndex]
        .currentState!
        .maybePop();
    if (isFirstRouteInCurrentTab) {
      Navigator.of(context).pop();
    }
    updateBackButtonState();
  }

  Widget _buildCustomView() {
    switch (_secondaryView) {
      case SecondaryView.aboutTheProject:
        return const AboutView();
      case SecondaryView.temporaryView:
        return const TemporaryView();
      default:
        return Container(child: const Text('View not found'));
    }
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => PopScope(
            onPopInvoked: (value) {
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) => _onWillPop(value),
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
                  _buildNavigator(1, LocationsView()),
                  _buildNavigator(2, ArticlesView()),
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
