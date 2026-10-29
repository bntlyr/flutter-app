import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_requests_data.dart';
import '../../../data/models/request_model.dart';
import '../../shared/status_badge.dart';

class StatusScreen extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const StatusScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final MockRequestsRepository _repo = MockRequestsRepository();
  RequestStatus? _selectedStatusFilter;
  RequestType? _selectedTypeFilter;

  @override
  void initState() {
    super.initState();
    _repo.addListener(_onRepoChanged);
  }

  @override
  void dispose() {
    _repo.removeListener(_onRepoChanged);
    super.dispose();
  }

  void _onRepoChanged() {
    if (mounted) setState(() {});
  }

  void _confirmCancel(UserRequest request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: Text('Are you sure you want to cancel request "${request.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('No, Keep It'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              _repo.cancelRequest(request.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Request ${request.id} has been cancelled.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Yes, Cancel Request'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final allRequests = _repo.requests;
    final filtered = allRequests.where((req) {
      if (_selectedStatusFilter != null && req.status != _selectedStatusFilter) {
        return false;
      }
      if (_selectedTypeFilter != null && req.type != _selectedTypeFilter) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Action Bar with Add Request Action
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Request Tracker',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${allRequests.length} total filed requests',
                            style: const TextStyle(fontSize: 12, color: AppColors.grayLight),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => widget.onNavigateToTab?.call(2), // Navigate to Request Page
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      ),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Request'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Status Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Statuses'),
                    selected: _selectedStatusFilter == null,
                    onSelected: (val) {
                      setState(() {
                        _selectedStatusFilter = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...RequestStatus.values.map((status) {
                    final isSelected = _selectedStatusFilter == status;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(status.label),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            _selectedStatusFilter = val ? status : null;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Request Cards Feed
            if (filtered.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: AppColors.grayLight),
                      const SizedBox(height: 12),
                      const Text(
                        'No requests match the selected filter',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Try choosing another filter or create a new request.',
                        style: TextStyle(fontSize: 12, color: AppColors.grayLight),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => widget.onNavigateToTab?.call(2),
                        icon: const Icon(Icons.add),
                        label: const Text('File a Request Now'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final req = filtered[i];
                  return _buildRequestCard(req);
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestCard(UserRequest req) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Type, Title, and Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grayBorder),
                  ),
                  child: Icon(req.type.icon, size: 20, color: AppColors.gray),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${req.id} • Filed ${AppFormatters.dateShort(req.filingDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grayLight,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: req.status),
              ],
            ),
            const SizedBox(height: 12),

            // Description / Details
            Text(
              req.description,
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.grayBorder),
            const SizedBox(height: 10),

            // Bottom Approver Info & Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.supervised_user_circle_outlined, size: 16, color: AppColors.grayLight),
                    const SizedBox(width: 6),
                    Text(
                      'Approver: ${req.approver}',
                      style: const TextStyle(fontSize: 11, color: AppColors.grayLight),
                    ),
                  ],
                ),
                if (req.status == RequestStatus.pending)
                  TextButton.icon(
                    onPressed: () => _confirmCancel(req),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      visualDensity: VisualDensity.compact,
                    ),
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: const Text('Cancel', style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
