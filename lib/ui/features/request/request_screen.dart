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

class _RequestScreenState extends State<RequestScreen> {
  late DateTime _filingDate;

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
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_calendar, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Filer: Alex Morgan (#84920) • Dept: Software Engineering',
                          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const SectionHeader(
            title: 'Select Request Category',
            subtitle: 'Choose the adjustment or benefit workflow to file',
          ),

          // Request Categories Grid
          _buildRequestOptionCard(
            type: RequestType.leave,
            title: 'Leave Application',
            subtitle: 'Vacation, Sick, Emergency, Bereavement, or Parental leave',
            badge: '14.5 days credit',
            accentColor: AppColors.primary,
          ),
          const SizedBox(height: 10),

          _buildRequestOptionCard(
            type: RequestType.timelogsCorrection,
            title: 'Timelogs Correction',
            subtitle: 'Adjust missed time-in, missed time-out, or biometric terminal glitches',
            badge: 'Punches & Logs',
            accentColor: Colors.orange,
          ),
          const SizedBox(height: 10),

          _buildRequestOptionCard(
            type: RequestType.allowance,
            title: 'Allowance & Reimbursement',
            subtitle: 'File claims for project travel, onsite meals, or client per diem',
            badge: 'Expense Claim',
            accentColor: Colors.teal,
          ),
          const SizedBox(height: 10),

          _buildRequestOptionCard(
            type: RequestType.overtime,
            title: 'Overtime (OT) Request',
            subtitle: 'Pre-approval and actual hours worked beyond standard shift',
            badge: 'OT Compensation',
            accentColor: Colors.blue,
          ),
          const SizedBox(height: 10),

          _buildRequestOptionCard(
            type: RequestType.dayOffWork,
            title: 'Day Off Work',
            subtitle: 'Authorization to work on scheduled rest days or legal holidays',
            badge: 'Available',
            accentColor: Colors.indigo,
          ),
          const SizedBox(height: 10),

          _buildRequestOptionCard(
            type: RequestType.reshift,
            title: 'Reshift / Shift Swap',
            subtitle: 'Temporary or permanent schedule change & shift adjustment',
            badge: 'Schedule Roster',
            accentColor: Colors.deepPurple,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRequestOptionCard({
    required RequestType type,
    required String title,
    required String subtitle,
    required String badge,
    required Color accentColor,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openRequestForm(type),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(type.icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: accentColor.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              color: accentColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.grayLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.grayBorder),
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
        _detailController.text = 'Amount: \$60.00 • Client: FinTech Corp';
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
