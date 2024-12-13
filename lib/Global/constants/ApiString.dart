class ApiString {
   /// Base URL
   static const String baseUrl = "http://65.0.211.122:4444/cust_api/";
   static const String ImgBaseUrl = "http://65.0.211.122:4444/";

   /// Auth Endpoints
   static const String signUp = "${baseUrl}student_registration";
   static const String generateOtp = "${baseUrl}generate-otp";
   static const String verifyOtp = "${baseUrl}verify-otp";
   static const String login = "${baseUrl}login";
   static const String forgotPassword = "${baseUrl}forgot_password";
   static const String changePassword = "${baseUrl}change_password";

   /// Profile Endpoints
   static const String updateProfile = "${baseUrl}update_profile";
   static const String getProfile = "${baseUrl}get_profile";
   static const String edit_profile = "${baseUrl}edit_profile";

   /// Dictionary words
   static const String add_save_word = "${baseUrl}add_save_word";
   static const String get_save_words = "${baseUrl}get_save_words";
   static const String delete_save_word = "${baseUrl}delete_save_word";

   /// Notifications
   static const String getNotifications = "${baseUrl}get_notifications";

   /// Leaderboard
   static const String getLeaderboard = "${baseUrl}get_leaderboard";

   /// Attendance
   static const String addTodaysAttendance = "${baseUrl}add_todays_attendance";

   /// Vocabulary
   static const String getVocabularyCategories = "${baseUrl}get_vocabulary_categories";
}
