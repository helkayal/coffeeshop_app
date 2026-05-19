import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/onboarding_question_model.dart';

class OnboardingRemoteDataSource {
  static const _useMockData = true;

  final ApiService _apiService;

  OnboardingRemoteDataSource(this._apiService);

  Future<List<OnboardingQuestionModel>> getQuestions() async {
    if (_useMockData) return _getMockQuestions();
    return _getQuestionsFromApi();
  }

  Future<List<OnboardingQuestionModel>> _getQuestionsFromApi() async {
    final response = await _apiService.get(ApiConstants.onboardingQuestions);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) =>
            OnboardingQuestionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

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
