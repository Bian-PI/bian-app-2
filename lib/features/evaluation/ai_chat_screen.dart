import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/theme/bian_theme.dart';
import '../../core/services/gemini_service.dart';
import '../../core/utils/connectivity_service.dart';
import '../../core/widgets/custom_snackbar.dart';

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
    _lastResetTime = DateTime.now();
    _sendWelcomeMessage();
    _startRateLimitTimer();
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
    final welcomeText = widget.language == 'es'
        ? '¡Hola! 👋 Soy tu asistente de bienestar animal.\n\nHe analizado tu reporte (${widget.overallScore.toStringAsFixed(0)}% de cumplimiento). Puedes hacerme **2 preguntas cada 5 minutos** sobre:\n\n• Recomendaciones específicas\n• Cómo mejorar puntos críticos\n• Mejores prácticas\n• Interpretación de resultados\n\n¿En qué puedo ayudarte?'
        : 'Hi! 👋 I\'m your animal welfare assistant.\n\nI\'ve analyzed your report (${widget.overallScore.toStringAsFixed(0)}% compliance). You can ask me **2 questions every 5 minutes** about:\n\n• Specific recommendations\n• How to improve critical points\n• Best practices\n• Results interpretation\n\nHow can I help you?';

    setState(() {
      _messages.add(ChatMessage(
        text: welcomeText,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _checkAndResetRateLimit() {
    final now = DateTime.now();
    if (_lastResetTime != null &&
        now.difference(_lastResetTime!) >= _rateLimitPeriod) {
      setState(() {
        _questionCount = 0;
        _lastResetTime = now;
      });
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

    return widget.language == 'es'
        ? 'Espera ${minutes}m ${seconds}s'
        : 'Wait ${minutes}m ${seconds}s';
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    if (!_canSendMessage()) {
      CustomSnackbar.showWarning(
        context,
        widget.language == 'es'
            ? 'Límite alcanzado. ${_getRemainingTimeText()} para más preguntas'
            : 'Limit reached. ${_getRemainingTimeText()} for more questions',
      );
      return;
    }

    final connectivityService =
        Provider.of<ConnectivityService>(context, listen: false);
    final hasConnection = await connectivityService.checkConnection();

    if (!hasConnection) {
      if (!mounted) return;
      CustomSnackbar.showError(
        context,
        widget.language == 'es'
            ? 'Necesitas conexión a internet'
            : 'You need internet connection',
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
        setState(() {
          _messages.add(ChatMessage(
            text: widget.language == 'es'
                ? '❌ Error al generar respuesta. Por favor intenta de nuevo.'
                : '❌ Error generating response. Please try again.',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
          _questionCount--;
        });
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

  @override
  Widget build(BuildContext context) {
    final remainingQuestions = _maxQuestionsPerPeriod - _questionCount;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.language == 'es'
                    ? 'Consulta con IA'
                    : 'AI Consultation',
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
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(BianTheme.primaryRed),
                  ),
                  SizedBox(width: 12),
                  Text(
                    widget.language == 'es'
                        ? 'Pensando...'
                        : 'Thinking...',
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      remainingQuestions == 0
                          ? (widget.language == 'es'
                              ? 'Espera ${_getRemainingTimeText()} para más preguntas'
                              : 'Wait ${_getRemainingTimeText()} for more questions')
                          : (widget.language == 'es'
                              ? '$remainingQuestions pregunta restante'
                              : '$remainingQuestions question remaining'),
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
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
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
                      hintText: widget.language == 'es'
                          ? 'Pregunta algo...'
                          : 'Ask something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: BianTheme.lightGray.withOpacity(0.3),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
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
                              offset: Offset(0, 2),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            offset: Offset(0, 2),
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
      padding: EdgeInsets.all(16),
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
