/// Noms des mois en français (index 0 = janvier).
const List<String> signupBirthMonthNamesFr = [
  "Janvier",
  "Février",
  "Mars",
  "Avril",
  "Mai",
  "Juin",
  "Juillet",
  "Août",
  "Septembre",
  "Octobre",
  "Novembre",
  "Décembre",
];

int signupDaysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

int signupMaxBirthYear() => DateTime.now().year - 18;

int signupMinBirthYear() => DateTime.now().year - 115;

List<int> signupBirthYearOptions() {
  final minY = signupMinBirthYear();
  final maxY = signupMaxBirthYear();
  return List.generate(maxY - minY + 1, (i) => maxY - i);
}

DateTime signupBirthDateDefault18YearsAgo() {
  final n = DateTime.now();
  return DateTime(n.year - 18, n.month, n.day);
}
