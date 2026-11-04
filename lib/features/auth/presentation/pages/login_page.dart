import 'package:flutter/material.dart';
import '../../../../app.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/storage_service.dart';
import '../components/auth_banner.dart';
import '../components/login_form.dart';
import '../viewmodels/login_viewmodel.dart';

/// User Login Page featuring top dark banner with PayrollNeo logo
/// and bottom outline login form with runtime server configuration.
class LoginPage extends StatefulWidget {
  final LoginViewModel? viewModel;
  final Widget Function(BuildContext)? homeBuilder;

  const LoginPage({super.key, this.viewModel, this.homeBuilder});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _onSuccess(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: widget.homeBuilder != null
            ? widget.homeBuilder!
            : (_) => const MainNavigationScreen(),
      ),
    );
  }

  Future<void> _showServerSettings(BuildContext context) async {
    final controller = TextEditingController(text: ApiEndpoints.baseUrl);
    String? statusMessage;
    bool isSuccess = false;
    bool isTesting = false;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: const Row(
              children: [
                Icon(Icons.dns_outlined, color: AppColors.primary),
                SizedBox(width: 8),
                Text('Server Connection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Set the backend host for real devices on Wi-Fi, emulator, or USB reverse:',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Base URL',
                    hintText: 'http://192.168.1.153:4002',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: [
                    ActionChip(
                      label: const Text('Wi-Fi', style: TextStyle(fontSize: 11)),
                      onPressed: () => setDialogState(() {
                        controller.text = 'http://192.168.1.153:4002';
                      }),
                    ),
                    ActionChip(
                      label: const Text('Emulator', style: TextStyle(fontSize: 11)),
                      onPressed: () => setDialogState(() {
                        controller.text = 'http://10.0.2.2:4002';
                      }),
                    ),
                    ActionChip(
                      label: const Text('USB adb', style: TextStyle(fontSize: 11)),
                      onPressed: () => setDialogState(() {
                        controller.text = 'http://localhost:4002';
                      }),
                    ),
                  ],
                ),
                if (statusMessage != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        isSuccess ? Icons.check_circle : Icons.error,
                        size: 16,
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          statusMessage!,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: isSuccess ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: isTesting
                    ? null
                    : () async {
                        setDialogState(() {
                          isTesting = true;
                          statusMessage = 'Testing connectivity...';
                        });
                        try {
                          ApiEndpoints.setBaseUrl(controller.text);
                          AppGraphQLClient.resetClient();
                          final ok = await AppGraphQLClient.verifyConnectivity();
                          setDialogState(() {
                            isSuccess = ok;
                            statusMessage = ok ? 'Connected successfully!' : 'Connection failed';
                            isTesting = false;
                          });
                        } catch (e) {
                          setDialogState(() {
                            isSuccess = false;
                            statusMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
                            isTesting = false;
                          });
                        }
                      },
                child: isTesting
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Test Connection'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final newUrl = controller.text.trim();
                  if (newUrl.isNotEmpty) {
                    ApiEndpoints.setBaseUrl(newUrl);
                    final storage = await StorageService.getInstance();
                    await storage.setString(StorageService.keyApiBaseUrl, ApiEndpoints.baseUrl);
                    AppGraphQLClient.resetClient();
                  }
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final bannerHeight = (screenHeight * 0.28).clamp(180.0, 240.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Top Dark Banner with PayrollNeo Logo & Server icon
              Stack(
                children: [
                  AuthBanner(height: bannerHeight),
                  Positioned(
                    top: 40,
                    right: 12,
                    child: IconButton(
                      icon: const Icon(Icons.settings_ethernet, color: Colors.white70, size: 22),
                      tooltip: 'Server Settings',
                      onPressed: () => _showServerSettings(context),
                    ),
                  ),
                ],
              ),

              // 2. Form Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LoginForm(
                          viewModel: widget.viewModel,
                          onLoginSuccess: () => _onSuccess(context),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _showServerSettings(context),
                          child: Text(
                            'Server: ${ApiEndpoints.baseUrl}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
