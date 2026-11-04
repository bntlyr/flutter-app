import 'package:flutter/material.dart';
import 'package:flutter_app/features/portal/portal_screen.dart';

/// Dashboard Page (Employee Portal) presenting clock, action buttons,
/// attendance alerts, and payroll summaries.
class DashboardPage extends StatelessWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const DashboardPage({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    return PortalScreen(onNavigateToTab: onNavigateToTab);
  }
}
