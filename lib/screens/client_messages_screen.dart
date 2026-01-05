import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/message_service.dart';
import '../services/booking_service.dart';
import '../utils/theme_extension.dart';
import '../utils/app_localizations.dart';
import 'chat_screen.dart';

class ClientMessagesScreen extends StatefulWidget {
  const ClientMessagesScreen({Key? key}) : super(key: key);

  @override
  State<ClientMessagesScreen> createState() => _ClientMessagesScreenState();
}

class _ClientMessagesScreenState extends State<ClientMessagesScreen> {
  final MessageService _messageService = MessageService();
  final BookingService _bookingService = BookingService();
  List<dynamic> conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      setState(() => _isLoading = true);
      final data = await _messageService.getConversations();
      if (!mounted) return;
      setState(() {
        conversations = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de chargement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showNewConversationDialog() async {
    // Récupérer les réservations pour obtenir la liste des transporteurs
    try {
      final bookings = await _bookingService.getMyBookings();
      if (!mounted) return;
      
      // Extraire les transporteurs uniques
      final transporters = <int, Map<String, dynamic>>{};
      for (var booking in bookings) {
        if (booking['trip'] != null && booking['trip']['transporter'] != null) {
          final transporter = booking['trip']['transporter'];
          final transporterId = transporter['id'];
          if (!transporters.containsKey(transporterId)) {
            transporters[transporterId] = {
              'id': transporterId,
              'name': transporter['full_name'] ?? 'Transporteur',
              'email': transporter['email'] ?? '',
            };
          }
        }
      }

      if (transporters.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vous n\'avez pas encore de réservations avec des transporteurs'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Afficher le dialogue de sélection
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context).newMessage),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: transporters.length,
              itemBuilder: (context, index) {
                final transporter = transporters.values.elementAt(index);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4CAF50),
                    child: Text(
                      (transporter['name'] as String)[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(transporter['name']),
                  subtitle: Text(transporter['email']),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          otherUserId: transporter['id'],
                          otherUserName: transporter['name'],
                        ),
                      ),
                    ).then((_) => _loadConversations());
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context).cancel),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final time = DateTime.parse(isoDate);
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
        title: Text(
          'Messages',
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
            icon: Icon(Icons.more_vert, color: context.textPrimary),
            onPressed: () {
              // Options
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: context.primaryColor,
              ),
            )
          : conversations.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return _buildConversationCard(conversation);
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showNewConversationDialog,
        backgroundColor: context.primaryColor,
        icon: const Icon(Icons.message),
        label: Text(AppLocalizations.of(context).newMessage),
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
            color: context.textSecondary,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).noConversations,
            style: TextStyle(
              fontSize: 18,
              color: context.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vos messages apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationCard(dynamic conversation) {
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
            ).then((_) => _loadConversations());
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFF2196F3), // Bleu pour client
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
                                  ? context.primaryColor
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
                                color: context.primaryColor,
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

// Écran de conversation individuelle pour client
class ClientChatScreen extends StatefulWidget {
  final Map<String, dynamic> conversation;

  const ClientChatScreen({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    // Messages de démonstration
    messages = [
      {
        'id': '1',
        'text': 'Bonjour! Je suis intéressé par votre trajet Tunis-Sfax',
        'sender': 'me',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': '2',
        'text': 'Bonjour! Oui, le trajet est toujours disponible.',
        'sender': 'transporter',
        'time': DateTime.now().subtract(const Duration(hours: 2, minutes: 58)),
      },
      {
        'id': '3',
        'text': 'Parfait! Est-ce que je peux réserver une place?',
        'sender': 'me',
        'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
      },
      {
        'id': '4',
        'text': 'Bien sûr! Il reste 3 places disponibles.',
        'sender': 'transporter',
        'time': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
      },
      {
        'id': '5',
        'text': 'Super! Je réserve tout de suite.',
        'sender': 'me',
        'time': DateTime.now().subtract(const Duration(minutes: 5)),
      },
    ];

    // Auto-scroll vers le bas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _messageController.text,
        'sender': 'me',
        'time': DateTime.now(),
      });
    });

    _messageController.clear();

    // Auto-scroll vers le bas
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF2196F3), // Bleu
                  child: Text(
                    widget.conversation['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.conversation['online'])
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation['name'],
                    style: const TextStyle(
                      color: Color(0xFF2D3748),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (widget.conversation['online'])
                    const Text(
                      'En ligne',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Color(0xFF2D3748)),
            onPressed: () {
              // Appel
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF2D3748)),
            onPressed: () {
              // Options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isMe = message['sender'] == 'me';

                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          // Input
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
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: Color(0xFF718096),
                  ),
                  onPressed: () {
                    // Pièce jointe
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Tapez votre message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3), // Bleu
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF2196F3), // Bleu
              child: Text(
                widget.conversation['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF2196F3) : Colors.white, // Bleu pour client
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isMe ? const Radius.circular(16) : Radius.zero,
                      bottomRight:
                          isMe ? Radius.zero : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message['text'],
                    style: TextStyle(
                      color: isMe ? Colors.white : const Color(0xFF2D3748),
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMessageTime(message['time']),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
