class ApiString {
  /// Base URL
  static const String baseUrl = "http://65.0.211.122:4444/";
  static const String ImgBaseUrl = "http://65.0.211.122:4444/";

  /// admin Profile Auth Endpoints
  static const String signUp = "${baseUrl}student_registration";
  // static const String generateOtp = "${baseUrl}generate-otp";
  // static const String verifyOtp = "${baseUrl}verify-otp";
  static const String login = "${baseUrl}login";
  static const String forgotPassword = "${baseUrl}forgot_password";
  static const String changePassword = "${baseUrl}change_password";
  static const String edit_profile = "${baseUrl}edit_profile";
  static const String get_profile = "${baseUrl}get_profile";


  ///mentor
  static const String mentorBaseUrl = "http://65.0.211.122:4444/mentor_api/";
  static const String mentor_registration = "${mentorBaseUrl}mentor_registration";
  static const String get_all_mentors = "${baseUrl}get_all_mentors";
  static const String approve_mentor = "${baseUrl}approve_mentor";



  ///school_registration
  static const String schoolBaseUrl = "http://65.0.211.122:4444/school_api/";
  static const String school_registration = "${schoolBaseUrl}school_registration";


  /// Leaderboard
  static const String getLeaderboard = "${baseUrl}get_leaderboard";

  /// Attendance
  static const String addTodaysAttendance = "${baseUrl}add_todays_attendance";

  /// Vocabulary
  static const String getVocabularyCategories =
      "${baseUrl}get_vocabulary_categories";
  static const String add_vocabulary_categories =
      "${baseUrl}add_vocabulary_categories";
  static const String delete_vocabulary_categories =
      "${baseUrl}delete_vocabulary_categories";

  static const String add_notifications = "${baseUrl}add_notifications";

  static const String add_main_category = "${baseUrl}add_main_category";
  static const String get_main_category = "${baseUrl}get_main_category";
  static const String delete_main_category = "${baseUrl}delete_main_category";
  static const String add_sub_category = "${baseUrl}add_sub_category";
  static const String get_sub_category = "${baseUrl}get_sub_category";
  static const String delete_sub_category = "${baseUrl}delete_sub_category";
  static const String add_topics = "${baseUrl}add_topics";
  static const String get_topics = "${baseUrl}get_topics";
  static const String delete_topic = "${baseUrl}delete_topic";
  static const String add_subtopics = "${baseUrl}add_subtopics";
  static const String get_subtopics = "${baseUrl}get_subtopics";
  static const String delete_subtopics = "${baseUrl}delete_subtopics";
}
