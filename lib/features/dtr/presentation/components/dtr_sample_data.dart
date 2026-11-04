class DtrCompensationItem {
  final String name;
  final double hours;

  const DtrCompensationItem({
    required this.name,
    required this.hours,
  });
}

class DtrAllowanceItem {
  final String name;
  final double amount;

  const DtrAllowanceItem({
    required this.name,
    required this.amount,
  });
}

class DtrBadgeItem {
  final String label;
  final String code;

  const DtrBadgeItem({
    required this.label,
    this.code = 'normal',
  });
}

class DtrMobileDayItem {
  final DateTime date;
  final String? timeIn;
  final String? timeOut;
  final bool isAbsent;
  final double? lateHours;
  final double? undertimeHours;
  final List<DtrBadgeItem> approvedRequests;
  final List<DtrCompensationItem> dayRateCompensations;
  final List<DtrCompensationItem> nightRateCompensations;
  final List<DtrAllowanceItem> allowances;

  const DtrMobileDayItem({
    required this.date,
    this.timeIn,
    this.timeOut,
    this.isAbsent = false,
    this.lateHours,
    this.undertimeHours,
    this.approvedRequests = const [],
    this.dayRateCompensations = const [],
    this.nightRateCompensations = const [],
    this.allowances = const [],
  });
}

class DtrCutoffData {
  final String cutoffLabel;
  final int totalApprovedRequests;
  final double totalAbsent;
  final double totalLateHrs;
  final double totalUndertimeHrs;
  final double totalAllowance;
  final Map<String, double> compensationsDay;
  final Map<String, double> compensationsNight;
  final List<DtrMobileDayItem> days;

  const DtrCutoffData({
    required this.cutoffLabel,
    required this.totalApprovedRequests,
    required this.totalAbsent,
    required this.totalLateHrs,
    required this.totalUndertimeHrs,
    required this.totalAllowance,
    required this.compensationsDay,
    required this.compensationsNight,
    required this.days,
  });
}

class DtrSampleData {
  static const defaultAllowances = [
    DtrAllowanceItem(name: 'Transportation', amount: 48.00),
    DtrAllowanceItem(name: 'Meal', amount: 31.00),
  ];
  static const mealAllowanceOnly = [
    DtrAllowanceItem(name: 'Meal', amount: 31.00),
  ];

