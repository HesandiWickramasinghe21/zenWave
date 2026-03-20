import 'package:flutter/material.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  static const Color primary = Color(0xFF9147FF);
  static const Color bg = Color(0xFFF7F8FA);

  // TODO: Replace with real API data when backend is ready
  // Call: GET /purchases  with Authorization: Bearer <token>
  // Expected response: { "purchases": [ { "id", "plan", "amount", "date", "status" } ] }
  final List<Map<String, dynamic>> _purchases = []; // Empty = no purchases yet

  bool _loading = false; // Set to true and call API when backend is ready

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1C1033)),
          ),
        ),
        title: const Text(
          'Purchase History',
          style: TextStyle(color: Color(0xFF1C1033), fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : _purchases.isEmpty
              ? _buildEmptyState()
              : _buildPurchaseList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 56,
                color: primary.withOpacity(0.4),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'No Purchases Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1C1033),
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Your purchase history will appear here once you upgrade to a ZenWave plan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 36),

            // CTA Button
            GestureDetector(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/home',
                (route) => false,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                        color: primary.withOpacity(0.35),
                        offset: const Offset(0, 6),
                        blurRadius: 12),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'VIEW PLANS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Secondary — free plan badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.green[400], size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    'Currently on Free Explorer',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF4B4B4B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- This widget renders when _purchases is NOT empty (future use) ---
  Widget _buildPurchaseList() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primary.withOpacity(0.2), width: 1.5),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: primary, size: 24),
            ),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Active Plan',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
              const Text('Zen Master',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1C1033))),
            ]),
          ]),
        ),

        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text('TRANSACTIONS',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 1)),
        ),

        ..._purchases.map((p) => _purchaseTile(p)),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _purchaseTile(Map<String, dynamic> purchase) {
    final bool isActive = purchase['status'] == 'active';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.receipt_rounded,
              color: isActive ? Colors.green : Colors.grey, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(purchase['plan'] ?? 'Plan',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1C1033))),
            Text(purchase['date'] ?? '',
                style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w500)),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(purchase['amount'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1C1033))),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isActive ? 'Active' : 'Expired',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive ? Colors.green[700] : Colors.grey),
            ),
          ),
        ]),
      ]),
    );
  }
}
