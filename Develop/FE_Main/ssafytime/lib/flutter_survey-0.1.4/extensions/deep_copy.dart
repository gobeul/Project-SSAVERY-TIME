import 'package:ssafytime/flutter_survey-0.1.4/flutter_survey.dart';

extension DeepCopy on Question {
  ///Returns a clone of the question and not the reference.
  Question clone() {
    return Question.fromJson(toJson());
  }
}
