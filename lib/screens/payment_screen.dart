import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final String email;
  const PaymentScreen({super.key, required this.email});

  // 1. This shows the Google Play Style Sheet
  void _showSystemPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFFF7F7F7),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.bottom(20),
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            Row(
              children: [
                const Icon(Icons.play_arrow_rounded, color: Color(0xFF00E676), size: 30),
                const SizedBox(width: 12),
                const Text("Google Play", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
            const Divider(height: 32, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ZenWave Pro (Monthly)", style: TextStyle(fontSize: 16, color: Colors.black87)),
                const Text("\$9.99", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_circle, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(email, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 32),
            // GOOGLE PLAY STYLE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01875F), // Official Play Store Green
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context); // Close the Bottom Sheet
                _showSuccessDialog(context); // Show the Checkmark Dialog
              },
              child: const Text(
                "1-TAP BUY",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // 2. This shows the Success Checkmark
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.check_circle_rounded, color: Color(0xFF58CC02), size: 90),
            const SizedBox(height: 24),
            const Text(
              "PAYMENT SUCCESS!",
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF4B4B4B)),
            ),
            const SizedBox(height: 12),
            const Text(
              "Your ZenWave Pro account is now active. Enjoy your journey!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 32),
            // This button takes the user back to the Profile
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Close Dialog
                Navigator.pop(context, true); // Close Payment Screen & return TRUE to Profile
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0xFF46A302), offset: Offset(0, 4))],
                ),
                child: const Center(
                  child: Text(
                    "AWESOME",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black26, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.auto_awesome, size: 100, color: Color(0xFFFFB800)),
            const SizedBox(height: 24),
            const Text(
              "UNLOCK ZENWAVE PRO",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF4B4B4B), letterSpacing: 1),
            ),
            const SizedBox(height: 16),
            _buildFeatureRow(Icons.chat_bubble_rounded, "Unlimited AI Counseling"),
            _buildFeatureRow(Icons.description_rounded, "Deep Mental Health Insights"),
            _buildFeatureRow(Icons.do_not_disturb_on_rounded, "Ad-Free Experience"),
            const Spacer(),
            // MAIN PAY NOW BUTTON
            GestureDetector(
              onTap: () => _showSystemPaymentSheet(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [BoxShadow(color: Color(0xFF46A302), offset: Offset(0, 5))],
                ),
                child: const Center(
                  child: Text(
                    "PAY NOW",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1CB0F6), size: 24),
          const SizedBox(width: 16),
          Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF777777))),
        ],
      ),
    );
  }
}