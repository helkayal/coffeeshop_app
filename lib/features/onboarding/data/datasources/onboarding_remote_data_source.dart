import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/onboarding_question_model.dart';

/// Maps frontend question option IDs to backend onboarding enums.
const _coffeePreferenceMap = <String, String>{
  '1a': 'black_bold',
  '1b': 'sweet_creamy',
  '1c': 'balanced',
};

const _flavorProfileMap = <String, String>{
  '2a': 'nutty_chocolatey',
  '2b': 'fruity_bright',
  '2c': 'spiced_warm',
};

const _milkPreferenceMap = <String, String>{
  '3a': 'whole_milk',
  '3b': 'oat_milk',
  '3c': 'almond_milk',
  '3d': 'no_milk',
};

class OnboardingRemoteDataSource {
  final ApiService _apiService;

  OnboardingRemoteDataSource(this._apiService);

  /// Questions are frontend-only — returns hardcoded localized question data.
  Future<List<OnboardingQuestionModel>> getQuestions() async {
    return _getMockQuestions();
  }

  /// Saves the user's onboarding preferences to the backend.
  Future<void> saveOnboarding(Map<String, String> answers) async {
    final coffeePreference = _coffeePreferenceMap[answers['1']];
    final flavorProfile = _flavorProfileMap[answers['2']];
    final milkPreference = _milkPreferenceMap[answers['3']];

    try {
      await _apiService.post(
        ApiConstants.onboarding,
        data: {
          'coffee_preference': ?coffeePreference,
          'flavor_profile': ?flavorProfile,
          'milk_preference': ?milkPreference,
        },
      );
    } catch (_) {
      // Silently skip — onboarding happens before login.
    }
  }

  // // --- Onboarding questions (frontend-only, always local) ---
  Future<List<OnboardingQuestionModel>> _getMockQuestions() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      const OnboardingQuestionModel(
        id: '1',
        questionText: 'onboarding.q1.text',
        imageUrl: 'assets/images/artisanal_coffee_brewing.png',
        options: [
          OnboardingOptionModel(id: '1a', text: 'onboarding.q1.o1'),
          OnboardingOptionModel(id: '1b', text: 'onboarding.q1.o2'),
          OnboardingOptionModel(id: '1c', text: 'onboarding.q1.o3'),
        ],
      ),
      const OnboardingQuestionModel(
        id: '2',
        questionText: 'onboarding.q2.text',
        imageUrl: 'assets/images/coffee_preparation.png',
        options: [
          OnboardingOptionModel(id: '2a', text: 'onboarding.q2.o1'),
          OnboardingOptionModel(id: '2b', text: 'onboarding.q2.o2'),
          OnboardingOptionModel(id: '2c', text: 'onboarding.q2.o3'),
        ],
      ),
      const OnboardingQuestionModel(
        id: '3',
        questionText: 'onboarding.q3.text',
        imageUrl: 'assets/images/latte_art_being_poured.png',
        options: [
          OnboardingOptionModel(id: '3a', text: 'onboarding.q3.o1'),
          OnboardingOptionModel(id: '3b', text: 'onboarding.q3.o2'),
          OnboardingOptionModel(id: '3c', text: 'onboarding.q3.o3'),
          OnboardingOptionModel(id: '3d', text: 'onboarding.q3.o4'),
        ],
      ),
    ];
  }
}
