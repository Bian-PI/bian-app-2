import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/services/gemini_service.dart';
import '../../core/utils/connectivity_service.dart';
import '../../core/widgets/custom_snackbar.dart';
import '../../core/localization/app_localizations.dart';

class AIChatScreen extends StatefulWidget {
  final String speciesType;
  final double overallScore;
  final Map<String, double> categoryScores;
  final List criticalPoints;
  final List strongPoints;
  final String language;
  final Map<String, dynamic> formResponses;
  final String farmName;
  final String farmLocation;

  const AIChatScreen({
    super.key,
    required this.speciesType,
    required this.overallScore,
    required this.categoryScores,
    required this.criticalPoints,
    required this.strongPoints,
    required this.language,
    required this.formResponses,
    required this.farmName,
    required this.farmLocation,
  });

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _AIChatScreenState extends State<AIChatScreen> {
  final GeminiService _geminiService = GeminiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  bool _isLoading = false;
  int _questionCount = 0;
  DateTime? _lastResetTime;
  Timer? _rateLimitTimer;
  static const int _maxQuestionsPerPeriod = 2;
  static const Duration _rateLimitPeriod = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    _loadRateLimitState();
    _sendWelcomeMessage();
    _startRateLimitTimer();
  }

  Future<void> _loadRateLimitState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCount = prefs.getInt('ai_chat_question_count') ?? 0;
    final savedTimeMs = prefs.getInt('ai_chat_last_reset_time');

