import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'ui/features/splash/splash_screen.dart';

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
      title: 'Request Status',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.gray,
        elevation: 0,
        centerTitle: false,
        title: Image.asset(
          'assets/images/logo.png',
          height: 30,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
            tooltip: 'Account',
            onPressed: () {
              setState(() {
                _currentIndex = 5;
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          PortalView(),
          DtrView(),
          RequestView(),
          StatusView(),
          PayslipView(),
          PersonalView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
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

// ---------------------------------------------------------
// 1. Portal (Dashboard) View
// ---------------------------------------------------------
class PortalView extends StatelessWidget {
  const PortalView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = context.customColors;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Greeting Banner Card
          Card(
            color: customColors.brandPrimary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Welcome back, Alex!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 22,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Software Engineering • Employee ID: #84920',
                    style: TextStyle(
                      color: Colors.white.withAlpha(220),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Overview Stats
          Text('Today Overview', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Shift Status',
                  value: 'Clocked In',
                  subtitle: '8:02 AM Today',
                  icon: Icons.check_circle_outline,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Leave Credits',
                  value: '14.5 Days',
                  subtitle: 'Available balance',
                  icon: Icons.beach_access_outlined,
                  highlight: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Actions
          Text('Quick Shortcuts', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.timer_outlined),
                  title: const Text('View Today\'s Logs'),
                  subtitle: const Text('Check recorded ins and outs'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.add_task),
                  title: const Text('File Leave / Overtime'),
                  subtitle: const Text('Submit a new workflow request'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.receipt_outlined),
                  title: const Text('Latest Cutoff Payslip'),
                  subtitle: const Text('Released on Oct 25, 2026'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required bool highlight,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: highlight ? primary : AppColors.gray),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: highlight ? primary : AppColors.mainBlack,
              ),
            ),
            const SizedBox(height: 2),
            Text(subtitle, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. DTR (Daily Time Record) View
// ---------------------------------------------------------
class DtrView extends StatelessWidget {
  const DtrView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Clock Action Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Wednesday, Oct 29, 2026', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    '09:51 AM',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.login),
                          label: const Text('Time In'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.logout),
                          label: const Text('Time Out'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Weekly Logs Card
          Text('Weekly Logs (Oct 25 - Oct 29)', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: const [
                _DtrRow(day: 'Today (Wed)', inTime: '08:02 AM', outTime: '--:--', total: 'In Progress'),
                Divider(height: 1),
                _DtrRow(day: 'Tue, Oct 28', inTime: '08:00 AM', outTime: '05:05 PM', total: '8.0 hrs'),
                Divider(height: 1),
                _DtrRow(day: 'Mon, Oct 27', inTime: '07:55 AM', outTime: '05:02 PM', total: '8.0 hrs'),
                Divider(height: 1),
                _DtrRow(day: 'Sun, Oct 26', inTime: '--:--', outTime: '--:--', total: 'Rest Day'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DtrRow extends StatelessWidget {
  const _DtrRow({
    required this.day,
    required this.inTime,
    required this.outTime,
    required this.total,
  });

  final String day;
  final String inTime;
  final String outTime;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('$inTime  →  $outTime', style: const TextStyle(color: AppColors.gray)),
          Text(
            total,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 3. Request View
// ---------------------------------------------------------
class RequestView extends StatelessWidget {
  const RequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select Request Category', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildRequestTypeCard(
            context,
            title: 'Leave Application',
            desc: 'Vacation, Sick, Emergency, or Maternity leave',
            icon: Icons.event_available,
          ),
          const SizedBox(height: 10),
          _buildRequestTypeCard(
            context,
            title: 'Overtime (OT) Request',
            desc: 'Pre-approval and actual worked overtime hours',
            icon: Icons.more_time,
          ),
          const SizedBox(height: 10),
          _buildRequestTypeCard(
            context,
            title: 'Certificate of Employment (COE)',
            desc: 'Official work certificate with or without compensation',
            icon: Icons.document_scanner_outlined,
          ),
          const SizedBox(height: 10),
          _buildRequestTypeCard(
            context,
            title: 'Time Adjustment / Official Business',
            desc: 'File missed punch or external official meetings',
            icon: Icons.edit_calendar_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildRequestTypeCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(desc),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening form: $title')),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. Status View
// ---------------------------------------------------------
class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Submitted Requests Tracker', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          _buildStatusCard(
            context,
            type: 'Vacation Leave (3 Days)',
            date: 'Filed on Oct 27, 2026',
            status: 'PENDING',
            statusColor: Colors.orange,
            approver: 'Approver: Lead Manager',
          ),
          const SizedBox(height: 10),
          _buildStatusCard(
            context,
            type: 'Overtime (2.5 Hours)',
            date: 'Filed on Oct 24, 2026',
            status: 'APPROVED',
            statusColor: AppColors.primary,
            approver: 'Approved by Dept Head',
          ),
          const SizedBox(height: 10),
          _buildStatusCard(
            context,
            type: 'Official Business (OB)',
            date: 'Filed on Oct 19, 2026',
            status: 'APPROVED',
            statusColor: AppColors.primary,
            approver: 'Approved by HR Director',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(
    BuildContext context, {
    required String type,
    required String date,
    required String status,
    required Color statusColor,
    required String approver,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    type,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(date, style: const TextStyle(color: AppColors.gray, fontSize: 13)),
            const SizedBox(height: 6),
            Text(approver, style: const TextStyle(color: AppColors.secondaryBlack, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 5. Payslip View
// ---------------------------------------------------------
class PayslipView extends StatelessWidget {
  const PayslipView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Highlight Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Latest Cutoff', style: theme.textTheme.bodyMedium),
                      const Chip(label: Text('Oct 11 - Oct 25')),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Net Take Home Pay', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    '\$3,450.00',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF Payslip'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text('Payslip History', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Sep 26 - Oct 10, 2026'),
                  subtitle: Text('Net: \$3,450.00 • Released Oct 10'),
                  trailing: Icon(Icons.chevron_right),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('Sep 11 - Sep 25, 2026'),
                  subtitle: Text('Net: \$3,420.00 • Released Sep 25'),
                  trailing: Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 6. Personal (Profile) View
// ---------------------------------------------------------
class PersonalView extends StatelessWidget {
  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Avatar Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: primary,
                    child: const Text(
                      'AM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Alex Morgan', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 2),
                  Text('Senior Software Engineer', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('alex.morgan@company.com', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Account Details Card
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('Employee ID'),
                  trailing: Text('#84920', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.apartment_outlined),
                  title: Text('Department'),
                  trailing: Text('Engineering', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.phone_outlined),
                  title: Text('Contact Number'),
                  trailing: Text('+1 (555) 019-2834'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sign Out Action
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
