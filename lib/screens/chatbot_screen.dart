// ChatbotScreen - AI wellness assistant chat interface
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isExpanded = false;
  List<Map<String, dynamic>> messages = [
    {"text": "Hi! I'm your ZenWave guide. How are you feeling today?", "isSender": false},
  ];

  String _currentEmotion = "Neutral";
  double _audioValue = 0.5;
  bool _isLoading = false;
  bool _isPlaying = false;
  int _currentBPM = 72;

  static const Color zenPurple = Color(0xFF9147FF);
  static const Color borderLight = Color(0xFFE5E5E5);

  Future<void> _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "isSender": true});
      _isLoading = true;
      _isExpanded = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          messages.add({"text": data['reply'], "isSender": false});
          _currentEmotion = data['emotion'].toString();
          _currentBPM = (_currentEmotion.toUpperCase() == "STRESSED") ? 108 : (_currentEmotion.toUpperCase() == "JOY" ? 85 : 72);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent, 
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("ZEN ASSISTANT", 
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 2)),
      ),
      body: Column(
        children: [
          // CHAT AREA
          Expanded(
            flex: _isExpanded ? 10 : 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: borderLight, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => _buildChatBubble(messages[index]),
                ),
              ),
            ),
          ),

          // TOOLS AREA (Stats & Exercises)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded ? 80 : 340,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildInputArea(),
                  if (!_isExpanded) ...[
                    const SizedBox(height: 8),
                    _buildCurrentState(),
                    _buildBreathingExerciseCard(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(Map msg) {
    bool isMe = msg['isSender'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? zenPurple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          border: Border.all(color: isMe ? zenPurple : borderLight, width: 2),
          boxShadow: [
            BoxShadow(color: isMe ? const Color(0xFF7030D8) : borderLight, offset: const Offset(0, 3))
          ],
        ),
        child: Text(
          msg['text'],
          style: TextStyle(
            fontSize: 15, 
            fontWeight: FontWeight.w700,
            color: isMe ? Colors.white : Colors.black87
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderLight, width: 2),
        boxShadow: const [BoxShadow(color: borderLight, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isExpanded ? Icons.keyboard_arrow_down_rounded : Icons.bolt_rounded, color: Colors.orange),
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              onTap: () => setState(() => _isExpanded = true),
              decoration: const InputDecoration(hintText: "Type a message...", border: InputBorder.none),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: zenPurple),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildDuoStateBox("MOOD", _currentEmotion.toUpperCase(), const Color(0xFFF3E5F5), zenPurple)),
          const SizedBox(width: 12),
          Expanded(child: _buildDuoStateBox("HEART", "$_currentBPM BPM", const Color(0xFFE8F5E9), Colors.green)),
        ],
      ),
    );
  }

  Widget _buildDuoStateBox(String label, String value, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textCol.withOpacity(0.2), width: 2),
        boxShadow: [BoxShadow(color: textCol.withOpacity(0.1), offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: textCol.withOpacity(0.5))),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textCol)),
        ],
      ),
    );
  }

  Widget _buildBreathingExerciseCard() {
    return GestureDetector(
      onTap: () => _showExerciseMenu(context),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
          boxShadow: const [BoxShadow(color: Color(0xFFBBDEFB), offset: Offset(0, 4))],
        ),
        child: const Row(
          children: [
            CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.air_rounded, color: Colors.blue)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("BREATHING SESSION", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.blue)),
                  Text("Start a 2-minute relaxation", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                ],
              ),
            ),
            Icon(Icons.play_circle_fill_rounded, color: Colors.blue, size: 32),
          ],
        ),
      ),
    );
  }

  void _showExerciseMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: borderLight, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("QUICK RELIEF", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 20),
            _menuItem(context, "Box Breathing", "Stabilize & Focus", Colors.teal),
            _menuItem(context, "4-7-8 Technique", "Calm Anxiety", Colors.deepPurple),
            _menuItem(context, "Coherent Breathing", "Heart Sync", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, String sub, Color col) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderLight, width: 2),
      ),
      child: ListTile(
        leading: Icon(Icons.spa_rounded, color: col),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(sub, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => BreathingSessionScreen(exerciseType: title)));
        },
      ),
    );
  }
}

// --- UPGRADED BREATHING SESSION ---
class BreathingSessionScreen extends StatefulWidget {
  final String exerciseType;
  const BreathingSessionScreen({super.key, required this.exerciseType});

  @override
  State<BreathingSessionScreen> createState() => _BreathingSessionScreenState();
}

class _BreathingSessionScreenState extends State<BreathingSessionScreen> {
  String _label = "GET READY";
  double _scale = 1.0;
  Color _mainColor = Colors.blue;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _runCycle();
  }

  @override
  void dispose() { _isRunning = false; super.dispose(); }

  void _runCycle() async {
    while (_isRunning) {
      if (!mounted) break;
      _mainColor = (widget.exerciseType == "Box Breathing") ? Colors.teal : (widget.exerciseType == "4-7-8 Technique" ? Colors.deepPurple : Colors.blue);
      
      await _phase("INHALE", 1.8, 4); if (!_isRunning) break;
      if (widget.exerciseType != "Coherent Breathing") await _phase("HOLD", 1.8, 4); if (!_isRunning) break;
      await _phase("EXHALE", 1.0, 5); if (!_isRunning) break;
      await _phase("REST", 1.0, 2);
    }
  }

  Future<void> _phase(String label, double scale, int seconds) async {
    if (!mounted) return;
    setState(() { _label = label; _scale = scale; });
    await Future.delayed(Duration(seconds: seconds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.exerciseType.toUpperCase(), 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: _mainColor, letterSpacing: 2)),
            const SizedBox(height: 100),
            
            // THE BREATHING CIRCLE
            TweenAnimationBuilder(
              duration: const Duration(seconds: 4),
              tween: Tween<double>(begin: 1.0, end: _scale),
              builder: (context, double val, child) {
                return Container(
                  width: 200 * val,
                  height: 200 * val,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _mainColor.withOpacity(0.1),
                    border: Border.all(color: _mainColor, width: 6),
                    boxShadow: [BoxShadow(color: _mainColor.withOpacity(0.2), blurRadius: 40, spreadRadius: 10 * val)],
                  ),
                  child: Center(
                    child: Text(_label, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: _mainColor)),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 150),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _mainColor, width: 2),
                  boxShadow: [BoxShadow(color: _mainColor.withOpacity(0.2), offset: const Offset(0, 4))],
                ),
                child: Text("FINISHED", style: TextStyle(fontWeight: FontWeight.w900, color: _mainColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}