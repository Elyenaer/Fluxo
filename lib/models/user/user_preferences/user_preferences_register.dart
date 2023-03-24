
// ignore_for_file: non_constant_identifier_names

class UserPreferencesRegister {
  int? id_user_preferences;
  int? id_theme;

  double? scale;
  String? period_report;
  DateTime? start_date_report;
  DateTime? end_date_report;

  UserPreferencesRegister(
    this.id_user_preferences,
    this.id_theme,
    this.scale,
    this.period_report,
    this.start_date_report,
    this.end_date_report
  );

  static UserPreferencesRegister getDefault() {
    return UserPreferencesRegister(1,1,1,"Semanal",DateTime.now(),DateTime.now().add(const Duration(days: 30)));
  }

}