import 'package:flutter/material.dart';
import '../services/api_service.dart';

// IMPORTANT: Make sure you have this file created or the class defined below
// import 'payment_screen.dart'; 

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  String _firstName = "User";
  String _email = "user@zenwave.com";
  String _selectedAvatarPath = "assets/avatar/avatar1.png";
  bool _hasSelectedAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await ApiService.profile();
      if (!mounted) return;
      setState(() {
        final String fullName = data["full_name"]?.toString() ?? "User";
        _firstName = fullName.split(' ').first;
        _email = data["email"]?.toString() ?? "zen@member.com";
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Profile Loading Error: $e");
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(context).padding.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "CHOOSE YOUR AVATAR",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black26,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final String path = "assets/avatar/avatar${index + 1}.png";
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatarPath = path;
                        _hasSelectedAvatar = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedAvatarPath == path
                              ? const Color.fromARGB(255, 207, 164, 225)
                              : Colors.transparent,
                          width: 4,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFFF7F8FA),
                        foregroundImage: AssetImage(path),
                        child: const Icon(Icons.person, color: Colors.black12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 213, 178, 221),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E5E5), width: 3),
      ),
      child: ClipOval(
        child: _hasSelectedAvatar
            ? Image.asset(
                _selectedAvatarPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const Icon(Icons.person, size: 60, color: Colors.white),
              )
            : const Icon(Icons.person, size: 60, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF58CC02)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.black26,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      _buildProfileImage(55),
                      GestureDetector(
                        onTap: _showAvatarPicker,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFB800),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                            ],
                          ),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _firstName,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF4B4B4B)),
                  ),
                  Text(
                    _email,
                    style: const TextStyle(color: Colors.black26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // FIXED GESTURE DETECTOR HERE
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PaymentScreen()),
                );
              },
              child: _buildDuoButton("UPGRADE TO PRO", const Color(0xFFFFB800)),
            ),

            const SizedBox(height: 35),
            _buildMenuTile(Icons.shield_outlined, "Privacy", const Color(0xFF1CB0F6),
                onTap: () => Navigator.pushNamed(context, '/privacy')),
            _buildMenuTile(Icons.history, "Purchase History", Colors.black45,
                onTap: () => Navigator.pushNamed(context, '/purchase-history')),
            _buildMenuTile(Icons.help_outline, "Help & Support", const Color(0xFF58CC02),
                onTap: () => Navigator.pushNamed(context, '/help')),
            _buildMenuTile(Icons.settings_outlined, "Settings", Colors.black45,
                onTap: () => Navigator.pushNamed(context, '/settings')),
            _buildMenuTile(Icons.logout, "Logout", Colors.redAccent),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDuoButton(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.5), offset: const Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color iconColor, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
        boxShadow: const [BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4))],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF4B4B4B))),
        trailing: const Icon(Icons.chevron_right, color: Colors.black12),
      ),
    );
  }
}

// THE PAYMENT SCREEN CLASS (ADD THIS TO YOUR PROJECT)
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: const CloseButton(color: Colors.black26)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.auto_awesome, size: 80, color: Color(0xFFFFB800)),
            const SizedBox(height: 20),
            const Text("GET PRO", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFB800), width: 3),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ZenWave Monthly", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  Text("\$9.99", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("PAY NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            ),
          ],
        ),
      ),
    );
  }
}