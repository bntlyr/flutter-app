import 'package:flutter_app/shared/models/profile_model.dart';
import '../graphql/__generated__/personal.graphql.dart';

export 'package:flutter_app/shared/models/profile_model.dart';

/// Mapper to transform GraphQL Query$Personal response into domain EmployeeProfile.
class PersonalModelMapper {
  static const Map<int, String> _civilStatusMap = {
    1: 'Single',
    2: 'Married',
    3: 'Divorced',
    4: 'Separated',
    5: 'Widowed',
  };

  static const Map<int, String> _genderMap = {
    1: 'Male',
    2: 'Female',
  };

  static DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    }
    final str = date.toString();
    final millis = int.tryParse(str);
    if (millis != null) {
      return DateTime.fromMillisecondsSinceEpoch(millis);
    }
    return DateTime.tryParse(str);
  }

  static String _formatDate(dynamic date) {
    final dt = _parseDate(date);
    if (dt == null) return '';
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[dt.month - 1]} ${dt.day.toString().padLeft(2, '0')}, ${dt.year}';
  }

  static String _calculateAge(dynamic birthdate) {
    final dt = _parseDate(birthdate);
    if (dt == null) return 'N/A';
    final now = DateTime.now();
    int years = now.year - dt.year;
    if (now.month < dt.month || (now.month == dt.month && now.day < dt.day)) {
      years--;
    }
    return '$years yrs';
  }

  static String _calculateTenure(dynamic hiredDate) {
    final dt = _parseDate(hiredDate);
    if (dt == null) return '0Y & 0M';
    final now = DateTime.now();
    int years = now.year - dt.year;
    int months = now.month - dt.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    return '${years}Y & ${months}M';
  }

  static String _capitalize(String? s) {
    if (s == null || s.trim().isEmpty) return '';
    return s.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }

  static EmployeeProfile fromQuery(Query$Personal data) {
    final me = data.me;
    final prof = me?.profile;
    final settings = data.settings;

    final firstName = _capitalize(prof?.firstName);
    final lastName = _capitalize(prof?.lastName);
    final fullName = '$firstName $lastName'.trim();
    final initials = (firstName.isNotEmpty ? firstName[0] : '') +
        (lastName.isNotEmpty ? lastName[0] : '');

    // Leave credits
    final leaves = <LeaveCreditItem>[];
    for (final l in (prof?.leave ?? [])) {
      if (l != null) {
        leaves.add(
          LeaveCreditItem(
            leaveType: l.label ?? 'Leave',
            totalAllocated: (l.total_leave as num?)?.toDouble() ?? 0.0,
            used: (l.used_leave as num?)?.toDouble() ?? 0.0,
            remaining: (l.unused_leave as num?)?.toDouble() ?? 0.0,
          ),
        );
      }
    }

    // Deductions & Loans
    final loanItems = <LoanTableItem>[];
    final deductionItems = <DeductionTableItem>[];

    for (final d in (prof?.userDeduction ?? [])) {
      if (d != null) {
        final label = d.deduction?.label ?? 'Deduction';
        final amt = (d.amount as num?)?.toDouble() ?? 0.0;
        if (d.type?.toLowerCase() == 'loan') {
          loanItems.add(
            LoanTableItem(
              loanType: label,
              repaymentPerMonth: amt,
              paidUntil: _formatDate(d.paidUntil),
            ),
          );
        } else {
          deductionItems.add(
            DeductionTableItem(
              deductionType: label,
              amountPerMonth: amt,
            ),
          );
        }
      }
    }

    // Subsidies / Allowances
    final allowances = <AllowanceItem>[];
    for (final s in (prof?.userSubsidies ?? [])) {
      if (s != null) {
        allowances.add(
          AllowanceItem(
            label: s.subsidy?.label ?? 'Allowance',
            amount: (s.amount as num?)?.toDouble() ?? 0.0,
          ),
        );
      }
    }

    // Entitlements
    final entitlements = [
      EntitlementGroup(
        primaryLabel: 'Required Time-Sheet',
        isPrimaryChecked: prof?.isTimeSheetRequired ?? false,
        secondaryLabel: 'Regular Holiday Pay',
        isSecondaryChecked: prof?.isRegHolidayPay ?? false,
      ),
      EntitlementGroup(
        primaryLabel: 'Special Holiday Pay',
        isPrimaryChecked: prof?.isSpecHolidayPay ?? false,
        secondaryLabel: 'Rest Day Pay',
        isSecondaryChecked: prof?.isRestDayPay ?? false,
      ),
      EntitlementGroup(
        primaryLabel: 'Holiday Premium Pay',
        isPrimaryChecked: prof?.isHolidayPremiumPay ?? false,
        secondaryLabel: 'Night Differential Pay',
        isSecondaryChecked: prof?.isNightDiffPay ?? false,
      ),
      EntitlementGroup(
        primaryLabel: 'Overtime Pay',
        isPrimaryChecked: prof?.isOtPay ?? false,
        secondaryLabel: 'No Late Penalty',
        isSecondaryChecked: prof?.isNoLate ?? false,
      ),
      EntitlementGroup(
        primaryLabel: 'No Undertime Penalty',
        isPrimaryChecked: prof?.isNoUndertime ?? false,
        secondaryLabel: 'Flexible Working Hours',
        isSecondaryChecked: prof?.isFlexy ?? false,
      ),
    ];

    // Timing labels from settings
    final payDay1 = settings?.salaryDayLabel1 ?? '5th';
    final payDay2 = settings?.salaryDayLabel2 ?? '20th';
    final contribTiming = 'Paid 50% on $payDay1, 50% on $payDay2';
    final loanTiming = 'Paid 100% on $payDay1';

    final statusDesc = _capitalize(prof?.statusDescription);
    final employmentStatus =
        statusDesc.isNotEmpty ? statusDesc : 'N/A';

    if (prof == null) {
      return EmployeeProfile(
        userId: me?.id ?? '',
        fullName: me?.username ?? 'N/A',
        employeeId: 'N/A',
        jobTitle: 'N/A',
        department: 'N/A',
        email: me?.email ?? 'N/A',
        phone: 'N/A',
        avatarInitials: 'N/A',
        age: '0',
        loginId: me?.username ?? 'N/A',
        biometricsNo: 'N/A',
        remarks: 'N/A',
        birthDate: 'N/A',
        gender: 'N/A',
        civilStatus: 'N/A',
        nationality: 'N/A',
        residentialAddress: 'N/A',
        mobileNo: 'N/A',
        landlineNo: 'N/A',
        emergencyContactName: 'N/A',
        emergencyContactRelation: 'N/A',
        emergencyContactPhone: 'N/A',
        emergencyAddress: 'N/A',
        employmentStatus: 'N/A',
        dateHired: 'N/A',
        yearsOfService: '0',
        directSupervisor: 'N/A',
        workSchedule: 'N/A',
        officeLocation: 'N/A',
        period: '0',
        jobClass: 'N/A',
        resignationDate: 'N/A',
        basicSalary: 0.0,
        salaryType: 'N/A',
        endOfProbation: 'N/A',
        section: 'N/A',
        designation: 'N/A',
        contribPaymentTiming: 'N/A',
        sssNo: 'N/A',
        philhealthNo: 'N/A',
        pagibigNo: 'N/A',
        tinNo: 'N/A',
        pagibigCont: '0',
        loanPaymentTiming: 'N/A',
        deductionPaymentTiming: 'N/A',
        leaveCredits: const [],
        contributions: const [],
        loans: const [],
        recurringDeductions: const [],
        allowances: const [],
        entitlements: entitlements,
        loanTableItems: const [],
        deductionTableItems: const [],
      );
    }

    return EmployeeProfile(
      userId: me?.id ?? '',
      fullName: fullName.isNotEmpty ? fullName : (me?.username ?? 'N/A'),
      employeeId: prof.employeeId.isNotEmpty ? prof.employeeId : 'N/A',
      jobTitle: prof.position?.name ?? (prof.designation.isNotEmpty ? prof.designation : 'N/A'),
      department: prof.department.name.isNotEmpty
          ? prof.department.name
          : (prof.section?.name ?? 'N/A'),
      email: me?.email ?? 'N/A',
      phone: prof.mobileNo ?? 'N/A',
      avatarInitials: initials.isNotEmpty ? initials : 'N/A',
      age: _calculateAge(prof.birthdate),
      loginId: me?.username ?? 'N/A',
      biometricsNo: prof.biometricNo.isNotEmpty ? prof.biometricNo : 'N/A',
      remarks: prof.remarks ?? 'N/A',
      birthDate: _formatDate(prof.birthdate),
      gender: _genderMap[prof.gender] ?? 'N/A',
      civilStatus: _civilStatusMap[prof.civilStatus] ?? 'N/A',
      nationality: 'N/A',
      residentialAddress: prof.address.isNotEmpty ? prof.address : 'N/A',
      mobileNo: prof.mobileNo ?? 'N/A',
      landlineNo: prof.landlineNo ?? 'N/A',
      emergencyContactName: _capitalize(prof.emergencyName),
      emergencyContactRelation: _capitalize(prof.emergencyRelation),
      emergencyContactPhone: prof.emergencyContact.isNotEmpty ? prof.emergencyContact : 'N/A',
      emergencyAddress: prof.emergencyAddress.isNotEmpty ? prof.emergencyAddress : 'N/A',
      employmentStatus: employmentStatus,
      dateHired: _formatDate(prof.dateHired),
      yearsOfService: _calculateTenure(prof.dateHired),
      directSupervisor: 'N/A',
      workSchedule: (prof.isFlexy ?? false) ? 'Flexible Hours' : 'N/A',
      officeLocation: prof.site.name.isNotEmpty ? prof.site.name : 'N/A',
      period: _calculateTenure(prof.dateHired),
      jobClass: employmentStatus,
      resignationDate: _formatDate(prof.resignationDate),
      basicSalary: (prof.basicSalary as num?)?.toDouble() ?? 0.0,
      salaryType: prof.salaryType == 'day' ? 'Daily' : (prof.salaryType != null ? 'Monthly' : 'N/A'),
      endOfProbation: _formatDate(prof.provisionalPeriodEnd),
      section: prof.getSection?.name ?? prof.section?.name ?? 'N/A',
      designation: prof.position?.name ?? (prof.designation.isNotEmpty ? prof.designation : 'N/A'),
      contribPaymentTiming: contribTiming.isNotEmpty ? contribTiming : 'N/A',
      sssNo: prof.sssNo ?? 'N/A',
      philhealthNo: prof.philhealthNo ?? 'N/A',
      pagibigNo: prof.pagibigNo ?? 'N/A',
      tinNo: prof.tinNo ?? 'N/A',
      pagibigCont: (prof.pagibigAmount != null) ? '₱${prof.pagibigAmount}' : '0',
      loanPaymentTiming: loanTiming.isNotEmpty ? loanTiming : 'N/A',
      deductionPaymentTiming: loanTiming.isNotEmpty ? loanTiming : 'N/A',
      leaveCredits: leaves,
      contributions: const [],
      loans: const [],
      recurringDeductions: const [],
      allowances: allowances,
      entitlements: entitlements,
      loanTableItems: loanItems,
      deductionTableItems: deductionItems,
    );
  }
}
