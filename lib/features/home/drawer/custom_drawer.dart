import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iptv_app/features/home/drawer/user_details_provider.dart';
import 'package:iptv_app/features/home/drawer/edit_profile_screen.dart'; // Ensure this path is correct
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iptv_app/authentication/login/login.dart';
import '../home.dart';
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black, // Dark theme for Netflix-like design
      child: Consumer<UserDetailsProvider>(
        builder: (context, userDetailsProvider, _) {
          userDetailsProvider.getUserDetails(); // Fetch user details when drawer opens

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Drawer Header
              DrawerHeader(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.transparent, // No background color
                                backgroundImage: userDetailsProvider.profilePicture.isNotEmpty
                                    ? NetworkImage(userDetailsProvider.profilePicture) // Load user's profile image
                                    : AssetImage('assets/images/profile.png') as ImageProvider,
                                onBackgroundImageError: (_, __) {
                                  // Fallback to placeholder if profile picture fails to load
                                  debugPrint('Failed to load profile image');
                                },
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.greenAccent),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => EditProfileScreen()), // Navigate to edit profile screen
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            userDetailsProvider.name.isNotEmpty
                                ? userDetailsProvider.name
                                : 'Guest User',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userDetailsProvider.email.isNotEmpty
                                ? userDetailsProvider.email
                                : 'No email provided',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // List of Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>NetflixStyleBody()), // Navigate to EditProfileScreen
          );
          // Close the drawer
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.person,
                      title: 'My Account',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen()), // Navigate to EditProfileScreen
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.tv,
                      title: 'Live TV',
                      onTap: () {
                        Navigator.pop(context); // Implement navigation to Live TV page
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.movie,
                      title: 'Movies',
                      onTap: () {
                        // Implement navigation to Movies page
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info,
                      title: 'Terms & Conditions',
                      onTap: () {
                        // Implement navigation to Terms and Conditions page
                      },
                    ),
                    const Divider(color: Colors.white24),
                    _buildDrawerItem(
                      context,
                      icon: Icons.logout,
                      title: 'Logout',
                      color: Colors.redAccent,
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.remove('accessToken');
                        Provider.of<UserDetailsProvider>(context, listen: false).clearUserData();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bottom Section: Version or Help info
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'App Version 1.0.0',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper function to build drawer items with icons and styling
  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 18),
      ),
      onTap: onTap,
    );
  }
}
