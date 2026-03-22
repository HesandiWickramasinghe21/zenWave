import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  String _fullName = "User Name";
  String _gender = "Male"; // Default to Male, will update from API

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await ApiService.profile();
      final user = data["user"] as Map<String, dynamic>? ?? {};
      
      if (!mounted) return;
      setState(() {
        _fullName = user["full_name"]?.toString() ?? "User Name";
        // Assuming your API returns "Male" or "Female"
        _gender = user["gender"]?.toString() ?? "Male"; 
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF9147FF);

    // Determine which asset to use based on gender
    // Make sure these match your actual asset filenames!
    String avatarAsset = (_gender.toLowerCase() == "female") 
        ? "assets/female_avatar.png" 
        : "assets/male_avatar.png";

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ZenWave Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: themeColor))
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // DYNAMIC PROFILE IMAGE
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: themeColor.withOpacity(0.2), width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFFE0E0E0),
                      // The logic switches the image here
                      backgroundImage: AssetImage(avatarAsset), 
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  _fullName,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                ),
                const SizedBox(height: 4),
                Text(
                  "Mindfulness Enthusiast",
                  style: TextStyle(fontSize: 14, color: themeColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                ),
                
                const SizedBox(height: 40),
                
                // Menu Options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      _buildProfileOption(Icons.person_outline_rounded, "Account Settings"),
                      _buildProfileOption(Icons.notifications_none_rounded, "Notifications"),
                      _buildProfileOption(Icons.shield_outlined, "Privacy & Security"),
                      _buildProfileOption(Icons.spa_outlined, "Personal Preferences"),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                
                // Logout Button
                TextButton.icon(
                  onPressed: () async {
                    await ApiService.logout();
                    if (mounted) Navigator.pushReplacementNamed(context, "/login");
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                
                const SizedBox(height: 10),
                const Text(
                  "ZenWave v2.4.0 • Built for Peace",
                  style: TextStyle(color: Colors.black26, fontSize: 12),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF9147FF), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF4A4A4A)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        onTap: () {},
      ),
    );
  }
}