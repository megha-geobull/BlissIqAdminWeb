import 'package:blissiqadmin/Home/Drawer/MyDrawer.dart';
import 'package:blissiqadmin/Home/Users/Company/CompanyScreen.dart';
import 'package:blissiqadmin/Home/Users/Mentor/MentorScreen.dart';
import 'package:blissiqadmin/Home/Users/School/SchoolScreen.dart';
import 'package:blissiqadmin/Home/Users/Students/StudentScreen.dart';
import 'package:blissiqadmin/Home/Users/TeacherScreen/TeacherScreen.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Check screen size for responsiveness
          bool isWideScreen = constraints.maxWidth > 800;

          return Row(
            children: [
              // Always visible drawer for wide screens
              if (isWideScreen)
                Container(
                  width: 250,
                  color: Colors.orange.shade100,
                  child: MyDrawer(),
                ),
              Expanded(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade100,
                  appBar: isWideScreen
                      ? null
                      : AppBar(
                          title: const Text('Dashboard'),
                          scrolledUnderElevation: 0,
                          backgroundColor: Colors.blue.shade100,
                          actions: [
                            IconButton(
                              icon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Handle notifications
                              },
                            ),
                          ],
                        ),
                  drawer:
                      isWideScreen ? null : Drawer(child: MyDrawer()),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 16),
                    child: _buildMainContent(constraints, context),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
Widget _buildMainContent(BoxConstraints constraints,BuildContext context,) {
  return Column(
    children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, color: Colors.orange),
            SizedBox(width: 10),
            Text(
              'Select a User Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: Center(
          child: Container(
            width: 600,
            child: ListView(
              children: [
                UserCategoryTile(
                  title: 'Company',
                  icon: Icons.apartment,
                  color: Colors.blueAccent,
                  backgroundColor: const Color(0xFFEAF2FF),
                  onTap: () => _navigateToPage(context, 'Company'),
                ),
                UserCategoryTile(
                  title: 'School',
                  icon: Icons.school,
                  color: Colors.amber,
                  backgroundColor: const Color(0xFFFFFDEB),
                  onTap: () => _navigateToPage(context, 'School'),
                ),
                UserCategoryTile(
                  title: 'Mentor',
                  icon: Icons.person,
                  color: Colors.purple,
                  backgroundColor: const Color(0xFFF7F3FF),
                  onTap: () => _navigateToPage(context, 'Mentor'),
                ),
                // UserCategoryTile(
                //   title: 'Teacher',
                //   icon: Icons.person_pin_rounded,
                //   color: Colors.blue,
                //   backgroundColor: const Color(0xFFEAF2FF),
                //   onTap: () => _navigateToPage(context, 'Teacher'),
                // ),
                UserCategoryTile(
                  title: 'Student',
                  icon: Icons.person_2,
                  color: Colors.green,
                  backgroundColor: const Color(0xFFE5F8E7),
                  onTap: () => _navigateToPage(context, 'Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

// Navigation Function
_navigateToPage(BuildContext context, String userType) {
  late Widget nextScreen;

  switch (userType) {
    case 'Student':
      nextScreen = StudentScreen();
      break;
    case 'School':
      nextScreen = SchoolScreen();
      break;
    case 'Mentor':
      nextScreen = MentorScreen();
      break;
    case 'Company':
      nextScreen = CompanyScreen();
      break;
    // case 'Teacher':
    //   nextScreen = TeacherScreen();
    //   break;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => nextScreen,
    ),
  );
}



class UserCategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback? onTap;  // onTap for navigation

  const UserCategoryTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          leading: CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        ),
      ),
    );
  }
}


