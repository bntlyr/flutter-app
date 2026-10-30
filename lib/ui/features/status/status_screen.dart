import 'package:flutter/material.dart';
import '../../common/calendar/calendar_date.dart';
import '../../common/request/request_modal_dialog.dart';
import '../../common/request/request_view_dialog.dart';

class RequestItem {
  final String id;
  final String type;
  final String status;
  final String dateLabel;
  final String dateValue;
  final String filingDate;
  final String? details;
  final String? leaveType;
  final String? allowanceType;
  final String? timeIn;
  final String? timeOut;
  final String? dayoffType;
  final String? workStart;
  final String? workBreakStart;
  final String? workBreakEnd;
  final String? workEnd;
  final String? totalHours;
  final String? preApprovedBy;
  final String? preApprovedDate;
  final String? approvedBy;
  final String? approvedDate;
  final String? rejectedBy;
  final String? rejectedDate;
  final String? locationTitle;
  final String? locationAddress;
  final double? latitude;
  final double? longitude;

  const RequestItem({
    required this.id,
    required this.type,
    required this.status,
    required this.dateLabel,
    required this.dateValue,
    required this.filingDate,
    this.details,
    this.leaveType,
    this.allowanceType,
    this.timeIn,
    this.timeOut,
    this.dayoffType,
    this.workStart,
    this.workBreakStart,
    this.workBreakEnd,
    this.workEnd,
    this.totalHours,
    this.preApprovedBy,
    this.preApprovedDate,
    this.approvedBy,
    this.approvedDate,
    this.rejectedBy,
    this.rejectedDate,
    this.locationTitle,
    this.locationAddress,
    this.latitude,
    this.longitude,
  });
}

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
  String? _selectedDateRange;
  int _pageSize = 10;
  int _currentPage = 0;

  final LayerLink _dateLayerLink = LayerLink();
  OverlayEntry? _dateOverlayEntry;

  final List<RequestItem> _allRequests = [
    const RequestItem(
      id: 'REQ-01',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'October 02, 2026 (H)',
      filingDate: 'October 14, 2026',
      leaveType: 'Vacation',
      details: 'Half-day emergency personal leave',
      approvedBy: 'Paul Javinez',
      approvedDate: 'October 14, 2026 10:30',
    ),
    const RequestItem(
      id: 'REQ-02',
      type: 'Allowance',
      status: 'Rejected',
      dateLabel: 'Date',
      dateValue: 'May 01, 2026',
      filingDate: 'May 15, 2026',
      allowanceType: 'Perfect Attendance',
      details: 'Request for allowance and perfect attendance from May1-15,2026. TY',
      rejectedBy: 'Paul Javinez',
      rejectedDate: 'May 18, 2026 09:53',
    ),
    const RequestItem(
      id: 'REQ-03',
      type: 'Allowance',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'April 16, 2026',
      filingDate: 'May 01, 2026',
      allowanceType: 'Perfect Attendance',
      details: 'Request for allowance and perfect attendance from April16-30,2026',
      approvedBy: 'Paul Javinez',
      approvedDate: 'May 04, 2026 11:00',
    ),
    const RequestItem(
      id: 'REQ-04',
      type: 'Timelogs Correction',
      status: 'Pending',
      dateLabel: 'Date',
      dateValue: 'September 16, 2025',
      filingDate: 'September 16, 2025',
      timeIn: '--',
      timeOut: '00:00',
      details: 'Didnt appear time out',
    ),
    const RequestItem(
      id: 'REQ-05',
      type: 'Timelogs Correction',
      status: 'Pre-Approved',
      dateLabel: 'Date',
      dateValue: 'August 26, 2025',
      filingDate: 'August 26, 2025',
      timeIn: '--',
      timeOut: '00:00',
      details: 'Not appear my time out in biometrics',
      preApprovedBy: 'Panisales, Christine Mae',
      preApprovedDate: 'August 26, 2025 16:27',
    ),
    const RequestItem(
      id: 'REQ-06',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Start / End',
      dateValue: 'August 11, 2026 / August 14, 2026',
      filingDate: 'August 10, 2026',
      leaveType: 'Vacation',
      details: 'Annual summer vacation leave (4 days)',
      approvedBy: 'Paul Javinez',
      approvedDate: 'August 10, 2026 14:15',
    ),
    const RequestItem(
      id: 'REQ-07',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'May 05, 2026 (H)',
      filingDate: 'May 05, 2026',
      leaveType: 'Sick',
      details: 'Half-day personal business',
      approvedBy: 'Paul Javinez',
      approvedDate: 'May 05, 2026 09:00',
    ),
    const RequestItem(
      id: 'REQ-08',
      type: 'Timelogs Correction',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'April 23, 2026',
      filingDate: 'April 23, 2026',
      timeIn: '08:30',
      timeOut: '17:30',
      details: 'Missed clock-out log adjustment',
      approvedBy: 'Paul Javinez',
      approvedDate: 'April 23, 2026 18:00',
    ),
    const RequestItem(
      id: 'REQ-09',
      type: 'Overtime',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'February 15, 2026',
      filingDate: 'February 16, 2026',
      details: 'System deployment weekend overtime',
      approvedBy: 'Paul Javinez',
      approvedDate: 'February 16, 2026 11:45',
    ),
    const RequestItem(
      id: 'REQ-10',
      type: 'Dayoff Work',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 20, 2026',
      filingDate: 'January 22, 2026',
      dayoffType: 'General',
      details: 'Weekend emergency on-call support',
      approvedBy: 'Paul Javinez',
      approvedDate: 'January 22, 2026 13:00',
    ),
    const RequestItem(
      id: 'REQ-11',
      type: 'Overtime',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 18, 2026',
      filingDate: 'January 19, 2026',
      details: 'Weekend deployment coverage',
      approvedBy: 'Paul Javinez',
      approvedDate: 'January 19, 2026 10:00',
    ),
    const RequestItem(
      id: 'REQ-12',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 15, 2026 (H)',
      filingDate: 'January 12, 2026',
      leaveType: 'Vacation',
      details: 'Personal errands half-day leave',
      approvedBy: 'Paul Javinez',
      approvedDate: 'January 12, 2026 15:30',
    ),
    const RequestItem(
      id: 'REQ-13',
      type: 'Allowance',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 20, 2026',
      filingDate: 'January 22, 2026',
      details: 'Client onsite travel reimbursement',
      approvedBy: 'Paul Javinez',
      approvedDate: 'January 22, 2026 14:00',
    ),
    const RequestItem(
      id: 'REQ-14',
      type: 'Timelogs Correction',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 14, 2026',
      filingDate: 'January 14, 2026',
      details: 'Biometrics terminal offline',
    ),
    const RequestItem(
      id: 'REQ-15',
      type: 'Dayoff Work',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'January 10, 2026',
      filingDate: 'January 12, 2026',
      details: 'Emergency server migration duty',
    ),
    const RequestItem(
      id: 'REQ-16',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'December 28, 2025 (F)',
      filingDate: 'December 20, 2025',
      details: 'Holiday year-end break',
    ),
    const RequestItem(
      id: 'REQ-17',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'December 15, 2025 (H)',
      filingDate: 'December 16, 2025',
      details: 'Half-day dental appointment',
    ),
    const RequestItem(
      id: 'REQ-18',
      type: 'Overtime',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'December 05, 2025',
      filingDate: 'December 06, 2025',
      details: 'Quarterly financial reporting sprint',
    ),
    const RequestItem(
      id: 'REQ-19',
      type: 'Reshift',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'November 24, 2025',
      filingDate: 'November 20, 2025',
      details: 'Shift schedule swap',
    ),
    const RequestItem(
      id: 'REQ-20',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'November 12, 2025 (F)',
      filingDate: 'November 10, 2025',
      details: 'Personal vacation leave',
    ),
    const RequestItem(
      id: 'REQ-21',
      type: 'Allowance',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'October 30, 2025',
      filingDate: 'October 31, 2025',
      details: 'Conference registration claim',
    ),
    const RequestItem(
      id: 'REQ-22',
      type: 'Timelogs Correction',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'October 15, 2025',
      filingDate: 'October 16, 2025',
      details: 'Time-out adjustment',
    ),
    const RequestItem(
      id: 'REQ-23',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Start / End',
      dateValue: 'October 01, 2025 / October 03, 2025',
      filingDate: 'September 28, 2025',
      details: 'Vacation leave (3 days)',
    ),
    const RequestItem(
      id: 'REQ-24',
      type: 'Overtime',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'September 22, 2025',
      filingDate: 'September 23, 2025',
      details: 'Infrastructure patching OT',
    ),
    const RequestItem(
      id: 'REQ-25',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'September 10, 2025 (H)',
      filingDate: 'September 10, 2025',
      details: 'Half-day family emergency',
    ),
    const RequestItem(
      id: 'REQ-26',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'August 25, 2025 (F)',
      filingDate: 'August 24, 2025',
      details: 'National Heroes Day recovery',
    ),
    const RequestItem(
      id: 'REQ-27',
      type: 'Dayoff Work',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'August 16, 2025',
      filingDate: 'August 17, 2025',
      details: 'Weekend disaster recovery test',
    ),
    const RequestItem(
      id: 'REQ-28',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'July 28, 2025 (H)',
      filingDate: 'July 28, 2025',
      details: 'Half-day medical checkup',
    ),
    const RequestItem(
      id: 'REQ-29',
      type: 'Timelogs Correction',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'October 28, 2026',
      filingDate: 'October 28, 2026',
      timeIn: '06:55',
      timeOut: '--',
      details: 'I acknowledge that my place is around the pinned location in the map.',
      approvedBy: 'Paul Javinez',
      approvedDate: 'October 28, 2026 07:00',
      locationTitle: 'My Location is Around Here:',
      locationAddress: 'Rosa Homes, Landayan, San Pedro, Laguna, Calabarzon, 4023, Philippines',
    ),
    const RequestItem(
      id: 'REQ-30',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'June 30, 2025 (F)',
      filingDate: 'June 25, 2025',
      details: 'Mid-year rest day',
    ),
    const RequestItem(
      id: 'REQ-31',
      type: 'Allowance',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'June 18, 2025',
      filingDate: 'June 20, 2025',
      details: 'Meals allowance on project delivery',
    ),
    const RequestItem(
      id: 'REQ-32',
      type: 'Overtime',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'May 31, 2025',
      filingDate: 'June 01, 2025',
      details: 'Month-end payroll processing OT',
    ),
    const RequestItem(
      id: 'REQ-33',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'May 15, 2025 (H)',
      filingDate: 'May 15, 2025',
      details: 'Half-day sick leave',
    ),
    const RequestItem(
      id: 'REQ-34',
      type: 'Leave',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'April 09, 2025 (F)',
      filingDate: 'April 05, 2025',
      details: 'Day of Valor leave extension',
    ),
    const RequestItem(
      id: 'REQ-35',
      type: 'Timelogs Correction',
      status: 'Approved',
      dateLabel: 'Date',
      dateValue: 'March 25, 2025',
      filingDate: 'March 25, 2025',
      details: 'Badge reader error correction',
    ),
  ];

  @override
  void dispose() {
    _closeDatePicker();
    super.dispose();
  }

  void _toggleDatePicker() {
    if (_dateOverlayEntry != null) {
      _closeDatePicker();
    } else {
      _showDatePicker();
    }
  }

  void _closeDatePicker() {
    _dateOverlayEntry?.remove();
    _dateOverlayEntry = null;
  }

  void _showDatePicker() {
    final overlay = Overlay.of(context);
    _dateOverlayEntry = OverlayEntry(
      builder: (ctx) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeDatePicker,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              width: 275,
              child: CompositedTransformFollower(
                link: _dateLayerLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: const Offset(0, 4),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: CalendarDate(
                    selectedDateRange: _selectedDateRange,
                    onDateRangeSelected: (newRange) {
                      setState(() {
                        _selectedDateRange = newRange;
                      });
                      _closeDatePicker();
                    },
                    onClose: _closeDatePicker,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_dateOverlayEntry!);
  }

  void _openAddRequestModal() {
    RequestModalDialog.show(
      context: context,
      onSubmitRequest: (data) {
        final type = data['typeOfRequest'] as String? ?? 'Leave';
        String dateVal = '';
        String dateLabel = 'Date';
        if (type == 'Leave') {
          if (data['isHalfDay'] == true) {
            dateVal = '${data['fromDate'] ?? ''} (H)';
          } else {
            dateLabel = 'Start / End';
            dateVal = '${data['fromDate'] ?? ''} / ${data['toDate'] ?? ''}';
          }
        } else if (type == 'Dayoff Work' && data['typeOfDayoffWork'] == 'Offset') {
          dateLabel = 'Start / End';
          dateVal = '${data['offsetFrom'] ?? ''} / ${data['offsetTo'] ?? ''}';
        } else {
          dateVal = data['dateApplied'] as String? ?? data['dateOfFiling'] as String? ?? '';
        }

        final newItem = RequestItem(
          id: 'REQ-${(_allRequests.length + 1).toString().padLeft(2, '0')}',
          type: type,
          status: 'Pending',
          dateLabel: dateLabel,
          dateValue: dateVal,
          filingDate: data['dateOfFiling'] as String? ?? '',
          details: data['reason'] as String? ?? '',
          leaveType: data['typeOfLeave'] as String?,
          allowanceType: data['allowance'] as String?,
          timeIn: data['timeIn'] as String?,
          timeOut: data['timeOut'] as String?,
          dayoffType: data['typeOfDayoffWork'] as String?,
          workStart: data['workStart'] as String?,
          workBreakStart: data['breakStart'] as String?,
          workBreakEnd: data['breakEnd'] as String?,
          workEnd: data['workEnd'] as String?,
          totalHours: data['totalHours'] != null ? '${data['totalHours']} Hours' : null,
        );

        setState(() {
          _allRequests.insert(0, newItem);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF47A5A0),
            content: Text('Successfully filed $type Request (${newItem.id})!'),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('rej')) return const Color(0xFFFF7F7F);
    if (lower.contains('pre')) return const Color(0xFF70D1A1);
    if (lower.contains('pend')) return const Color(0xFFFAAB36);
    return const Color(0xFF40B4F6); // Approved
  }

  void _showRequestDetails(RequestItem item) {
    RequestViewDialog.show(
      context: context,
      typeOfRequest: item.type,
      status: item.status,
      filingDate: item.filingDate,
      dateApplied: item.dateValue,
      reason: item.details,
      leaveType: item.leaveType,
      allowanceType: item.allowanceType,
      timeIn: item.timeIn,
      timeOut: item.timeOut,
      dayoffType: item.dayoffType,
      workStart: item.workStart,
      workBreakStart: item.workBreakStart,
      workBreakEnd: item.workBreakEnd,
      workEnd: item.workEnd,
      totalHours: item.totalHours,
      preApprovedBy: item.preApprovedBy,
      preApprovedDate: item.preApprovedDate,
      approvedBy: item.approvedBy ?? 'Paul Javinez',
      approvedDate: item.approvedDate,
      rejectedBy: item.rejectedBy ?? 'Paul Javinez',
      rejectedDate: item.rejectedDate,
      locationTitle: item.locationTitle,
      locationAddress: item.locationAddress,
      latitude: item.latitude,
      longitude: item.longitude,
      onCancelRequest: () {
        setState(() {
          _allRequests.removeWhere((r) => r.id == item.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF47A5A0),
            content: Text('Request ${item.id} has been cancelled.'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = _allRequests.length;
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalItems);
    final displayedItems = _allRequests.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Bar: [ (+) Add Request ]  [ Date  [calendar icon] ]
          Row(
            children: [
              Expanded(
                flex: 4,
                child: OutlinedButton.icon(
                  onPressed: _openAddRequestModal,
                  icon: const Icon(Icons.add_circle_outline, color: Color(0xFF47A5A0), size: 18),
                  label: const Text(
                    'Add Request',
                    style: TextStyle(
                      color: Color(0xFF47A5A0),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF47A5A0), width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 6,
                child: CompositedTransformTarget(
                  link: _dateLayerLink,
                  child: InkWell(
                    onTap: _toggleDatePicker,
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(4),
                        border: Border(
                          bottom: BorderSide(
                            color: _selectedDateRange != null && _selectedDateRange!.isNotEmpty
                                ? const Color(0xFF47A5A0)
                                : const Color(0xFF9CA3AF),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              (_selectedDateRange != null && _selectedDateRange!.isNotEmpty)
                                  ? _selectedDateRange!
                                  : 'Date',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: (_selectedDateRange != null && _selectedDateRange!.isNotEmpty)
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: (_selectedDateRange != null && _selectedDateRange!.isNotEmpty)
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Color(0xFF6B7280),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Requests list container
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
            ),
            child: Column(
              children: [
                ...displayedItems.map((item) => _buildRequestRow(item)),
                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                _buildPaginatorBar(startIndex + 1, endIndex, totalItems),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestRow(RequestItem item) {
    return InkWell(
      onTap: () => _showRequestDetails(item),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Col 1: Type & Status
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 11,
                          color: _getStatusColor(item.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Col 2: Date
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.dateLabel,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.dateValue,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),

                // Col 3: Filing
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filing',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.filingDate,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ],
                  ),
                ),

                // Col 4: Chevron
                const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF47A5A0),
                  size: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }

  Widget _buildPaginatorBar(int startItem, int endItem, int totalItems) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'Items per page:',
                style: TextStyle(fontSize: 12, color: Color(0xFF212121)),
              ),
              const SizedBox(width: 8),
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF9E9E9E), width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _pageSize,
                    isDense: true,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF212121)),
                    items: const [
                      DropdownMenuItem(value: 10, child: Text('10')),
                      DropdownMenuItem(value: 25, child: Text('25')),
                      DropdownMenuItem(value: 50, child: Text('50')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _pageSize = val;
                          _currentPage = 0;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _currentPage > 0 ? const Color(0xFF212121) : const Color(0xFFBDBDBD),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    size: 18,
                    color: _currentPage > 0 ? const Color(0xFF212121) : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$startItem – $endItem of $totalItems',
                style: const TextStyle(fontSize: 12, color: Color(0xFF212121)),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: endItem < totalItems ? () => setState(() => _currentPage++) : null,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: endItem < totalItems ? const Color(0xFF212121) : const Color(0xFFBDBDBD),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: endItem < totalItems ? const Color(0xFF212121) : const Color(0xFFBDBDBD),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
