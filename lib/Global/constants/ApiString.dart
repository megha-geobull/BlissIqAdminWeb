class ApiString {
  /// Base URL
  static const String baseUrl = "http://65.0.211.122:4444/";
  static const String ImgBaseUrl = "http://65.0.211.122:4444/";
  static const String AttachentBaseUrl = "http://65.0.211.122:4444";

  /// Auth Endpoints
  static const String signUp = "${baseUrl}student_registration";
  static const String student_base_url = "http://65.0.211.122:4444/cust_api/";


  static const String login = "${baseUrl}login";
  static const String forgotPassword = "${baseUrl}forgot_password";
  static const String changePassword = "${baseUrl}change_password";

  static const String edit_profile = "${baseUrl}edit_profile";
  static const String get_profile = "${baseUrl}get_profile";

  static const String add_learning_slide = "${baseUrl}add_learning_slide";

  static const String search_student = "${baseUrl}search_student";


  ///mentor
  static const String mentorBaseUrl = "http://65.0.211.122:4444/mentor_api/";
  static const String mentor_registration = "${mentorBaseUrl}mentor_registration";
  static const String update_mentor_profile = "${mentorBaseUrl}edit_profile";
  static const String get_all_mentors = "${baseUrl}get_all_mentors";
  static const String delete_mentors = "${baseUrl}delete_mentors";
  static const String approve_mentor = "${baseUrl}approve_mentor";
  static const String assign_mentor = "${baseUrl}assign_mentor";
  static const String get_assign_teachers = "${baseUrl}get_assign_teachers";


  ///school_registration
  static const String schoolBaseUrl = "http://65.0.211.122:4444/school_api/";
  static const String school_registration = "${schoolBaseUrl}school_registration";
  static const String update_school_profile = "${schoolBaseUrl}edit_profile";
  static const String approve_school = "${baseUrl}approve_school";
  static const String get_all_schools = "${baseUrl}get_all_schools";
  static const String assign_school = "${baseUrl}assign_school";
  static const String delete_schools = "${baseUrl}delete_schools";

  ///learner
  static const String get_all_learners = "${baseUrl}get_all_learners";
  static const String delete_students = "${baseUrl}delete_students";


  ///company registration
  static const String companyBaseUrl = "http://65.0.211.122:4444/company_api/";
  static const String company_registration = "${companyBaseUrl}company_registration";
  static const String edit_company_profile = "${companyBaseUrl}edit_profile";
  static const String approve_company = "${baseUrl}approve_company";
  static const String get_all_companies = "${baseUrl}get_all_companies";
  static const String delete_companies = "${baseUrl}delete_companies";
  static const String get_assign_schools = "${baseUrl}get_assign_schools";


  /// Profile Endpoints
  static const String updateProfile = "${baseUrl}update_profile";
  static const String getProfile = "${baseUrl}get_profile";

  /// Leaderboard
  static const String getLeaderboard = "${student_base_url}get_leaderboard";

  /// Attendance
  static const String addTodaysAttendance = "${baseUrl}add_todays_attendance";

  /// Vocabulary
  static const String getVocabularyCategories = "${baseUrl}get_vocabulary_categories";
  static const String add_vocabulary_categories = "${baseUrl}add_vocabulary_categories";
  static const String delete_vocabulary_categories = "${baseUrl}delete_vocabulary_categories";

  static const String add_notifications = "${baseUrl}add_notifications";
  static const String get_notifications = "${baseUrl}get_notifications";
  static const String delete_notifications = "${baseUrl}delete_notifications";

  static const String add_main_category = "${baseUrl}add_main_category";
  static const String get_main_category = "${baseUrl}get_main_category";
  static const String delete_main_category = "${baseUrl}delete_main_category";

  static const String add_sub_category = "${baseUrl}add_sub_category";
  static const String get_sub_category = "${baseUrl}get_sub_category";
  static const String delete_sub_category = "${baseUrl}delete_sub_category";
  static const String reorder_sub_category = "${baseUrl}reorder_sub_category";

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

  static const String add_guess_the_image = "${baseUrl}add_guess_the_image";
  static const String get_guess_the_image = "${baseUrl}get_guess_the_image";
  static const String delete_guess_the_image = "${baseUrl}delete_guess_the_image";
  static const String update_guess_the_image = "${baseUrl}update_guess_the_image";

  static const String add_card_flipping = "${baseUrl}add_card_flipping";
  static const String get_card_flipping = "${baseUrl}get_card_flipping";
  static const String delete_card_flipping = "${baseUrl}delete_card_flipping";
  static const String update_card_flipping = "${baseUrl}update_card_flipping";
  static const String delete_card_flip_entry = "${baseUrl}delete_card_flip_entry";
  static const String add_card_flip_entry = "${baseUrl}add_card_flip_entry";


  static const String add_puzzle_the_image = "${baseUrl}add_puzzle_the_image";
  static const String get_puzzle_the_image = "${baseUrl}get_puzzle_the_image";
  static const String delete_puzzle_the_image = "${baseUrl}delete_puzzle_the_image";
  static const String update_puzzle_the_image = "${baseUrl}update_puzzle_the_image";
  static const String add_puzzle_entry = "${baseUrl}add_puzzle_entry";
  static const String delete_puzzle_entry = "${baseUrl}delete_puzzle_entry";


  static const String add_story = "${baseUrl}add_story";
  static const String get_story = "${baseUrl}get_story";
  static const String delete_story = "${baseUrl}delete_story";
  static const String update_story = "${baseUrl}update_story";

  static const String add_story_phrases = "${baseUrl}add_story_phrases";
  static const String get_story_phrases = "${baseUrl}get_story_phrases";
  static const String delete_story_phrases = "${baseUrl}delete_story_phrases";
  static const String update_story_phrases = "${baseUrl}update_story_phrases";

  static const String add_rearrange = "${baseUrl}add_rearrange";
  static const String delete_rearrange = "${baseUrl}delete_rearrange";
  static const String get_rearrange = "${baseUrl}get_rearrange";
  static const String update_rearrange = "${baseUrl}update_rearrange";


  static const String update_complete_the_word = "${baseUrl}update_complete_the_word";
  static const String update_complete_the_paragraph = "${baseUrl}update_complete_the_paragraph";

  static const String add_complete_sentence = "${baseUrl}add_complete_sentence";
  static const String get_complete_sentence = "${baseUrl}get_complete_sentence";
  static const String delete_complete_sentence = "${baseUrl}delete_complete_sentence";
  static const String update_complete_sentence = "${baseUrl}update_complete_sentence";

  static const String add_true_false = "${baseUrl}add_true_false";
  static const String get_true_false = "${baseUrl}get_true_false";
  static const String delete_true_false = "${baseUrl}delete_true_false";
  static const String update_true_false = "${baseUrl}update_true_false";

  static const String add_conversation = "${baseUrl}add_conversation";
  static const String get_user_conversation = "${baseUrl}get_user_conversation";
  static const String delete_conversation = "${baseUrl}delete_conversation";
  static const String update_conversation = "${baseUrl}update_conversation";

  static const String get_learning_slide = "${baseUrl}get_learning_slide";
  static const String update_learning_slide = "${baseUrl}update_learning_slide";
  static const String delete_learning_slide = "${baseUrl}delete_learning_slide";

  static const String add_complete_the_word = "${baseUrl}add_complete_the_word";
  static const String get_complete_the_word = "${baseUrl}get_complete_the_word";
  static const String delete_complete_the_word = "${baseUrl}delete_complete_the_word";
  // static const String update_complete_word = "${baseUrl}update_complete_word";

  static const String add_complete_the_paragraph = "${baseUrl}add_complete_the_paragraph";
  static const String get_complete_the_paragraph = "${baseUrl}get_complete_the_paragraph";
  static const String delete_complete_the_paragraph = "${baseUrl}delete_complete_the_word";


  /// Questions widgets

  static const String add_match_pair_question = "${baseUrl}add_match_pair_question";
  static const String get_match_pair_question = "${baseUrl}get_match_pair_question";
  static const String delete_match_pair_question = "${baseUrl}delete_match_pair_question";
  static const String add_match_pair_question_entry = "${baseUrl}add_match_pair_question_entry";
  static const String delete_match_pair_question_entry = "${baseUrl}delete_match_pair_question_entry";
  static const String update_match_pair_question = "${baseUrl}update_match_pair_question";

  ///learning path
  static const String studentBaseUrl = "http://65.0.211.122:4444/cust_api/";
  static const String get_my_learning_path = "${studentBaseUrl}get_my_learning_path";


  static const String add_topic_example = "${baseUrl}add_topic_example";
  static const String delete_topic_example = "${baseUrl}delete_topic_example";

  //Complaint Apis
  static const String get_enrollment_students = "${baseUrl}get_enrollment_students";
  static const String get_raised_complaint = "${student_base_url}get_raised_complaint";
  static const String update_complaint_status = "${student_base_url}update_complaint_status";




}
