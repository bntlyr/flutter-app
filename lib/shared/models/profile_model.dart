class LeaveCreditItem {
  final String leaveType;
  final double totalAllocated;
  final double used;
  final double remaining;

  const LeaveCreditItem({
    required this.leaveType,
    required this.totalAllocated,
    required this.used,
    required this.remaining,
  });
}

class GovernmentContributionItem {
  final String agencyName;
  final String accountOrIdNumber;
  final String status;
  final double monthlyEmployeeRate;
  final double monthlyEmployerRate;

  const GovernmentContributionItem({
    required this.agencyName,
    required this.accountOrIdNumber,
    required this.status,
    required this.monthlyEmployeeRate,
    required this.monthlyEmployerRate,
  });
}

class LoanAccountItem {
  final String loanType;
  final String referenceNumber;
  final double principalAmount;
  final double monthlyAmortization;
  final double balanceRemaining;
  final String maturityDate;

  const LoanAccountItem({
    required this.loanType,
    required this.referenceNumber,
    required this.principalAmount,
    required this.monthlyAmortization,
    required this.balanceRemaining,
    required this.maturityDate,
  });
}

class AllowanceItem {
  final String label;
  final double amount;

  const AllowanceItem({required this.label, required this.amount});
}

class EntitlementGroup {
  final String primaryLabel;
  final bool isPrimaryChecked;
  final String secondaryLabel;
  final bool isSecondaryChecked;

  const EntitlementGroup({
    required this.primaryLabel,
    required this.isPrimaryChecked,
    required this.secondaryLabel,
    required this.isSecondaryChecked,
  });
}

class LoanTableItem {
  final String loanType;
  final double repaymentPerMonth;
  final String paidUntil;

  const LoanTableItem({
    required this.loanType,
    required this.repaymentPerMonth,
    required this.paidUntil,
  });
}

class DeductionTableItem {
  final String deductionType;
  final double amountPerMonth;

  const DeductionTableItem({
    required this.deductionType,
    required this.amountPerMonth,
  });
}

class RecurringDeductionItem {
  final String deductionName;
  final String frequency;
  final double amount;
  final String notes;

  const RecurringDeductionItem({
    required this.deductionName,
    required this.frequency,
    required this.amount,
    required this.notes,
  });
}

class EmployeeProfile {
  // Basic & Profile Info
  final String userId;
  final String fullName;
  final String employeeId;
  final String jobTitle;
  final String department;
  final String email;
  final String phone;
  final String avatarInitials;

  // Header extras
  final String age;
  final String loginId;
  final String biometricsNo;
  final String remarks;

  // Personal / Employee Information
  final String birthDate;
  final String gender;
  final String civilStatus;
  final String nationality;
  final String residentialAddress;
  final String mobileNo;
  final String landlineNo;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactPhone;
  final String emergencyAddress;

  // Employment Information
  final String employmentStatus; // Regular Full-Time, Probationary
  final String dateHired;
  final String yearsOfService;
  final String directSupervisor;
  final String workSchedule;
  final String officeLocation;
  final String period;
  final String jobClass;
  final String resignationDate;
  final double basicSalary;
  final String salaryType;
  final String endOfProbation;
  final String section;
  final String designation;

  // Contributions & Timing
  final String contribPaymentTiming;
  final String sssNo;
  final String philhealthNo;
  final String pagibigNo;
  final String tinNo;
  final String pagibigCont;

  // Loans & Deductions Timing
  final String loanPaymentTiming;
  final String deductionPaymentTiming;

  // Detailed lists
  final List<LeaveCreditItem> leaveCredits;
  final List<GovernmentContributionItem> contributions;
  final List<LoanAccountItem> loans;
  final List<RecurringDeductionItem> recurringDeductions;
  final List<AllowanceItem> allowances;
  final List<EntitlementGroup> entitlements;
  final List<LoanTableItem> loanTableItems;
  final List<DeductionTableItem> deductionTableItems;

  const EmployeeProfile({
    this.userId = '',
    required this.fullName,
    required this.employeeId,
    required this.jobTitle,
    required this.department,
    required this.email,
    required this.phone,
    required this.avatarInitials,
    this.age = '0',
    this.loginId = 'N/A',
    this.biometricsNo = 'N/A',
    this.remarks = 'N/A',
    required this.birthDate,
    required this.gender,
    required this.civilStatus,
    required this.nationality,
    required this.residentialAddress,
    this.mobileNo = 'N/A',
    this.landlineNo = 'N/A',
    required this.emergencyContactName,
    required this.emergencyContactRelation,
    required this.emergencyContactPhone,
    this.emergencyAddress = 'N/A',
    required this.employmentStatus,
    required this.dateHired,
    required this.yearsOfService,
    required this.directSupervisor,
    required this.workSchedule,
    required this.officeLocation,
    this.period = '0',
    this.jobClass = 'N/A',
    this.resignationDate = 'N/A',
    this.basicSalary = 0.0,
    this.salaryType = 'N/A',
    this.endOfProbation = 'N/A',
    this.section = 'N/A',
    this.designation = 'N/A',
    this.contribPaymentTiming = 'N/A',
    this.sssNo = 'N/A',
    this.philhealthNo = 'N/A',
    this.pagibigNo = 'N/A',
    this.tinNo = 'N/A',
    this.pagibigCont = '0',
    this.loanPaymentTiming = 'N/A',
    this.deductionPaymentTiming = 'N/A',
    required this.leaveCredits,
    required this.contributions,
    required this.loans,
    required this.recurringDeductions,
    this.allowances = const [],
    this.entitlements = const [],
    this.loanTableItems = const [],
    this.deductionTableItems = const [],
  });
}
