import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/data/message/user_data.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/auth_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatPage extends StatefulWidget {
  final GroupData group;

  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final SupabaseService apiService = SupabaseService();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  List<MessageData> messages = [];
  bool isLoading = false;
  bool isSending = false;
  String? errorMessage;

  String _dateKey(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    final date = DateTime.tryParse(dateString);
    if (date == null) return '';
    final local = date.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _dateLabel(
    AppLocalizations l10n,
    String localeName,
    String? dateString,
  ) {
    if (dateString == null || dateString.isEmpty) return '';
    final date = DateTime.tryParse(dateString)?.toLocal();
    if (date == null) return '';
    final messageDay = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (messageDay == today) return l10n.today;
    if (messageDay == yesterday) {
      return l10n.yesterday;
    }
    return DateFormat(l10n.chatDateFormatPattern, localeName).format(date);
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {
    if (widget.group.uuid == null) {
      if (mounted) {
        final l10n =
            AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
        setState(() {
          errorMessage = l10n.groupUuidMissing;
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
      final fetchedMessages =
          await apiService.fetchMessages(widget.group.uuid!);
      if (mounted) {
        setState(() {
          messages = fetchedMessages;
          // Sort messages by timestamp (oldest first)
          messages.sort((a, b) {
            if (a.timestamp == null || b.timestamp == null) return 0;
            return a.timestamp!.compareTo(b.timestamp!);
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
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final localeName = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name ?? l10n.unnamedGroup,
              style: smallStyle18.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (widget.group.online_count != null &&
                widget.group.online_count! > 0)
              Text(
                '${widget.group.online_count} ${l10n.online}',
                style: smallStyle18.copyWith(
                  fontSize: 12,
                  color: Theme.of(context)
                      .appBarTheme
                      .foregroundColor
                      ?.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: fetchMessages,
            tooltip: l10n.refresh,
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
                              color:
                                  CbsColors.primaryBrown.withValues(alpha: 0.5),
                            ),
                            gapH16,
                            Text(
                              l10n.noMessage,
                              style: smallStyle18.copyWith(
                                color: CbsColors.primaryBrown,
                              ),
                            ),
                            gapH8,
                            Text(
                              l10n.beFirstMessage,
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
                            final prevMessage =
                                index > 0 ? messages[index - 1] : null;
                            final showDateHeader = index == 0 ||
                                _dateKey(message.timestamp) !=
                                    _dateKey(prevMessage?.timestamp);
                            final isCurrentUser =
                                message.user?.uuid != null &&
                                    message.user!.uuid == AuthService.currentUser?.id;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (showDateHeader)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 4, bottom: 10),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: CbsColors.primaryBrown
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(999),
                                        ),
                                        child: Text(
                                          _dateLabel(
                                            l10n,
                                            localeName,
                                            message.timestamp,
                                          ),
                                          style: smallStyle18.copyWith(
                                            fontSize: 11,
                                            color: CbsColors.primaryBrown,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                _MessageBubble(
                                  message: message,
                                  l10n: l10n,
                                  isCurrentUser: isCurrentUser,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
          // Message input field
          _MessageInputField(
            controller: _messageController,
            focusNode: _messageFocusNode,
            onSend: _sendMessage,
            isSending: isSending,
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final content = _messageController.text.trim();
    if (content.isEmpty || widget.group.uuid == null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isSending = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.sendMessage(
        roomUuid: widget.group.uuid!,
        content: content,
      );

      if (result["success"] == true) {
        // Clear the input field
        _messageController.clear();

        // Refresh messages to show the new one
        await fetchMessages();

        if (mounted) {
          // Scroll to bottom to show new message
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
      } else {
        if (mounted) {
          setState(() {
            errorMessage = result["message"] ?? l10n.errorPrefix;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result["message"] ??
                  "${l10n.errorPrefix}: ${l10n.noMessage}"),
              backgroundColor: CbsColors.errorColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithDetails(e.toString())),
            backgroundColor: CbsColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }
}

class _MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isSending;

  const _MessageInputField({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isSending,
  });

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final composerBg = isDark ? CbsColors.darkCard : CbsColors.white;
    final inputFill =
        isDark ? CbsColors.darkSurface : CbsColors.backgroundColor;
    final inputText = isDark ? CbsColors.darkText : CbsColors.primaryDark[700];
    final inputHint = isDark ? CbsColors.darkHint : CbsColors.hintColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: composerBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: l10n.chatMessageHint,
                  hintStyle: smallStyle18.copyWith(color: inputHint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide:
                        BorderSide(color: CbsColors.primaryBrown, width: 2),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  filled: true,
                  fillColor: inputFill,
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: smallStyle18.copyWith(color: inputText),
              ),
            ),
            gapW8,
            Container(
              decoration: BoxDecoration(
                color: CbsColors.primaryBrown,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: isSending
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(CbsColors.white),
                        ),
                      )
                    : const Icon(Icons.send, color: CbsColors.white),
                onPressed: isSending ? null : onSend,
                tooltip: l10n.send,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageData message;
  final AppLocalizations l10n;
  final bool isCurrentUser;

  const _MessageBubble({
    required this.message,
    required this.l10n,
    required this.isCurrentUser,
  });

  String _getDisplayNameForUser(UserData? user) {
    if (user == null) return l10n.unknownUser;
    final firstName = user.firstName?.trim() ?? '';
    final lastName = user.lastName?.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isNotEmpty ? fullName : (user.email ?? l10n.unknownUser);
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final localeCode = l10n.locale.languageCode;
      return DateFormat.Hm(localeCode).format(date.toLocal());
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final align = isCurrentUser
        ? CrossAxisAlignment.start
        : CrossAxisAlignment.end;
    final metaAlign =
        isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end;
    final bubbleColor = isCurrentUser
        ? CbsColors.primaryBrown.withValues(alpha: 0.1)
        : CbsColors.brandDeepBlue.withValues(alpha: 0.14);
    final borderColor = isCurrentUser
        ? CbsColors.primaryBrown.withValues(alpha: 0.2)
        : CbsColors.brandDeepBlue.withValues(alpha: 0.22);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (message.user != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
              child: Row(
                mainAxisAlignment: metaAlign,
                children: [
                  Text(
                    _getDisplayNameForUser(message.user),
                    style: smallStyle18.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                  gapW8,
                  if (message.timestamp != null)
                    Text(
                      _formatTime(message.timestamp),
                      style: smallStyle18.copyWith(
                        fontSize: 10,
                        color: CbsColors.hintColor,
                      ),
                    ),
                ],
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
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
          ),
        ],
      ),
    );
  }
}
