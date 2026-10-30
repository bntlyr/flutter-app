import '../models/profile_model.dart';

class MockProfileData {
  static const EmployeeProfile profile = EmployeeProfile(
    fullName: 'Paul Javinez',
    employeeId: '6767-676',
    jobTitle: 'Developer',
    department: 'IT',
    email: 'paul_j@test.com',
    phone: '0999 676 7676',
    avatarInitials: '',
    age: '45 yrs',
    loginId: 'cbc@67',
    biometricsNo: '116767',
    remarks: '',

    // Personal / Employee Information
    birthDate: 'June 12, 2000',
    gender: 'Male',
    civilStatus: 'Single',
    nationality: 'Filipino',
    residentialAddress: 'n/a',
    mobileNo: '0999 676 7676',
    landlineNo: '',
    emergencyContactName: 'Lorem Ipsum',
    emergencyContactRelation: 'Brother',
    emergencyContactPhone: '0999 676 7676',
    emergencyAddress: 'n/a',

    // Employment Information
    employmentStatus: 'Regular',
    dateHired: 'June 06, 2017',
    yearsOfService: '9Y & 4M',
    period: '9Y & 4M',
    directSupervisor: '',
    workSchedule: 'See work schedule',
    officeLocation: 'Main Office',
    basicSalary: 67676.67,
    salaryType: 'Monthly',
    section: 'N/A',
    designation: 'IT HEAD',

    // Contributions Info
    contribPaymentTiming: 'Paid 50% each on 20th',
    sssNo: '09-9999999-9',
    philhealthNo: '6767-676-76767',
    pagibigNo: '',
    tinNo: '676-767-676',
    pagibigCont: '--',

    // Loans & Deductions Timing
    loanPaymentTiming: 'Paid 100% on 5th',
    deductionPaymentTiming: 'Paid 100% on 5th',

    // Allowances
    allowances: [
      AllowanceItem(label: 'Line Leader', amount: 0.00),
      AllowanceItem(label: 'Carbon', amount: 0.00),
      AllowanceItem(label: 'Transportation', amount: 0.00),
      AllowanceItem(label: 'Special Salary', amount: 0.00),
      AllowanceItem(label: 'Other Benefits', amount: 0.00),
      AllowanceItem(label: 'ISO', amount: 0.00),
      AllowanceItem(label: 'Meal', amount: 0.00),
      AllowanceItem(label: 'Position', amount: 29316.81),
    ],

    // Entitlements
    entitlements: [
      EntitlementGroup(
        primaryLabel: 'Time Sheet Required',
        isPrimaryChecked: true,
        secondaryLabel: 'Flexitime',
        isSecondaryChecked: false,
      ),
      EntitlementGroup(
        primaryLabel: 'Unworked Regular Holiday Pay',
        isPrimaryChecked: true,
        secondaryLabel: 'Unworked Special Holiday Pay',
        isSecondaryChecked: true,
      ),
      EntitlementGroup(
        primaryLabel: 'Rest Day Pay',
        isPrimaryChecked: true,
        secondaryLabel: 'Holiday Premium Pay',
        isSecondaryChecked: true,
      ),
      EntitlementGroup(
        primaryLabel: 'Night Differential Pay',
        isPrimaryChecked: true,
        secondaryLabel: 'Overtime Pay',
        isSecondaryChecked: false,
      ),
      EntitlementGroup(
        primaryLabel: 'Night Differential Pay',
        isPrimaryChecked: true,
        secondaryLabel: 'Overtime Pay',
        isSecondaryChecked: false,
      ),
    ],

    // Leave Status
    leaveCredits: [
      LeaveCreditItem(
        leaveType: 'Sick',
        totalAllocated: 13.0,
        used: 1.0,
        remaining: 12.0,
      ),
      LeaveCreditItem(
        leaveType: 'Vacation',
        totalAllocated: 13.0,
        used: 11.9,
        remaining: 1.1,
      ),
      LeaveCreditItem(
        leaveType: 'Paternity/Maternity',
        totalAllocated: 7.0,
        used: 0.0,
        remaining: 7.0,
      ),
      LeaveCreditItem(
        leaveType: 'Bereavement',
        totalAllocated: 3.0,
        used: 0.0,
        remaining: 3.0,
      ),
      LeaveCreditItem(
        leaveType: 'Solo Parent',
        totalAllocated: 0.0,
        used: 0.0,
        remaining: 0.0,
      ),
    ],

    // Loan Table
    loanTableItems: [
      LoanTableItem(
        loanType: 'SSS Salary Loan',
        repaymentPerMonth: 0.00,
        paidUntil: '',
      ),
      LoanTableItem(
        loanType: 'SSS Calamity Loan',
        repaymentPerMonth: 0.00,
        paidUntil: '',
      ),
      LoanTableItem(
        loanType: 'HDMF Salary Loan',
        repaymentPerMonth: 0.00,
        paidUntil: '',
      ),
      LoanTableItem(
        loanType: 'HDMF Calamity Loan',
        repaymentPerMonth: 0.00,
        paidUntil: '',
      ),
    ],

    // Deduction Table
    deductionTableItems: [
      DeductionTableItem(
        deductionType: 'HMO',
        amountPerMonth: 0.00,
      ),
      DeductionTableItem(
        deductionType: 'Educational Loan',
        amountPerMonth: 0.00,
      ),
      DeductionTableItem(
        deductionType: 'Emergency Loan',
        amountPerMonth: 0.00,
      ),
    ],

    // Legacy lists preserved
    contributions: [
      GovernmentContributionItem(
        agencyName: 'Social Security System (SSS)',
        accountOrIdNumber: '04-4750234-9',
        status: 'Active / Contributing',
        monthlyEmployeeRate: 95.00,
        monthlyEmployerRate: 190.00,
      ),
      GovernmentContributionItem(
        agencyName: 'PhilHealth (PHIC)',
        accountOrIdNumber: '0805-165-99123',
        status: 'Active / Updated',
        monthlyEmployeeRate: 80.00,
        monthlyEmployerRate: 80.00,
      ),
      GovernmentContributionItem(
        agencyName: 'Tax Identification Number (TIN)',
        accountOrIdNumber: '250-557-202',
        status: 'Verified',
        monthlyEmployeeRate: 265.76,
        monthlyEmployerRate: 0.00,
      ),
    ],
    loans: [],
    recurringDeductions: [],
  );
}
