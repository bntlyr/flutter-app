import '../models/profile_model.dart';

class MockProfileData {
  static const EmployeeProfile profile = EmployeeProfile(
    fullName: 'Alex Morgan',
    employeeId: '#84920',
    jobTitle: 'Senior Software Engineer',
    department: 'Software Engineering & Platform',
    email: 'alex.morgan@company.com',
    phone: '+1 (555) 019-2834',
    avatarInitials: 'AM',

    // Personal / Employee Information
    birthDate: 'August 14, 1994',
    gender: 'Female',
    civilStatus: 'Single',
    nationality: 'Filipino',
    residentialAddress: 'Unit 402 Horizon Residences, Emerald Ave, Pasig City',
    emergencyContactName: 'Clara Morgan',
    emergencyContactRelation: 'Mother',
    emergencyContactPhone: '+1 (555) 882-9102',

    // Employment Information
    employmentStatus: 'Regular Full-Time',
    dateHired: 'March 15, 2021',
    yearsOfService: '5 Years, 7 Months',
    directSupervisor: 'Jane Cooper (Lead Engineering Manager)',
    workSchedule: 'Monday – Friday, 08:00 AM – 05:00 PM',
    officeLocation: 'Headquarters Tower 1, Level 14',

    // Leave Status
    leaveCredits: [
      LeaveCreditItem(
        leaveType: 'Vacation Leave (VL)',
        totalAllocated: 15.0,
        used: 4.5,
        remaining: 10.5,
      ),
      LeaveCreditItem(
        leaveType: 'Sick Leave (SL)',
        totalAllocated: 10.0,
        used: 1.0,
        remaining: 9.0,
      ),
      LeaveCreditItem(
        leaveType: 'Emergency Leave (EL)',
        totalAllocated: 3.0,
        used: 0.0,
        remaining: 3.0,
      ),
      LeaveCreditItem(
        leaveType: 'Birthday Leave',
        totalAllocated: 1.0,
        used: 1.0,
        remaining: 0.0,
      ),
    ],

    // Government Contribution Info
    contributions: [
      GovernmentContributionItem(
        agencyName: 'Social Security System (SSS)',
        accountOrIdNumber: '04-1298492-1',
        status: 'Active / Contributing',
        monthlyEmployeeRate: 95.00,
        monthlyEmployerRate: 190.00,
      ),
      GovernmentContributionItem(
        agencyName: 'PhilHealth (PHIC)',
        accountOrIdNumber: '12-009482910-3',
        status: 'Active / Updated',
        monthlyEmployeeRate: 80.00,
        monthlyEmployerRate: 80.00,
      ),
      GovernmentContributionItem(
        agencyName: 'Pag-IBIG HDMF',
        accountOrIdNumber: '1210-9482-3819',
        status: 'Active / Updated',
        monthlyEmployeeRate: 50.00,
        monthlyEmployerRate: 50.00,
      ),
      GovernmentContributionItem(
        agencyName: 'Tax Identification Number (TIN)',
        accountOrIdNumber: '293-849-102-000',
        status: 'Verified (RDO 043)',
        monthlyEmployeeRate: 265.76,
        monthlyEmployerRate: 0.00,
      ),
    ],

    // Loan Information
    loans: [
      LoanAccountItem(
        loanType: 'Company Tech Hardware Loan',
        referenceNumber: 'COMP-2026-LN-0042',
        principalAmount: 1500.00,
        monthlyAmortization: 125.00,
        balanceRemaining: 750.00,
        maturityDate: 'April 2027',
      ),
      LoanAccountItem(
        loanType: 'Pag-IBIG Multi-Purpose Loan',
        referenceNumber: 'HDMF-MPL-88291',
        principalAmount: 1800.00,
        monthlyAmortization: 75.00,
        balanceRemaining: 750.00,
        maturityDate: 'September 2027',
      ),
    ],

    // Deductions Information
    recurringDeductions: [
      RecurringDeductionItem(
        deductionName: 'Company HMO Supplemental Coverage',
        frequency: 'Semi-monthly',
        amount: 35.00,
        notes: 'Dependent insurance plan for 1 parent',
      ),
      RecurringDeductionItem(
        deductionName: 'Employee Cooperative Savings',
        frequency: 'Semi-monthly',
        amount: 50.00,
        notes: 'Voluntary savings fund investment',
      ),
      RecurringDeductionItem(
        deductionName: 'Gym & Wellness Corporate Membership',
        frequency: 'Monthly',
        amount: 25.00,
        notes: 'Subsidized partner gym access',
      ),
    ],
  );
}
