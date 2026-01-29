import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';

/// App shell with adaptive navigation:
/// - NavigationBar (< 600 dp, compact)
/// - NavigationRail (≥ 600 dp, medium / expanded)
///
/// Material Symbols Rounded: outlined = inactive, filled = active.
class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Accueil',
    ),
    NavigationDestination(
      icon: Icon(Icons.view_kanban_outlined),
      selectedIcon: Icon(Icons.view_kanban),
      label: 'Pipeline',
    ),
    NavigationDestination(
      icon: Icon(Icons.more_horiz_outlined),
      selectedIcon: Icon(Icons.more_horiz),
      label: 'Plus',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      selectedIndex: navigationShell.currentIndex,
      onSelectedIndexChange: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: _destinations,
      body: (_) => navigationShell,
      smallBody: (_) => navigationShell,
      useDrawer: false,
    );
  }
}
