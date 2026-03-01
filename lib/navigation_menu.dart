import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:iconsax/iconsax.dart';
import 'package:stock_app/features/news/screens/news_list/news_list_screen.dart';
import 'features/stocks/screens/market/market_screen.dart';
import 'features/profile/screens/profile/profile_screen.dart';

final bottomNavIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class NavigationMenu extends ConsumerWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final theme = Theme.of(context);

    final screens = [
      const MarketScreen(),
      const NewsListScreen(),
      const ProfileScreen()
    ];

    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBarTheme(

        data: NavigationBarThemeData(
          indicatorShape: const CircleBorder(),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),

        ),

        child: NavigationBar(
          height: 90,
          elevation: 0,

          backgroundColor:theme.colorScheme.surface,
          indicatorColor: theme.colorScheme.primary,
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          destinations: [

            NavigationDestination(
              icon: const Icon(Iconsax.chart, color: Colors.grey, size: 24),
              selectedIcon: const Icon(Iconsax.chart, color: Colors.black, size: 24),
              label: 'Market',
            ),

            NavigationDestination(
              icon: const Icon(Iconsax.document_text, color: Colors.grey, size: 24),
              selectedIcon: const Icon(Iconsax.document_text, color: Colors.black, size: 24),
              label: 'News',
            ),

            NavigationDestination(
              icon: const Icon(Iconsax.user, color: Colors.grey, size: 24),
              selectedIcon: const Icon(Iconsax.user, color: Colors.black, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}