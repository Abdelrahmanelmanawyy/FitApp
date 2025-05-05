class CalorieCalculator {
  static int calculate({
    required String goal,
    required int age,
    required int height,
    required int weight,
    required String gender,
    required String activity,
  }) {
    double bmr;
    if (gender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    double multiplier;
    switch (activity) {
      case 'Sedentary':
        multiplier = 1.2;
        break;
      case 'Lightly active':
        multiplier = 1.375;
        break;
      case 'Moderately active':
        multiplier = 1.55;
        break;
      case 'Active':
        multiplier = 1.725;
        break;
      case 'Very active':
        multiplier = 1.9;
        break;
      default:
        multiplier = 1.55;
    }

    double tdee = bmr * multiplier;
    if (goal == 'Lose weight') tdee -= 500;
    if (goal == 'Gain weight') tdee += 500;

    return tdee.round();
  }
}