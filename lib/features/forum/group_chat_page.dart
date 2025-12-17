import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/services/authentication.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final GroupData group;

  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();
  List<MessageData> messages = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (widget.group.uuid == null) {
      if (mounted) {
        setState(() {
          errorMessage = "Group UUID is missing";
        });
      }
      return;
    }

    if (!mounted) return;
    
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedMessages = await apiService.fetchMessages(widget.group.uuid!);
      if (mounted) {
        setState(() {
          messages = fetchedMessages;
          // Sort messages by created_at (oldest first)
          messages.sort((a, b) {
            if (a.created_at == null || b.created_at == null) return 0;
            return a.created_at!.compareTo(b.created_at!);
          });
        });

        // Scroll to bottom after messages are loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CbsColors.primaryBrown,
        foregroundColor: CbsColors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name ?? 'Groupe',
              style: smallStyle18.copyWith(
                color: CbsColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.group.online_count != null && widget.group.online_count! > 0)
              Text(
                '${widget.group.online_count} en ligne',
                style: smallStyle18.copyWith(
                  fontSize: 12,
                  color: CbsColors.white.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchMessages,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: CbsColors.errorColor[100],
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: CbsColors.errorColor),
                  gapW8,
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: smallStyle18.copyWith(color: CbsColors.errorColor),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        errorMessage = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading && messages.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: CbsColors.primaryBrown.withValues(alpha: 0.5),
                            ),
                            gapH16,
                            Text(
                              'Aucun message',
                              style: smallStyle18.copyWith(
                                color: CbsColors.primaryBrown,
                              ),
                            ),
                            gapH8,
                            Text(
                              'Soyez le premier à envoyer un message',
                              style: smallStyle18.copyWith(
                                color: CbsColors.hintColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchMessages,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            // Skip deleted messages
                            if (message.is_deleted == true) {
                              return const SizedBox.shrink();
                            }
                            return _MessageBubble(message: message);
                          },
                        ),
                      ),
          ),
          // TODO: Add message input field here when sending messages is implemented
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageData message;

  const _MessageBubble({required this.message});

  String _formatTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else if (difference.inDays == 1) {
        return "Hier ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else {
        return "${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.sender_name != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 8),
              child: Row(
                children: [
                  Text(
                    message.sender_name!,
                    style: smallStyle18.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                  gapW8,
                  if (message.created_at != null)
                    Text(
                      _formatTime(message.created_at),
                      style: smallStyle18.copyWith(
                        fontSize: 10,
                        color: CbsColors.hintColor,
                      ),
                    ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CbsColors.primaryBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: CbsColors.primaryBrown.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.content != null)
                  Text(
                    message.content!,
                    style: smallStyle18.copyWith(
                      color: CbsColors.primaryDark[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

