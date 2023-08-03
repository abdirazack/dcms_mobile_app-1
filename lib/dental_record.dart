import 'package:dcms_mobile_app/themes/darktheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DentalRecord extends StatefulWidget {
  @override
  State<DentalRecord> createState() => _DentalRecordState();
}

class _DentalRecordState extends State<DentalRecord> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Profile Settings Section
            _buildSettingsSection(
              context,
              Icons.account_circle_rounded,
              'Profile Settings',
              [
                _buildSettingsItem('View and Update Personal Info', () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => PersonalInfoPage(),
                  //   ),
                  // );
                }),
                _buildSettingsItem('Change Profile Picture', () {
                  // Implement change profile picture logic
                }),
              ],
            ),

            // Password Management Section
            _buildSettingsSection(
              context,
              Icons.lock_rounded,
              'Password Management',
              [
                _buildSettingsItem('Change Password', () {
                  // Implement password change logic
                }),
                _buildSettingsItem('Password Recovery', () {
                  // Implement password recovery logic
                }),
              ],
            ),
            Column(
              // crossAxisAlignment: CrossAxisAlignment.,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    color: Colors.grey[200],
                    child: SwitchListTile(
                      title: Row(
                        children: [
                          Icon(Icons.dark_mode_rounded),
                          Text("Dark Mode")
                        ],
                      ),
                      value: _isDarkMode,
                      onChanged: (value) {
                        setState(() {
                          _isDarkMode = value;
                        });
                        themeProvider.toggleTheme();
                      },
                    )),
                // Divider(),

                SizedBox(height: 20),
              ],
            ),
            // App Feedback Section
            _buildSettingsSection(
              context,
              Icons.feedback_rounded,
              'App Feedback',
              [
                _buildSettingsItem('Provide App Feedback', () {
                  // Implement app feedback form or email support logic
                }),
              ],
            ),

            // Logout Section
            _buildSettingsSection(
              context,
              Icons.logout_rounded,
              'Logout',
              [
                _buildSettingsItem('Logout', () {
                  _showLogoutConfirmationDialog(context);
                }, textColor: Colors.red),
              ],
            ),

            // About Page Section
            _buildSettingsSection(
              context,
              Icons.info_rounded,
              'About Page',
              [
                _buildSettingsItem('App Information', () {
                  // Implement app information display logic
                }),
                _buildSettingsItem('Third-Party Libraries', () {
                  // Implement third-party libraries acknowledgment logic
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    IconData icon,
    String title,
    List<Widget> settingsItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[200],
          child: ListTile(
            leading: Icon(icon),
            title: Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        // Divider(),
        ...settingsItems,
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSettingsItem(String text, VoidCallback onPressed,
      {Color? textColor}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.syne(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Perform logout logic here
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}

// class PersonalInfoPage extends StatefulWidget {
//   @override
//   _PersonalInfoPageState createState() => _PersonalInfoPageState();
// }

// class _PersonalInfoPageState extends State<PersonalInfoPage> {
//   // Rest of the PersonalInfoPage code remains unchanged
//   // ...
//   // ...
// }

// class AboutAppPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Rest of the AboutAppPage code remains unchanged
//     // ...
//     // ...
//   }
// }

// Other classes (Patient, ThemeProvider, etc.) remain the same.
