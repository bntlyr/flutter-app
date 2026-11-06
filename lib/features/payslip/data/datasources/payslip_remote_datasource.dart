import 'dart:convert';
import 'package:graphql/client.dart' hide ServerException;
import 'package:flutter_app/core/graphql/graphql_client.dart';
import 'package:flutter_app/core/graphql/__generated__/schema.graphql.dart';
import 'package:flutter_app/services/storage_service.dart';
import '../graphql/__generated__/payslip.graphql.dart';
import '../models/payslip_model.dart';

abstract class PayslipRemoteDataSource {
  Future<PayslipEntity> fetchPayslip({String? cutoffId, String? cutoffText});
  Future<List<CutoffOptionEntity>> fetchCutoffs();
}

class PayslipRemoteDataSourceImpl implements PayslipRemoteDataSource {
  final Future<String?> Function()? tokenProvider;

  const PayslipRemoteDataSourceImpl({this.tokenProvider});

  Future<String?> _getUserId() async {
    final token = tokenProvider != null
        ? await tokenProvider!()
        : await (await StorageService.getInstance()).getToken();
    if (token != null && token.isNotEmpty) {
      final parts = token.split('.');
      if (parts.length == 3) {
        try {
          final payload = jsonDecode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );
          final id = payload['userId'] ?? payload['id'];
          if (id != null) return id.toString();
        } catch (_) {}
      }
    }
    return null;
  }

  @override
  Future<List<CutoffOptionEntity>> fetchCutoffs() async {
    try {
      final client = await AppGraphQLClient.getClient();
      final result = await client.query$PayslipCutOffs();
      final cutoffs = result.parsedData?.cutOffs;
      if (cutoffs != null && cutoffs.isNotEmpty) {
        return cutoffs
            .whereType<Query$PayslipCutOffs$cutOffs>()
            .map((c) => CutoffOptionEntity(
                  id: c.id,
                  payrollPeriod: c.payrollPeriod,
                  timeStart: c.timeStart != null
                      ? (c.timeStart is int
                          ? DateTime.fromMillisecondsSinceEpoch(c.timeStart as int)
                          : DateTime.tryParse(c.timeStart.toString()))
                      : null,
                  timeEnd: c.timeEnd != null
                      ? (c.timeEnd is int
                          ? DateTime.fromMillisecondsSinceEpoch(c.timeEnd as int)
                          : DateTime.tryParse(c.timeEnd.toString()))
                      : null,
                  status: c.status ?? 0,
                  isApproved: c.payrollApproved ?? false,
                ))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<PayslipEntity> fetchPayslip({String? cutoffId, String? cutoffText}) async {
    try {
      final client = await AppGraphQLClient.getClient();
      final cutoffsResult = await client.query$PayslipCutOffs();
      final allCutoffs = (cutoffsResult.parsedData?.cutOffs ?? [])
          .whereType<Query$PayslipCutOffs$cutOffs>()
          .toList();

      String? userId = cutoffsResult.parsedData?.me?.id;
      userId ??= await _getUserId();

      if (userId == null || userId.isEmpty) {
        return PayslipEntity.empty(cutoffText);
      }

      Query$PayslipCutOffs$cutOffs? findMatchingCutoff(String text) {
        final reg = RegExp(
          r'([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{2,4})',
        ).firstMatch(text);

        if (reg != null) {
          final m = reg.group(1)!.toLowerCase();
          final sDay = int.parse(reg.group(2)!);
          final yStr = reg.group(3)!;
          final y2 = yStr.length == 4 ? yStr.substring(2) : yStr;
          final y4 = yStr.length == 2 ? '20$yStr' : yStr;

          for (final c in allCutoffs) {
            final cReg = RegExp(
              r'([A-Za-z]{3})[-/ ](\d{1,2})[-/ ](\d{2,4})',
            ).firstMatch(c.payrollPeriod);
            if (cReg != null) {
              final cm = cReg.group(1)!.toLowerCase();
              final csDay = int.parse(cReg.group(2)!);
              final cyStr = cReg.group(3)!;
              final cy2 = cyStr.length == 4 ? cyStr.substring(2) : cyStr;
              if (cm == m && csDay == sDay && (cy2 == y2 || cyStr == y4)) {
                return c;
              }
            }
            if (c.timeStart != null) {
              final dt = c.timeStart is int
                  ? DateTime.fromMillisecondsSinceEpoch(c.timeStart as int)
                  : DateTime.tryParse(c.timeStart.toString());
              if (dt != null) {
                final local = dt.toLocal();
                const mList = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
                if (mList[local.month - 1] == m &&
                    (local.year.toString().endsWith(y2) || local.year.toString() == y4)) {
                  if ((sDay <= 15 && local.day <= 15) || (sDay > 15 && local.day > 15)) {
                    return c;
                  }
                }
              }
            }
          }
        }

        return allCutoffs.cast<Query$PayslipCutOffs$cutOffs?>().firstWhere(
              (c) =>
                  c != null &&
                  c.payrollPeriod.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '') ==
                      text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), ''),
              orElse: () => null,
            );
      }

      String targetCutoffId = cutoffId ?? '';
      String? matchedLabel;

      if (targetCutoffId.isNotEmpty) {
        final match = allCutoffs.cast<Query$PayslipCutOffs$cutOffs?>().firstWhere(
              (c) => c?.id == targetCutoffId,
              orElse: () => null,
            );
        matchedLabel = match?.payrollPeriod;
      } else if (cutoffText != null && cutoffText.isNotEmpty) {
        final match = findMatchingCutoff(cutoffText);
        if (match != null) {
          targetCutoffId = match.id;
          matchedLabel = match.payrollPeriod;
        }
      }

      // Default to latest approved cutoff ONLY when no cutoff was specified
      if (targetCutoffId.isEmpty && (cutoffText == null || cutoffText.isEmpty)) {
        final approved = allCutoffs.cast<Query$PayslipCutOffs$cutOffs?>().firstWhere(
              (c) => c != null && (c.payrollApproved == true || c.status == 4),
              orElse: () => allCutoffs.isNotEmpty ? allCutoffs.first : null,
            );
        targetCutoffId = approved?.id ?? '34';
        matchedLabel = approved?.payrollPeriod;
      }

      final displayLabel = cutoffText?.isNotEmpty == true
          ? cutoffText!
          : (matchedLabel?.isNotEmpty == true ? matchedLabel! : targetCutoffId);

      if (targetCutoffId.isEmpty) {
        return PayslipEntity.empty(displayLabel);
      }

      final payrollResult = await client.query$PayrollDetail(
        Options$Query$PayrollDetail(
          variables: Variables$Query$PayrollDetail(
            filter: Input$payslipFilter(
              cutOffId: targetCutoffId,
              userId: userId,
            ),
          ),
        ),
      );

      final payroll = payrollResult.parsedData?.payroll;
      if (payroll == null) {
        return PayslipEntity.empty(displayLabel, targetCutoffId);
      }

      String? prevCutoffId;
      final approvedList = allCutoffs
          .where((c) => c.payrollApproved == true || c.status == 4)
          .toList();
      final targetIdx = approvedList.indexWhere((c) => c.id == targetCutoffId);
      if (targetIdx >= 0 && targetIdx + 1 < approvedList.length) {
        prevCutoffId = approvedList[targetIdx + 1].id;
      } else {
        final intId = int.tryParse(targetCutoffId);
        if (intId != null && intId > 1) {
          prevCutoffId = (intId - 1).toString();
        }
      }

      Query$PayrollDetail$payroll? prevPayroll;
      if (prevCutoffId != null && prevCutoffId.isNotEmpty) {
        try {
          final prevResult = await client.query$PayrollDetail(
            Options$Query$PayrollDetail(
              variables: Variables$Query$PayrollDetail(
                filter: Input$payslipFilter(
                  cutOffId: prevCutoffId,
                  userId: userId,
                ),
              ),
            ),
          );
          prevPayroll = prevResult.parsedData?.payroll;
        } catch (_) {}
      }

      List<PayslipAllowanceItem> allowanceItems = [];
      try {
        final allowancesResult = await client.query(
          QueryOptions(
            document: gql(r'''
              query GetUserAllowances($filter: filter) {
                userAllowances(filter: $filter) {
                  id
                  userId
                  cutOffId
                  allowances
                  totalAllowance
                }
              }
            '''),
            variables: {
              'filter': {
                'cutOffId': targetCutoffId,
                'userId': userId,
              },
            },
          ),
        );

        final uAllowances = allowancesResult.data?['userAllowances'];
        if (uAllowances is List && uAllowances.isNotEmpty) {
          final first = uAllowances.first;
          final rawAllowances = first['allowances'];
          if (rawAllowances != null) {
            final parsed = (rawAllowances is String)
                ? jsonDecode(rawAllowances)
                : rawAllowances;
            if (parsed is List) {
              for (final item in parsed) {
                if (item is Map) {
                  allowanceItems.add(PayslipAllowanceItem(
                    label: item['label']?.toString() ?? '',
                    acquisitionType: item['regulation']?.toString() ?? 'n/a',
                    amount: (item['amount'] as num?)?.toDouble() ?? 0.0,
                  ));
                }
              }
            }
          }
        }
      } catch (_) {}

      if (allowanceItems.isNotEmpty) {
        allowanceItems.add(const PayslipAllowanceItem(
          label: '13th Month Bonus',
          acquisitionType: 'n/a',
          amount: 0.0,
        ));
        allowanceItems.add(const PayslipAllowanceItem(
          label: 'Monetized Unused Leaves',
          acquisitionType: 'n/a',
          amount: 0.0,
        ));
      }

      final overtimeHours = <String, double>{};
      final overtimeAmounts = <String, double>{};
      var overtimeAdjustment = 0.0;
      try {
        final otResult = await client.query(
          QueryOptions(
            document: gql(r'''
              query GetOvertimes($filter: overtimeFilter) {
                overtimes(filter: $filter) {
                  rotHours rotAmount rdHours rdAmount rdExcessHours rdExcessAmount
                  shHours shAmount shExcessHours shExcessAmount shAndRdHours shAndRdAmount
                  shAndRdExcessHours shAndRdExcessAmount rhHours rhAmount lhHours lhAmount
                  lhExcessHours lhExcessAmount lhAndRdHours lhAndRdAmount
                  lhAndRdExcessHours lhAndRdExcessAmount regNdHours regNdAmount
                  regNdExcessHours regNdExcessAmount rdNdHours rdNdAmount
                  rdNdExcessHours rdNdExcessAmount shNdHours shNdAmount
                  shNdExcessHours shNdExcessAmount shAndRdNdHours shAndRdNdAmount
                  shAndRdNdExcessHours shAndRdNdExcessAmount lhNdHours lhNdAmount
                  lhNdExcessHours lhNdExcessAmount lhAndRdNdHours lhAndRdNdAmount
                  lhAndRdNdExcessHours lhAndRdNdExcessAmount adjustment
                }
              }
            '''),
            variables: {
              'filter': {'cutOffId': targetCutoffId, 'userId': userId},
            },
            fetchPolicy: FetchPolicy.networkOnly,
          ),
        );
        final list = otResult.data?['overtimes'];
        if (list is List && list.isNotEmpty) {
          final ot = list.first as Map<String, dynamic>;
          ot.forEach((k, v) {
            final val = (v as num?)?.toDouble() ?? 0.0;
            if (k.endsWith('Hours')) {
              overtimeHours[k.substring(0, k.length - 5)] = val;
            } else if (k.endsWith('Amount')) {
              overtimeAmounts[k.substring(0, k.length - 6)] = val;
            } else if (k == 'adjustment') {
              overtimeAdjustment = val;
            }
          });
        }
      } catch (_) {}

      return PayslipModelMapper.fromDetail(
        payroll,
        prevPayroll: prevPayroll,
        cutoffLabel: displayLabel,
        cutoffId: targetCutoffId,
        allowanceItems: allowanceItems,
        overtimeHours: overtimeHours,
        overtimeAmounts: overtimeAmounts,
        overtimeAdjustment: overtimeAdjustment,
      );
    } catch (_) {}

    return PayslipEntity.empty(cutoffText);
  }
}
