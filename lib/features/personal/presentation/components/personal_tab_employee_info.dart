import 'package:flutter/material.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import 'personal_section_card.dart';

/// Tab 1: Employee Information & Emergency Information
class PersonalTabEmployeeInfo extends StatelessWidget {
  final EmployeeProfile profile;

  const PersonalTabEmployeeInfo({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PersonalSectionCard(
          title: 'Employee Information',
          child: Column(
            children: [
              PersonalDataRow(label: 'Date of Birth', value: profile.birthDate),
              PersonalDataRow(label: 'Sex', value: profile.gender),
              PersonalDataRow(label: 'Civil Status', value: profile.civilStatus),
              PersonalDataRow(label: 'Mobile No.', value: profile.mobileNo),
              PersonalDataRow(label: 'Landline No.', value: profile.landlineNo),
              PersonalDataRow(label: 'E-mail', value: profile.email),
              PersonalDataRow(label: 'Address', value: profile.residentialAddress),
            ],
          ),
        ),
        PersonalSectionCard(
          title: 'Emergency Information',
          child: Column(
            children: [
              PersonalDataRow(label: 'Name', value: profile.emergencyContactName),
              PersonalDataRow(label: 'Relation', value: profile.emergencyContactRelation),
              PersonalDataRow(label: 'Contact', value: profile.emergencyContactPhone),
              PersonalDataRow(label: 'Address', value: profile.emergencyAddress),
            ],
          ),
        ),
      ],
    );
  }
}
