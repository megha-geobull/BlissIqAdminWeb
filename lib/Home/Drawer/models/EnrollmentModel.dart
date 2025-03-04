//
// class Enrollmentmodel {
//   final int status;
//   final Map<String, int> weeklyCounts;
//   final Map<String, int> monthlyCounts;
//   final Map<String, int> yearlyCounts;
//   final Map<String, int> last5YearsCounts;
//   final double students;
//   final double mentors;
//   final double schools;
//   final double companies;
//
//   Enrollmentmodel({
//     required this.status,
//     required this.weeklyCounts,
//     required this.monthlyCounts,
//     required this.yearlyCounts,
//     required this.last5YearsCounts,
//     required this.students,
//     required this.mentors,
//     required this.schools,
//     required this.companies,
//   });
//
//   factory Enrollmentmodel.fromJson(Map<String, dynamic> json) => Enrollmentmodel(
//       status: json['status'],
//       weeklyCounts: Map<String, int>.from(json['weekly_counts']),
//       monthlyCounts: Map<String, int>.from(json['monthly_counts']),
//       yearlyCounts: Map<String, int>.from(json['yearly_counts']),
//       last5YearsCounts: Map<String, int>.from(json['last_5_years_counts']),
//       students: json['students'].toDouble(),
//       mentors: json['mentors'].toDouble(),
//       schools: json['schools'].toDouble(),
//       companies: json['companies'].toDouble(),
//     );
// }

class Enrollmentmodel {
  final int status;
  final Map<String, int> weeklyCounts;
  final Map<String, int> monthlyCounts;
  final Map<String, int> yearlyCounts;
  final Map<String, int> last5YearsCounts;
  final double students;
  final double mentors;
  final double schools;
  final double companies;

  Enrollmentmodel({
    required this.status,
    required this.weeklyCounts,
    required this.monthlyCounts,
    required this.yearlyCounts,
    required this.last5YearsCounts,
    required this.students,
    required this.mentors,
    required this.schools,
    required this.companies,
  });

  factory Enrollmentmodel.fromJson(Map<String, dynamic> json) {
    return Enrollmentmodel(
      status: json['status'] as int? ?? 0,
      weeklyCounts: json['weekly_counts'] != null
          ? Map<String, int>.from(json['weekly_counts'])
          : {"Sunday": 0, "Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0, "Friday": 0, "Saturday": 0},
      monthlyCounts: json['monthly_counts'] != null
          ? Map<String, int>.from(json['monthly_counts'])
          : {"Week-1": 0, "Week-2": 0, "Week-3": 0, "Week-4": 0},
      yearlyCounts: json['yearly_counts'] != null
          ? Map<String, int>.from(json['yearly_counts'])
          : {"Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0},
      last5YearsCounts: json['last_5_years_counts'] != null
          ? Map<String, int>.from(json['last_5_years_counts'])
          : {"2025": 0, "2024": 0, "2023": 0, "2022": 0, "2021": 0},
      students: (json['students'] as num?)?.toDouble() ?? 0.0,
      mentors: (json['mentors'] as num?)?.toDouble() ?? 0.0,
      schools: (json['schools'] as num?)?.toDouble() ?? 0.0,
      companies: (json['companies'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Default constructor for empty state
  Enrollmentmodel.empty()
      : status = 0,
        weeklyCounts = {"Sunday": 0, "Monday": 0, "Tuesday": 0, "Wednesday": 0, "Thursday": 0, "Friday": 0, "Saturday": 0},
        monthlyCounts = {"Week-1": 0, "Week-2": 0, "Week-3": 0, "Week-4": 0},
        yearlyCounts = {"Jan": 0, "Feb": 0, "Mar": 0, "Apr": 0, "May": 0, "Jun": 0, "Jul": 0, "Aug": 0, "Sep": 0, "Oct": 0, "Nov": 0, "Dec": 0},
        last5YearsCounts = {"2025": 0, "2024": 0, "2023": 0, "2022": 0, "2021": 0},
        students = 0.0,
        mentors = 0.0,
        schools = 0.0,
        companies = 0.0;
}