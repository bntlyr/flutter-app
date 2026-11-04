import 'package:flutter/foundation.dart';
import 'package:flutter_app/shared/models/profile_model.dart';
import '../../domain/usecases/get_personal_profile.dart';
import '../../data/repositories/personal_repository_impl.dart';

/// ViewModel managing state for the Personal Employee Profile screen.
class PersonalViewModel extends ChangeNotifier {
  final GetPersonalProfileUseCase getProfileUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  EmployeeProfile? _profile;

  PersonalViewModel({
    GetPersonalProfileUseCase? getProfileUseCase,
    EmployeeProfile? initialProfile,
  })  : getProfileUseCase = getProfileUseCase ??
            GetPersonalProfileUseCase(PersonalRepositoryImpl()),
        _profile = initialProfile;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  EmployeeProfile? get profile => _profile;
  bool get hasError => _errorMessage != null;

  Future<void> loadProfile({bool showLoading = true}) async {
    if (showLoading && _profile == null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      _profile = await getProfileUseCase.execute();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadProfile(showLoading: false);
}
