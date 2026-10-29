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
  final String fullName;
  final String employeeId;
  final String jobTitle;
  final String department;
  final String email;
  final String phone;
  final String avatarInitials;

  // Personal / Employee Information
  final String birthDate;
  final String gender;
  final String civilStatus;
  final String nationality;
  final String residentialAddress;
  final String emergencyContactName;
  final String emergencyContactRelation;
  final String emergencyContactPhone;

  // Employment Information
  final String employmentStatus; // Regular Full-Time, Probationary
  final String dateHired;
  final String yearsOfService;
  final String directSupervisor;
  final String workSchedule;
  final String officeLocation;

  // Detailed lists
  final List<LeaveCreditItem> leaveCredits;
  final List<GovernmentContributionItem> contributions;
  final List<LoanAccountItem> loans;
  final List<RecurringDeductionItem> recurringDeductions;

  const EmployeeProfile({
    required this.fullName,
    required this.employeeId,
    required this.jobTitle,
    required this.department,
    required this.email,
    required this.phone,
    required this.avatarInitials,
    required this.birthDate,
    required this.gender,
    required this.civilStatus,
    required this.nationality,
    required this.residentialAddress,
    required this.emergencyContactName,
    required this.emergencyContactRelation,
    required this.emergencyContactPhone,
    required this.employmentStatus,
    required this.dateHired,
    required this.yearsOfService,
    required this.directSupervisor,
    required this.workSchedule,
    required this.officeLocation,
    required this.leaveCredits,
    required this.contributions,
    required this.loans,
    required this.recurringDeductions,
  });
}