    setState(() {
      _questionCount = savedCount;
      if (savedTimeMs != null) {
        _lastResetTime = DateTime.fromMillisecondsSinceEpoch(savedTimeMs);
      } else {
        _lastResetTime = DateTime.now();
      }
    });
  }

  Future<void> _saveRateLimitState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ai_chat_question_count', _questionCount);
    if (_lastResetTime != null) {
      await prefs.setInt('ai_chat_last_reset_time', _lastResetTime!.millisecondsSinceEpoch);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _rateLimitTimer?.cancel();
    super.dispose();
  }

  void _startRateLimitTimer() {
    _rateLimitTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && _questionCount >= _maxQuestionsPerPeriod) {
        setState(() {
          _checkAndResetRateLimit();
        });
      }
    });
  }

  void _sendWelcomeMessage() {
    final loc = AppLocalizations(Locale(widget.language));
    final welcomeText = loc.translate('ai_chat_welcome_message', ['${widget.overallScore.toStringAsFixed(0)}']);

    setState(() {
      _messages.add(ChatMessage(
        text: welcomeText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> _checkAndResetRateLimit() async {
    final now = DateTime.now();
    if (_lastResetTime != null &&
        now.difference(_lastResetTime!) >= _rateLimitPeriod) {
      setState(() {
        _questionCount = 0;
        _lastResetTime = now;
      });
      await _saveRateLimitState();
    }
  }

  bool _canSendMessage() {
    _checkAndResetRateLimit();
    return _questionCount < _maxQuestionsPerPeriod;
  }

  String _getRemainingTimeText() {
    if (_lastResetTime == null) return '';

    final now = DateTime.now();
    final timeSinceReset = now.difference(_lastResetTime!);
    final timeRemaining = _rateLimitPeriod - timeSinceReset;

    if (timeRemaining.isNegative) return '';

    final minutes = timeRemaining.inMinutes;
    final seconds = timeRemaining.inSeconds % 60;

    final loc = AppLocalizations(Locale(widget.language));
    return loc.translate('wait_time_format', ['$minutes', '$seconds']);
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (!_canSendMessage()) {
      final loc = AppLocalizations(Locale(widget.language));
      CustomSnackbar.showWarning(
        context,
        loc.translate('rate_limit_reached', [_getRemainingTimeText()]),
      );
      return;
    }

    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    final hasConnection = await connectivityService.checkConnection();

    if (!hasConnection) {
      if (!mounted) return;
      final loc = AppLocalizations(Locale(widget.language));
      CustomSnackbar.showError(
        context,
        loc.translate('need_internet_connection_ai'),
      );
      return;
    }

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _questionCount++;
    });

    await _saveRateLimitState();

    _messageController.clear();
    _scrollToBottom();

    try {
      final response = await _geminiService.chatAboutReport(
        userQuestion: message,
        speciesType: widget.speciesType,
        overallScore: widget.overallScore,
        categoryScores: widget.categoryScores,
        criticalPoints: widget.criticalPoints.map((e) => e.toString()).toList(),
        strongPoints: widget.strongPoints.map((e) => e.toString()).toList(),
        language: widget.language,
        formResponses: widget.formResponses,
        farmName: widget.farmName,
        farmLocation: widget.farmLocation,
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      print('❌ Error en chat: $e');
      if (mounted) {
        final loc = AppLocalizations(Locale(widget.language));
        setState(() {
          _messages.add(ChatMessage(
            text: loc.translate('ai_error_generating_response'),
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
          _questionCount--;
        });
        await _saveRateLimitState();
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_messages.length <= 1) {
      return true;
    }

    final loc = AppLocalizations(Locale(widget.language));
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: BianTheme.warningYellow, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                loc.translate('exit_question'),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          loc.translate('lose_progress_warning'),
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: BianTheme.errorRed,
            ),
            child: Text(loc.translate('exit')),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final remainingQuestions = _maxQuestionsPerPeriod - _questionCount;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                AppLocalizations(Locale(widget.language)).translate('ai_consultation'),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        backgroundColor: BianTheme.primaryRed,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(BianTheme.primaryRed),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations(Locale(widget.language)).translate('thinking_status'),
                    style: TextStyle(
                      color: BianTheme.mediumGray,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          if (remainingQuestions <= 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: remainingQuestions == 0
                    ? BianTheme.errorRed.withOpacity(0.08)
                    : BianTheme.warningYellow.withOpacity(0.08),
                border: Border(
                  top: BorderSide(
                    color: remainingQuestions == 0
                        ? BianTheme.errorRed.withOpacity(0.2)
                        : BianTheme.warningYellow.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    remainingQuestions == 0 ? Icons.schedule : Icons.info_outline,
                    size: 14,
                    color: remainingQuestions == 0
                        ? BianTheme.errorRed
                        : BianTheme.warningYellow,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      remainingQuestions == 0
                          ? AppLocalizations(Locale(widget.language)).translate('wait_for_more_questions', [_getRemainingTimeText()])
                          : AppLocalizations(Locale(widget.language)).translate('questions_remaining', ['$remainingQuestions']),
                      style: TextStyle(
                        fontSize: 11,
                        color: remainingQuestions == 0
                            ? BianTheme.errorRed
                            : BianTheme.darkGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !_isLoading && _canSendMessage(),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: AppLocalizations(Locale(widget.language)).translate('ask_something'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: BianTheme.lightGray.withOpacity(0.3),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: (_isLoading || !_canSendMessage())
                        ? LinearGradient(
                            colors: [Colors.grey.shade400, Colors.grey.shade500],
                          )
                        : LinearGradient(
                            colors: [BianTheme.primaryRed, BianTheme.primaryRed.withOpacity(0.8)],
                          ),
                    shape: BoxShape.circle,
                    boxShadow: (_isLoading || !_canSendMessage())
                        ? []
                        : [
                            BoxShadow(
                              color: BianTheme.primaryRed.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send_rounded,
                      color: (_isLoading || !_canSendMessage())
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                    ),
                    onPressed: (_isLoading || !_canSendMessage()) ? null : _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: message.isUser
            ? _buildUserMessage(message)
            : _buildAIMessage(message),
      ),
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BianTheme.primaryRed, BianTheme.primaryRed.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: BianTheme.primaryRed.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        message.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildAIMessage(ChatMessage message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BianTheme.lightGray.withOpacity(0.3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(
          color: BianTheme.lightGray.withOpacity(0.5),
        ),
      ),
      child: MarkdownBody(
        data: message.text,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(fontSize: 15, color: BianTheme.darkGray, height: 1.5),
          strong: TextStyle(fontWeight: FontWeight.bold, color: BianTheme.darkGray),
          em: TextStyle(fontStyle: FontStyle.italic),
          listBullet: TextStyle(fontSize: 15, color: BianTheme.primaryRed),
          h1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: BianTheme.darkGray),
          h2: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: BianTheme.darkGray),
          h3: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: BianTheme.darkGray),
          code: TextStyle(
            backgroundColor: BianTheme.lightGray.withOpacity(0.5),
            color: BianTheme.primaryRed,
            fontFamily: 'monospace',
          ),
          blockquote: TextStyle(
            color: BianTheme.mediumGray,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