  static final DtrCutoffData oct16To31 = DtrCutoffData(
    cutoffLabel: 'Oct-16-26 — Oct-31-26',
    totalApprovedRequests: 0,
    totalAbsent: 2.0,
    totalLateHrs: 0.017,
    totalUndertimeHrs: 0.000,
    totalAllowance: 632.00,
    compensationsDay: {
      'Overtime': 5.500,
      'Rest Day': 8.000,
      'Rest Day Excess': 2.000,
      'Special Holiday': 4.000,
      'Special Holiday Excess': 1.500,
      'Special Holiday And Rest Day': 4.000,
      'Special Holiday And Rest Day Excess': 1.000,
      'Legal Holiday': 8.000,
      'Legal Holiday Excess': 2.000,
      'Legal Holiday And Rest Day': 8.000,
      'Legal Holiday And Rest Day Excess': 2.000,
    },
    compensationsNight: {
      'Regular': 4.000,
      'Regular Excess': 1.500,
      'Rest Day': 3.000,
      'Rest Day Excess': 1.000,
      'Special Holiday': 2.500,
      'Special Holiday Excess': 1.000,
      'Special Holiday & Rest Day': 2.000,
      'Special Holiday & Rest Day Excess': 0.500,
      'Legal Holiday': 4.000,
      'Legal Holiday Excess': 1.500,
      'Legal Holiday & Rest Day': 3.000,
      'Legal Holiday & Rest Day Excess': 1.000,
    },
    days: [
      DtrMobileDayItem(
        date: DateTime(2026, 10, 16),
        timeIn: '07:01',
        timeOut: '17:03',
        lateHours: 0.017,
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 17),
        timeIn: '08:00',
        timeOut: '17:00',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Rest Day', hours: 8.000),
          DtrCompensationItem(name: 'Rest Day Excess', hours: 1.000),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 18),
        timeIn: null,
        timeOut: null,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 19),
        timeIn: '07:01',
        timeOut: '16:03',
        lateHours: 0.017,
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Overtime', hours: 0.500),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 20),
        timeIn: '06:38',
        timeOut: '16:33',
        undertimeHours: 0.500,
        nightRateCompensations: const [
          DtrCompensationItem(name: 'Regular', hours: 1.000),
          DtrCompensationItem(name: 'Regular Excess', hours: 0.500),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 21),
        timeIn: '07:30',
        timeOut: '18:00',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Special Holiday', hours: 4.000),
          DtrCompensationItem(name: 'Special Holiday Excess', hours: 1.500),
        ],
        nightRateCompensations: const [
          DtrCompensationItem(name: 'Special Holiday', hours: 2.500),
          DtrCompensationItem(name: 'Special Holiday Excess', hours: 1.000),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 22),
        isAbsent: true,
        approvedRequests: const [
          DtrBadgeItem(label: 'leaveWithoutPay Leave'),
        ],
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 23),
        timeIn: '08:00',
        timeOut: '19:30',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Legal Holiday', hours: 8.000),
          DtrCompensationItem(name: 'Legal Holiday Excess', hours: 2.000),
        ],
        nightRateCompensations: const [
          DtrCompensationItem(name: 'Legal Holiday', hours: 4.000),
          DtrCompensationItem(name: 'Legal Holiday Excess', hours: 1.500),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 24),
        timeIn: '08:00',
        timeOut: '17:00',
        dayRateCompensations: const [
          DtrCompensationItem(
              name: 'Special Holiday And Rest Day', hours: 4.000),
          DtrCompensationItem(
              name: 'Special Holiday And Rest Day Excess', hours: 1.000),
        ],
        nightRateCompensations: const [
          DtrCompensationItem(
              name: 'Special Holiday & Rest Day', hours: 2.000),
          DtrCompensationItem(
              name: 'Special Holiday & Rest Day Excess', hours: 0.500),
        ],
        allowances: mealAllowanceOnly,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 25),
        timeIn: '08:00',
        timeOut: '17:00',
        dayRateCompensations: const [
          DtrCompensationItem(
              name: 'Legal Holiday And Rest Day', hours: 8.000),
          DtrCompensationItem(
              name: 'Legal Holiday And Rest Day Excess', hours: 2.000),
        ],
        nightRateCompensations: const [
          DtrCompensationItem(
              name: 'Legal Holiday & Rest Day', hours: 3.000),
          DtrCompensationItem(
              name: 'Legal Holiday & Rest Day Excess', hours: 1.000),
        ],
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 26),
        timeIn: '07:45',
        timeOut: '17:00',
        lateHours: 0.033,
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Overtime', hours: 1.000),
        ],
        nightRateCompensations: const [
          DtrCompensationItem(name: 'Rest Day', hours: 3.000),
          DtrCompensationItem(name: 'Rest Day Excess', hours: 1.000),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 27),
        timeIn: '08:00',
        timeOut: '16:30',
        undertimeHours: 0.500,
        approvedRequests: const [
          DtrBadgeItem(label: 'Undertime Request'),
        ],
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 28),
        timeIn: '07:50',
        timeOut: '17:00',
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 29),
        isAbsent: true,
        approvedRequests: const [
          DtrBadgeItem(label: 'Sick Leave'),
        ],
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 30),
        timeIn: '08:00',
        timeOut: '17:00',
        allowances: defaultAllowances,
      ),
      DtrMobileDayItem(
        date: DateTime(2026, 10, 31),
        timeIn: '08:00',
        timeOut: '12:00',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Rest Day', hours: 4.000),
        ],
        allowances: mealAllowanceOnly,
      ),
    ],
  );

  static final List<DtrCutoffData> allCutoffs = [
    oct16To31,
  ];

  static final Map<int, DtrMobileDayItem> _oct16To31Days = {
    for (final day in oct16To31.days) day.date.day: day,
  };

  static (DateTime, DateTime) _parseCutoffRange(String text) {
    final match = RegExp(
      r'([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{2,4})\s*[-–—to ]+\s*([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{2,4})',
    ).firstMatch(text);

    if (match != null) {
      final startMonth = _monthIndex(match.group(1)!);
      final startDay = int.tryParse(match.group(2)!) ?? 1;
      int startYear = int.tryParse(match.group(3)!) ?? 2026;
      if (startYear < 100) startYear += 2000;

      final endMonth = _monthIndex(match.group(4)!);
      final endDay = int.tryParse(match.group(5)!) ?? 15;
      int endYear = int.tryParse(match.group(6)!) ?? 2026;
      if (endYear < 100) endYear += 2000;

      return (
        DateTime(startYear, startMonth, startDay),
        DateTime(endYear, endMonth, endDay),
      );
    }
    return (DateTime(2026, 10, 16), DateTime(2026, 10, 31));
  }

  static int _monthIndex(String name) {
    const months = [
      'jan', 'feb', 'mar', 'apr', 'may', 'jun',
      'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];
    final idx = months.indexOf(name.toLowerCase());
    return idx >= 0 ? idx + 1 : 10;
  }

  static DtrCutoffData getCutoff(String cutoffText) {
    final range = _parseCutoffRange(cutoffText);
    final startDate = range.$1;
    final endDate = range.$2;

    if (startDate.year == 2026 &&
        startDate.month == 10 &&
        startDate.day == 16 &&
        endDate.year == 2026 &&
        endDate.month == 10 &&
        endDate.day == 31) {
      return DtrCutoffData(
        cutoffLabel: cutoffText,
        totalApprovedRequests: oct16To31.totalApprovedRequests,
        totalAbsent: oct16To31.totalAbsent,
        totalLateHrs: oct16To31.totalLateHrs,
        totalUndertimeHrs: oct16To31.totalUndertimeHrs,
        totalAllowance: oct16To31.totalAllowance,
        compensationsDay: oct16To31.compensationsDay,
        compensationsNight: oct16To31.compensationsNight,
        days: oct16To31.days,
      );
    }

    final days = <DtrMobileDayItem>[];
    for (DateTime d = startDate;
        !d.isAfter(endDate);
        d = d.add(const Duration(days: 1))) {
      days.add(_generateDayItem(d));
    }

    if (days.isEmpty) {
      days.add(_generateDayItem(startDate));
    }

    return _computeCutoffData(cutoffText, days);
  }

  static DtrMobileDayItem _generateDayItem(DateTime d) {
    if (d.year == 2026 && d.month == 10 && _oct16To31Days.containsKey(d.day)) {
      return _oct16To31Days[d.day]!;
    }
    if (d.weekday == DateTime.sunday) {
      return DtrMobileDayItem(date: d);
    }
    if (d.weekday == DateTime.saturday) {
      return DtrMobileDayItem(
        date: d,
        timeIn: '08:00',
        timeOut: '12:00',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Rest Day', hours: 4.000),
        ],
        allowances: mealAllowanceOnly,
      );
    }
    if (d.day % 11 == 0) {
      return DtrMobileDayItem(
        date: d,
        isAbsent: true,
        approvedRequests: const [
          DtrBadgeItem(label: 'Sick Leave'),
        ],
      );
    }
    if (d.day % 7 == 2) {
      return DtrMobileDayItem(
        date: d,
        timeIn: '07:30',
        timeOut: '18:00',
        dayRateCompensations: const [
          DtrCompensationItem(name: 'Overtime', hours: 1.000),
        ],
        allowances: defaultAllowances,
      );
    }
    if (d.day % 5 == 0) {
      return DtrMobileDayItem(
        date: d,
        timeIn: '08:15',
        timeOut: '17:00',
        lateHours: 0.250,
        allowances: defaultAllowances,
      );
    }
    return DtrMobileDayItem(
      date: d,
      timeIn: '07:55',
      timeOut: '17:02',
      allowances: defaultAllowances,
    );
  }

  static DtrCutoffData _computeCutoffData(
      String label, List<DtrMobileDayItem> days) {
    int totalApprovedRequests = 0;
    double totalAbsent = 0.0;
    double totalLateHrs = 0.0;
    double totalUndertimeHrs = 0.0;
    double totalAllowance = 0.0;
    final Map<String, double> compensationsDay = {};
    final Map<String, double> compensationsNight = {};

    for (final day in days) {
      totalApprovedRequests += day.approvedRequests.length;
      if (day.isAbsent) totalAbsent += 1.0;
      if (day.lateHours != null) totalLateHrs += day.lateHours!;
      if (day.undertimeHours != null) totalUndertimeHrs += day.undertimeHours!;
      for (final a in day.allowances) {
        totalAllowance += a.amount;
      }
      for (final comp in day.dayRateCompensations) {
        compensationsDay[comp.name] =
            (compensationsDay[comp.name] ?? 0.0) + comp.hours;
      }
      for (final comp in day.nightRateCompensations) {
        compensationsNight[comp.name] =
            (compensationsNight[comp.name] ?? 0.0) + comp.hours;
      }
    }

    return DtrCutoffData(
      cutoffLabel: label,
      totalApprovedRequests: totalApprovedRequests,
      totalAbsent: totalAbsent,
      totalLateHrs: totalLateHrs,
      totalUndertimeHrs: totalUndertimeHrs,
      totalAllowance: totalAllowance,
      compensationsDay: compensationsDay,
      compensationsNight: compensationsNight,
      days: days,
    );
  }
}
