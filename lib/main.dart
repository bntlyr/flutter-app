import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'ui/features/dtr/dtr_screen.dart';
import 'ui/features/payslip/payslip_screen.dart';
import 'ui/features/personal/personal_screen.dart';
import 'ui/features/portal/portal_screen.dart';
import 'ui/features/request/request_screen.dart';
import 'ui/features/splash/splash_screen.dart';
import 'ui/features/status/status_screen.dart';
import 'ui/common/request_modal_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayrollNeo Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        overscroll: false,
        physics: const BouncingScrollPhysics(),
      ),
      home: const SplashScreen(
        nextScreen: MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<NavigationDestinationItem> _destinations = const [
    NavigationDestinationItem(
      label: 'Portal',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      title: 'Employee Portal',
    ),
    NavigationDestinationItem(
      label: 'DTR',
      icon: Icons.access_time_outlined,
      selectedIcon: Icons.access_time_filled,
      title: 'Daily Time Record',
    ),
    NavigationDestinationItem(
      label: 'Request',
      icon: Icons.post_add_outlined,
      selectedIcon: Icons.post_add,
      title: 'Submit Request',
    ),
    NavigationDestinationItem(
      label: 'Status',
      icon: Icons.fact_check_outlined,
      selectedIcon: Icons.fact_check,
      title: 'Request Status Tracker',
    ),
    NavigationDestinationItem(
      label: 'Payslip',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      title: 'Payroll & Payslips',
    ),
    NavigationDestinationItem(
      label: 'Personal',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      title: 'Personal Profile',
    ),
  ];

  void _navigateToTab(int index) {
    if (index == 2) {
      // Tapping "Request" tab in dock menu navigates to Status menu (index 3) and immediately opens Add Request modal
      setState(() {
        _currentIndex = 3;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          RequestModalDialog.show(context: context);
        }
      });
      return;
    }

    if (index >= 0 && index < _destinations.length) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentDest = _destinations[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'PayrollNeo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                currentDest.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Attendance & Request Alerts',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All notifications are up to date.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            tooltip: 'View Profile',
            onPressed: () => _navigateToTab(5),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PortalScreen(onNavigateToTab: _navigateToTab),
          DtrScreen(onNavigateToTab: _navigateToTab),
          RequestScreen(onNavigateToTab: _navigateToTab),
          StatusScreen(onNavigateToTab: _navigateToTab),
          const PayslipScreen(),
          const PersonalScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _navigateToTab,
        destinations: _destinations.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            selectedIcon: Icon(item.selectedIcon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationDestinationItem {
  const NavigationDestinationItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.title,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String title;
}
