class ApiString {

   static const String baseUrl = "http://65.0.211.122:4444/";
   static const String mentorBaseUrl= "";
   static const String ImgBaseUrl = "http://65.0.211.122:4444/";

   /// Auth Endpoints
   static const String signUp = "${baseUrl}student_registration";

   static const String mentor_registration = "" ;

   static const String login = "${baseUrl}login";
   static const String forgotPassword = "${baseUrl}forgot_password";
   static const String changePassword = "${baseUrl}change_password";

   /// Profile Endpoints
   static const String updateProfile = "${baseUrl}update_profile";
   static const String getProfile = "${baseUrl}get_profile";
   static const String edit_profile = "${baseUrl}edit_profile";

   /// Leaderboard
   static const String getLeaderboard = "${baseUrl}get_leaderboard";

   /// Attendance
   static const String addTodaysAttendance = "${baseUrl}add_todays_attendance";

   /// Vocabulary
   static const String getVocabularyCategories = "${baseUrl}get_vocabulary_categories";
   static const String add_vocabulary_categories = "${baseUrl}add_vocabulary_categories";
   static const String delete_vocabulary_categories = "${baseUrl}delete_vocabulary_categories";

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

   static const String add_mcq = "${baseUrl}add-mcq";
   static const String get_mcq = "${baseUrl}get-mcq";
   static const String delete_mcq = "${baseUrl}delete_mcq";
   static const String update_mcq = "${baseUrl}update_mcq";

   static const String add_fill_blanks = "${baseUrl}add_fill_blanks";
   static const String get_fill_blanks = "${baseUrl}get_fill_blanks";
   static const String delete_fill_blanks = "${baseUrl}delete_fill_blanks";
   static const String update_fill_blanks = "${baseUrl}update_fill_blanks";

   static const String add_card_flipping = "${baseUrl}add_card_flipping";
   static const String get_card_flipping = "${baseUrl}get_card_flipping";
   static const String delete_card_flipping = "${baseUrl}delete_card_flipping";
   static const String update_card_flipping = "${baseUrl}update_card_flipping";

   static const String add_story = "${baseUrl}add_story";
   static const String get_story = "${baseUrl}get_story";
   static const String delete_story = "${baseUrl}delete_story";
   static const String update_story = "${baseUrl}update_story";

   ///mentor
   static const String get_all_mentors = "${baseUrl}get_all_mentors";

   ///learner
   static const String get_all_learners = "${baseUrl}get_all_learners";
   static const String assign_mentor = "${baseUrl}get_all_learners";



   ///school_registration
   static const String schoolBaseUrl = "http://65.0.211.122:4444/mentor_api/";
   static const String school_registration = "${mentorBaseUrl}mentor_registration";

}
