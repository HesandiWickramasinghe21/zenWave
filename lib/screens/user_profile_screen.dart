import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'privacy_screen.dart';
import 'purchase_history_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const Color zenPurple = Color(0xFF6A1B9A);
  static const Color zenAccent = Color(0xFF6366F1);
  static const Color bgLight = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

Future<void> _loadUserData() async {
  try {
    // 1. Get API data first
    final data = await ApiService.profile();
    
    // 2. Get saved avatar second
    final prefs = await SharedPreferences.getInstance();
    final String? savedAvatar = prefs.getString('user_avatar_path');

    if (!mounted) return;

    setState(() {
      // Set API data
      final String fullName = data["full_name"]?.toString() ?? "User";
      _firstName = fullName.split(' ').first;
      _email = data["email"]?.toString() ?? "zen@member.com";

      if (savedAvatar != null && savedAvatar.isNotEmpty) {
        _selectedAvatarPath = savedAvatar;
        _hasSelectedAvatar = true; // This tells the UI to show the image
      }
      
      _isLoading = false;
    });
  } catch (e) {
    debugPrint("Profile Loading Error: $e");
    // Even if API fails, try to load the avatar anyway
    final prefs = await SharedPreferences.getInstance();
    final String? savedAvatar = prefs.getString('user_avatar_path');
    
    if (mounted) {
      setState(() {
        if (savedAvatar != null) {
          _selectedAvatarPath = savedAvatar;
          _hasSelectedAvatar = true;
        }
        _isLoading = false;
      });
    }
  }
}

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to leave ZenWave?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false),
            child: const Text("Logout", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("CHOOSE YOUR AVATAR", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black45, letterSpacing: 2, fontSize: 12)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 20, mainAxisSpacing: 20,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                final String path = "assets/avatar/avatar${index + 1}.png";
                return GestureDetector(
                onTap: () async { 
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('user_avatar_path', path);
                  print("Successfully saved avatar: $path");
                  setState(() {
                    _selectedAvatarPath = path;
                    _hasSelectedAvatar = true;
                  });
                  Navigator.pop(context);
                },
                  child: CircleAvatar(
                    backgroundColor: zenAccent.withOpacity(0.1),
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
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: zenAccent)));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("MY PROFILE", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [bgLight, Color(0xFFEEF2FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight + 60),
                _buildHeader(),
                const SizedBox(height: 32),
                _buildUpgradeCard(),
                const SizedBox(height: 32),
                _buildMenuSection(),
                const SizedBox(height: 140), // Large spacer to clear Nav Bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: zenAccent.withOpacity(0.1), blurRadius: 20)],
                color: Colors.white,
              ),
              child: _buildProfileImage(55),
            ),
            GestureDetector(
              onTap: _showAvatarPicker,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: zenPurple, shape: BoxShape.circle),
                child: const Icon(Icons.edit_rounded, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(_firstName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
        const SizedBox(height: 4),
        Text(_email, style: const TextStyle(color: Colors.black45, fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _buildUpgradeCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isPro ? [const Color(0xFF10B981), const Color(0xFF059669)] : [zenPurple, zenAccent],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_isPro ? const Color(0xFF10B981) : zenPurple).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentMethodScreen(email: _email)),
            );
            if (result == true) setState(() => _isPro = true);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                _isPro ? "PRO ACCOUNT ACTIVE" : "UPGRADE TO PRO",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuTile(Icons.shield_outlined, "Privacy & Security", const Color(0xFF3B82F6), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyScreen()))),
        _buildMenuTile(Icons.history, "Purchase History", const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PurchaseHistoryScreen()))),
        _buildMenuTile(Icons.help_outline, "Help & Support", const Color(0xFF10B981), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
        _buildMenuTile(Icons.settings, "Settings", const Color(0xFFA855F7), () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()))),
        const SizedBox(height: 12),
        const Divider(color: Colors.black12),
        const SizedBox(height: 12),
        _buildMenuTile(Icons.logout_rounded, "Logout", Colors.redAccent, _showLogoutDialog),
      ],
    );
  }

  Widget _buildProfileImage(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFF1F5F9),
      backgroundImage: _hasSelectedAvatar ? AssetImage(_selectedAvatarPath) : null,
      child: !_hasSelectedAvatar ? Icon(Icons.person, size: radius * 0.8, color: zenAccent.withOpacity(0.5)) : null,
    );
  }

  Widget _buildMenuTile(IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155), fontSize: 14)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black12, size: 14),
      ),
    );
  }
}

// --- PAYMENT SCREEN ---
class PaymentMethodScreen extends StatelessWidget {
  final String email;
  const PaymentMethodScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Payment Method", style: TextStyle(color: Color(0xFF1E293B), fontSize: 16, fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SELECT PLAN", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 16),
            _paymentTile(Icons.credit_card, "Credit/Debit Card", "Pay with Visa or Mastercard", context),
            _paymentTile(Icons.account_balance, "Bank Transfer", "Instant bank verification", context),
            _paymentTile(Icons.wallet, "Digital Wallets", "Apple Pay, GPay, or PayPal", context),
            const Spacer(),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Monthly Subscription", style: TextStyle(fontSize: 14, color: Colors.black54)),
                  Text("\$9.99", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF6366F1))),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(IconData icon, String title, String subtitle, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        onTap: () => _showProcessing(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Icon(icon, color: const Color(0xFF6366F1)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black45)),
        trailing: const Icon(Icons.add_circle_outline, color: Colors.black12),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.stars_rounded, color: Color(0xFF10B981), size: 80),
            const SizedBox(height: 24),
            const Text("YOU'RE PRO!", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            const SizedBox(height: 8),
            const Text("Enjoy all premium features.", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Return success to profile
                },
                child: const Text("LFG!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}