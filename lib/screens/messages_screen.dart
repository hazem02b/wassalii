import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/message_service.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final MessageService _messageService = MessageService();
  List<dynamic> conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    setState(() => _isLoading = true);
    try {
      final data = await _messageService.getConversations();
      setState(() {
        conversations = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de chargement: ${e.toString()}')),
        );
      }
    }
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final time = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(time);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}j';
      } else {
        return DateFormat('dd/MM').format(time);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.surfaceColor,
        iconTheme: IconThemeData(color: context.textPrimary),
        title: Text(
          AppLocalizations.of(context).messages,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: context.textPrimary),
            onPressed: () {
              // Recherche
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: context.textPrimary),
            onPressed: _loadConversations,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9800)))
          : conversations.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return _buildConversationCard(conversation);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 100,
            color: context.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).noConversations,
            style: TextStyle(
              fontSize: 18,
              color: context.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).startConversation,
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(Map<String, dynamic> conversation) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  otherUserId: conversation['other_user_id'],
                  otherUserName: conversation['other_user_name'] ?? 'Utilisateur',
                ),
              ),
            ).then((_) => _loadConversations()); // Recharger après retour
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar avec badge online
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFFFF9800),
                      child: Text(
                        (conversation['other_user_name'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Contenu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            conversation['other_user_name'] ?? 'Utilisateur',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: (conversation['unread_count'] ?? 0) > 0
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: context.textPrimary,
                            ),
                          ),
                          Text(
                            _formatTime(conversation['last_message_time'] ?? ''),
                            style: TextStyle(
                              fontSize: 12,
                              color: (conversation['unread_count'] ?? 0) > 0
                                  ? const Color(0xFFFF9800)
                                  : context.textSecondary,
                              fontWeight: (conversation['unread_count'] ?? 0) > 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              conversation['last_message_content'] ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: (conversation['unread_count'] ?? 0) > 0
                                    ? context.textPrimary
                                    : context.textSecondary,
                                fontWeight: (conversation['unread_count'] ?? 0) > 0
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if ((conversation['unread_count'] ?? 0) > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9800),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${conversation['unread_count']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
