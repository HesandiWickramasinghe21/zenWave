import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'privacy_screen.dart';
import 'purchase_history_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isLoading = true;
  bool _isPro = false;
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
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
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
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFFF3EFFF),
                    foregroundImage: AssetImage(path),
                    child: const Icon(Icons.person, color: Colors.black12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black45),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PROFILE",
          style: TextStyle(
            color: Colors.black45,
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
                            color: Color(0xFF6366F1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _firstName,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    _email,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),

            // UPGRADE BUTTON
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodScreen(email: _email),
                  ),
                );
                if (result == true) setState(() => _isPro = true);
              },
              child: _buildModernButton(
                _isPro ? "PRO ACTIVE" : "UPGRADE TO PRO",
                _isPro ? const Color(0xFF10B981) : const Color(0xFF6366F1),
              ),
            ),

            const SizedBox(height: 35),

            _buildMenuTile(
              icon: Icons.shield_outlined,
              title: "Privacy & Security",
              iconColor: const Color(0xFF3B82F6),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyScreen()),
              ),
            ),

            _buildMenuTile(
              icon: Icons.history,
              title: "Purchase History",
              iconColor: const Color(0xFFF59E0B),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PurchaseHistoryScreen()),
              ),
            ),

            _buildMenuTile(
              icon: Icons.help_outline,
              title: "Help & Support",
              iconColor: const Color(0xFF10B981),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              ),
            ),

            _buildMenuTile(
              icon: Icons.settings,
              title: "Settings",
              iconColor: const Color(0xFFA855F7),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              ),
            ),

            _buildMenuTile(
              icon: Icons.logout,
              title: "Logout",
              iconColor: Colors.redAccent,
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: ClipOval(
        child: _hasSelectedAvatar
            ? Image.asset(_selectedAvatarPath, fit: BoxFit.cover)
            : const Icon(Icons.person, size: 60, color: Color(0xFF6366F1)),
      ),
    );
  }

  Widget _buildModernButton(String label, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontSize: 15,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black12),
      ),
    );
  }
}

// --- KEEPING YOUR PAYMENT SCREEN LOGIC ---
class PaymentMethodScreen extends StatelessWidget {
  final String email;
  const PaymentMethodScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Select Payment mode",
          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _paymentTile(Icons.credit_card, "Add a Card", "Pay via Cards", context),
            _paymentTile(Icons.account_balance, "Bank Transfer", "Direct Transfer", context),
            _paymentTile(Icons.account_balance_wallet, "Digital Wallets", "Go Pay, OVO, etc", context),
            const SizedBox(height: 40),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Total", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$9.99", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(IconData icon, String title, String subtitle, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
      ),
      child: ListTile(
        onTap: () => _showProcessing(context),
        leading: Icon(icon, color: const Color(0xFF6366F1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 20),
      ),
    );
  }

  void _showProcessing(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF6366F1))),
    );
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showSuccess(context);
    });
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 80),
            const SizedBox(height: 20),
            const Text("PAYMENT SUCCESS!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
              child: const Text("DONE", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}