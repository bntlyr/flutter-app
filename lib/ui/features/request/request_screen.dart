import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_formatters.dart';
import '../../../data/mock/mock_requests_data.dart';
import '../../../data/models/request_model.dart';
import '../../shared/section_header.dart';

class RequestScreen extends StatefulWidget {
  final Function(int targetIndex)? onNavigateToTab;

  const RequestScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestCategoryItem {
  final RequestType type;
  final String title;
  final String subtitle;
  final String badge;
  final Color accentColor;

  const _RequestCategoryItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.accentColor,
  });
}

class _RequestScreenState extends State<RequestScreen> {
  late DateTime _filingDate;

  static const List<_RequestCategoryItem> _categories = [
    _RequestCategoryItem(
      type: RequestType.leave,
      title: 'Leave Application',
      subtitle: 'Vacation, Sick, Emergency, Bereavement',
      badge: '14.5 days credit',
      accentColor: AppColors.primary,
    ),
    _RequestCategoryItem(
      type: RequestType.timelogsCorrection,
      title: 'Timelogs Correction',
      subtitle: 'Missed time-in/out or punch fix',
      badge: 'Punches & Logs',
      accentColor: Colors.orange,
    ),
    _RequestCategoryItem(
      type: RequestType.allowance,
      title: 'Allowance & Reimbursement',
      subtitle: 'Project travel, onsite meals, claims',
      badge: 'Expense Claim',
      accentColor: Colors.teal,
    ),
    _RequestCategoryItem(
      type: RequestType.overtime,
      title: 'Overtime (OT) Request',
      subtitle: 'Pre-approval & hours beyond shift',
      badge: 'OT Compensation',
      accentColor: Colors.blue,
    ),
    _RequestCategoryItem(
      type: RequestType.dayOffWork,
      title: 'Day Off Work',
      subtitle: 'Rest day duty & legal holiday work',
      badge: 'Available',
      accentColor: Colors.indigo,
    ),
    _RequestCategoryItem(
      type: RequestType.reshift,
      title: 'Reshift / Shift Swap',
      subtitle: 'Schedule change & shift adjustment',
      badge: 'Schedule Roster',
      accentColor: Colors.deepPurple,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filingDate = DateTime.now();
  }

  void _openRequestForm(RequestType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _RequestFormSheet(
        type: type,
        filingDate: _filingDate,
        onSubmit: (newRequest) {
          MockRequestsRepository().addRequest(newRequest);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              content: Text('Successfully filed ${type.label} Request (${newRequest.id})!'),
              action: SnackBarAction(
                label: 'View Status',
                textColor: Colors.white,
                onPressed: () => widget.onNavigateToTab?.call(3),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

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
          // Filing Date Card
          Card(
            color: AppColors.gray,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_calendar, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FILING DATE & TIME',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${AppFormatters.dateWithDay(_filingDate)} • ${AppFormatters.time(_filingDate)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Filer: Alex Morgan (#84920) • Dept: Software Engineering',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SectionHeader(
            title: 'Select Request Category',
            subtitle: 'Choose the adjustment or benefit workflow to file',
            padding: EdgeInsets.only(top: 12, bottom: 10),
          ),

          // Request Categories 2-Column Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 146,
                ),
                itemBuilder: (context, index) => _buildRequestOptionCard(_categories[index]),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildRequestOptionCard(_RequestCategoryItem item) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openRequestForm(item.type),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: item.accentColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.type.icon, color: item.accentColor, size: 20),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.accentColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.badge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: item.accentColor,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.grayLight,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestFormSheet extends StatefulWidget {
  final RequestType type;
  final DateTime filingDate;
  final ValueChanged<UserRequest> onSubmit;

  const _RequestFormSheet({
    required this.type,
    required this.filingDate,
    required this.onSubmit,
  });

  @override
  State<_RequestFormSheet> createState() => _RequestFormSheetState();
}

class _RequestFormSheetState extends State<_RequestFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _reasonController = TextEditingController();
  final _detailController = TextEditingController();
  String _subType = 'Standard';

  @override
  void initState() {
    super.initState();
    // Pre-fill sensible defaults based on request type
    switch (widget.type) {
      case RequestType.leave:
        _subType = 'Vacation Leave';
        _titleController.text = 'Vacation Leave Application';
        _detailController.text = 'Covered: Nov 03 – Nov 04, 2026 (2 days)';
        break;
      case RequestType.timelogsCorrection:
        _subType = 'Missed Punch Out';
        _titleController.text = 'Biometric Punch Correction';
        _detailController.text = 'Log Date: Oct 28, 2026 • Correct Time: 05:00 PM';
        break;
      case RequestType.allowance:
        _subType = 'Travel & Meal Allowance';
        _titleController.text = 'Client Onsite Visit Allowance';
        _detailController.text = 'Amount: ₱3,000.00 • Client: FinTech Corp';
        break;
      case RequestType.overtime:
        _subType = 'Regular Day OT';
        _titleController.text = 'Release Deployment Overtime';
        _detailController.text = 'Date: Oct 30, 2026 • 3.0 Hours (05:00 PM - 08:00 PM)';
        break;
      case RequestType.dayOffWork:
        _subType = 'Weekend Rest Day Work';
        _titleController.text = 'Saturday Database Maintenance';
        _detailController.text = 'Target Date: Nov 01, 2026 • 8.0 Hours';
        break;
      case RequestType.reshift:
        _subType = 'Shift Schedule Swap';
        _titleController.text = 'Mid-Shift Schedule Adjustment';
        _detailController.text = 'New Shift: 10:00 AM – 07:00 PM (Effective Nov 03)';
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _reasonController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final id = 'REQ-2026-${(DateTime.now().millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
      final newReq = UserRequest(
        id: id,
        type: widget.type,
        filingDate: widget.filingDate,
        title: _titleController.text.trim(),
        description: '${_detailController.text.trim()}. Reason: ${_reasonController.text.trim()}',
        status: RequestStatus.pending,
        approver: 'Jane Cooper (Lead Manager)',
        metadata: {
          'category': _subType,
          'details': _detailController.text.trim(),
        },
      );
      widget.onSubmit(newReq);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + keyboardPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(widget.type.icon, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'File ${widget.type.label} Request',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Filing Date: ${AppFormatters.dateWithDay(widget.filingDate)}',
                style: const TextStyle(fontSize: 12, color: AppColors.grayLight),
              ),
              const Divider(height: 24),

              // Title field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Request Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 12),

              // Schedule / Details field
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(
                  labelText: 'Dates / Scope / Hours Detail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.info_outline),
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please provide details' : null,
              ),
              const SizedBox(height: 12),

              // Reason / Justification field
              TextFormField(
                controller: _reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Justification / Business Reason',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) => (val == null || val.isEmpty) ? 'Please enter a reason' : null,
              ),
              const SizedBox(height: 18),

              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit Request for Approval'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}