import 'package:flutter/foundation.dart';
import '../../domain/entities/payslip_entity.dart';
import '../../domain/usecases/get_payslip_usecase.dart';
import '../../data/repositories/payslip_repository_impl.dart';

export '../../domain/entities/payslip_entity.dart';

class PayslipViewModel extends ChangeNotifier {
  final GetPayslipUseCase getPayslipUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  PayslipEntity? _payslip;
  List<CutoffOptionEntity> _availableCutoffs = [];
  String _selectedCutoffText = '';
  String? _selectedCutoffId;

  PayslipViewModel({
    GetPayslipUseCase? getPayslipUseCase,
    PayslipEntity? initialPayslip,
  })  : getPayslipUseCase = getPayslipUseCase ??
            GetPayslipUseCase(const PayslipRepositoryImpl()),
        _payslip = initialPayslip;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  PayslipEntity? get payslip => _payslip;
  List<CutoffOptionEntity> get availableCutoffs => _availableCutoffs;
  String get selectedCutoffText => _selectedCutoffText;
  String? get selectedCutoffId => _selectedCutoffId;

  Future<void> initialize({String? initialCutoff}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _availableCutoffs = await getPayslipUseCase.getCutoffs();
      if (initialCutoff != null && initialCutoff.isNotEmpty) {
        _selectedCutoffText = initialCutoff;
      }
      await loadPayslip(cutoffText: _selectedCutoffText);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      _payslip = PayslipEntity.empty(_selectedCutoffText);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPayslip({String? cutoffId, String? cutoffText}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _payslip = await getPayslipUseCase.execute(
        cutoffId: cutoffId ?? _selectedCutoffId,
        cutoffText: cutoffText ?? _selectedCutoffText,
      );
      if (_payslip != null && _payslip!.cutoff.isNotEmpty && _payslip!.cutoff != 'N/A') {
        _selectedCutoffText = _payslip!.cutoff;
        if (_payslip!.cutoffId.isNotEmpty) {
          _selectedCutoffId = _payslip!.cutoffId;
        }
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
      _payslip = PayslipEntity.empty(cutoffText ?? _selectedCutoffText);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectCutoff(String cutoffText, [String? cutoffId]) async {
    _selectedCutoffText = cutoffText;
    _selectedCutoffId = cutoffId;
    await loadPayslip(cutoffId: cutoffId, cutoffText: cutoffText);
  }
}
