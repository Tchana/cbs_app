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
    return '${local.year}-${local.month}-${local.day}';
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
    if (messageDay == yesterday) return l10n.yesterday;
    return DateFormat(l10n.chatDateFormatPattern, localeName).format(date);
  }

  bool _isSameSender(MessageData? a, MessageData? b) {
    if (a == null || b == null) return false;
    final aId = a.user?.uuid;
    final bId = b.user?.uuid;
    if (aId == null || bId == null) return false;
    return aId == bId;
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
        setState(() => errorMessage = l10n.groupUuidMissing);
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetched = await apiService.fetchMessages(widget.group.uuid!);
      if (!mounted) return;
      setState(() {
        messages = fetched
          ..sort((a, b) {
            if (a.timestamp == null || b.timestamp == null) return 0;
            return a.timestamp!.compareTo(b.timestamp!);
          });
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      if (mounted) setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final content = _messageController.text.trim();
    if (content.isEmpty || widget.group.uuid == null) return;

    setState(() {
      isSending = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.sendMessage(
        roomUuid: widget.group.uuid!,
        content: content,
      );
      if (result['success'] == true) {
        _messageController.clear();
        await fetchMessages();
      } else if (mounted) {
        setState(() => errorMessage = result['message'] ?? l10n.errorPrefix);
      }
    } catch (e) {
      if (mounted) setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final localeName = Localizations.localeOf(context).toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandIvory,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            _GroupAvatar(
              name: widget.group.name ?? l10n.unnamedGroup,
              isDark: isDark,
              size: 40,
            ),
            gapW10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.group.name ?? l10n.unnamedGroup,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: smallStyle18.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  if ((widget.group.description ?? '').trim().isNotEmpty)
                    Text(
                      widget.group.description!.trim(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontSize: 12,
                        color: isDark
                            ? CbsColors.darkTextSecondary
                            : CbsColors.caramel,
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
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
          if (errorMessage != null) _ErrorBanner(message: errorMessage!),
          Expanded(
            child: isLoading && messages.isEmpty
                ? Center(
                    child: CircularProgressIndicator(
                      color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                    ),
                  )
                : messages.isEmpty
                    ? _EmptyChatState(l10n: l10n, isDark: isDark)
                    : RefreshIndicator(
                        color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                        onRefresh: fetchMessages,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            if (message.is_deleted == true) {
                              return const SizedBox.shrink();
                            }
                            final prev =
                                index > 0 ? messages[index - 1] : null;
                            final next = index < messages.length - 1
                                ? messages[index + 1]
                                : null;
                            final showDate = index == 0 ||
                                _dateKey(message.timestamp) !=
                                    _dateKey(prev?.timestamp);
                            final isMe = message.user?.uuid != null &&
                                message.user!.uuid ==
                                    AuthService.currentUser?.id;
                            final showMeta = !_isSameSender(message, prev) ||
                                showDate;
                            final isLastInGroup =
                                !_isSameSender(message, next);

                            return Column(
                              children: [
                                if (showDate)
                                  _DateChip(
                                    label: _dateLabel(
                                      l10n,
                                      localeName,
                                      message.timestamp,
                                    ),
                                    isDark: isDark,
                                  ),
                                _MessageBubble(
                                  message: message,
                                  l10n: l10n,
                                  localeName: localeName,
                                  isCurrentUser: isMe,
                                  showMeta: showMeta,
                                  isLastInGroup: isLastInGroup,
                                  isDark: isDark,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
          ),
          _MessageComposer(
            controller: _messageController,
            focusNode: _messageFocusNode,
            onSend: _sendMessage,
            isSending: isSending,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _GroupAvatar extends StatelessWidget {
  const _GroupAvatar({
    required this.name,
    required this.isDark,
    this.size = 48,
  });

  final String name;
  final bool isDark;
  final double size;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      return (s.length >= 2 ? s.substring(0, 2) : s).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark ? CbsColors.darkElevated : CbsColors.sandLight,
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(
          color: isDark
              ? CbsColors.goldDeep.withValues(alpha: 0.55)
              : CbsColors.creamDark,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: smallStyle18.copyWith(
          fontWeight: FontWeight.w800,
          fontSize: size * 0.34,
          color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      color: CbsColors.errorColor.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: CbsColors.errorColor, size: 20),
          gapW8,
          Expanded(
            child: Text(
              message,
              style: smallStyle18.copyWith(
                color: CbsColors.errorColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  const _EmptyChatState({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: isDark ? CbsColors.darkSurface : CbsColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? CbsColors.darkBorder
                      : CbsColors.creamDark,
                ),
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 40,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
            ),
            gapH16,
            Text(
              l10n.noMessage,
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryBrown,
              ),
            ),
            gapH8,
            Text(
              l10n.beFirstMessage,
              textAlign: TextAlign.center,
              style: smallStyle18.copyWith(
                fontSize: 14,
                color: isDark
                    ? CbsColors.darkTextSecondary
                    : CbsColors.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: isDark ? CbsColors.darkElevated : CbsColors.sandLight,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDark
                  ? CbsColors.darkBorder.withValues(alpha: 0.85)
                  : CbsColors.creamDark,
            ),
          ),
          child: Text(
            label,
            style: smallStyle18.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? CbsColors.darkTextSecondary
                  : CbsColors.brownMedium,
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.l10n,
    required this.localeName,
    required this.isCurrentUser,
    required this.showMeta,
    required this.isLastInGroup,
    required this.isDark,
  });

  final MessageData message;
  final AppLocalizations l10n;
  final String localeName;
  final bool isCurrentUser;
  final bool showMeta;
  final bool isLastInGroup;
  final bool isDark;

  String _displayName(UserData? user) {
    if (user == null) return l10n.unknownUser;
    final first = user.firstName?.trim() ?? '';
    final last = user.lastName?.trim() ?? '';
    final full = '$first $last'.trim();
    return full.isNotEmpty ? full : (user.email ?? l10n.unknownUser);
  }

  String _initials(UserData? user) {
    final name = _displayName(user);
    final parts = name.split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return '';
    try {
      return DateFormat.Hm(localeName)
          .format(DateTime.parse(dateString).toLocal());
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.78;
    final content = (message.content ?? '').trim();
    if (content.isEmpty) return const SizedBox.shrink();

    final bubbleBg = isCurrentUser
        ? (isDark ? CbsColors.brandGold : CbsColors.primaryBrown)
        : (isDark ? CbsColors.darkSurface : CbsColors.white);
    final bubbleText = isCurrentUser
        ? (isDark ? CbsColors.brownNight : CbsColors.brandIvory)
        : (isDark ? CbsColors.darkTextPrimary : CbsColors.primaryDark[800]);
    final metaColor = isDark ? CbsColors.darkTextMetadata : CbsColors.hintColor;
    final timeColor = isCurrentUser
        ? (isDark
            ? CbsColors.brownNight.withValues(alpha: 0.75)
            : CbsColors.brandIvory.withValues(alpha: 0.85))
        : metaColor;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(isCurrentUser ? 16 : (isLastInGroup ? 4 : 16)),
      bottomRight: Radius.circular(isCurrentUser ? (isLastInGroup ? 4 : 16) : 16),
    );

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bubbleBg,
        borderRadius: radius,
        border: isCurrentUser
            ? null
            : Border.all(
                color: isDark
                    ? CbsColors.darkBorder.withValues(alpha: 0.9)
                    : CbsColors.creamDark,
              ),
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: smallStyle18.copyWith(
              color: bubbleText,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          if (isLastInGroup && message.timestamp != null) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatTime(message.timestamp),
                style: verySmallStyle12.copyWith(
                  color: timeColor,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (isCurrentUser) {
      return Padding(
        padding: EdgeInsets.only(
          top: showMeta ? 8 : 2,
          bottom: isLastInGroup ? 6 : 2,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: bubble,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: showMeta ? 8 : 2, bottom: isLastInGroup ? 6 : 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showMeta)
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 2),
              child: CircleAvatar(
                radius: 16,
                backgroundColor:
                    isDark ? CbsColors.darkElevated : CbsColors.sandLight,
                child: Text(
                  _initials(message.user),
                  style: verySmallStyle12.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 40),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showMeta)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      _displayName(message.user),
                      style: smallStyle18.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                      ),
                    ),
                  ),
                bubble,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.isSending,
    required this.isDark,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final bool isSending;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? CbsColors.darkSurface : CbsColors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? CbsColors.darkBorder.withValues(alpha: 0.9)
                : CbsColors.creamDark,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  style: smallStyle18.copyWith(
                    color: isDark
                        ? CbsColors.darkTextPrimary
                        : CbsColors.primaryDark[800],
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.chatMessageHint,
                    hintStyle: smallStyle18.copyWith(
                      color: isDark
                          ? CbsColors.darkTextSecondary
                          : CbsColors.hintColor,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor:
                        isDark ? CbsColors.darkElevated : CbsColors.brandIvory,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: isDark
                            ? CbsColors.darkBorder
                            : CbsColors.creamDark,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: isDark
                            ? CbsColors.darkBorder
                            : CbsColors.creamDark,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide(
                        color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
              gapW8,
              Material(
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: isSending ? null : onSend,
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: Center(
                      child: isSending
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: isDark
                                    ? CbsColors.brownNight
                                    : CbsColors.white,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: isDark
                                  ? CbsColors.brownNight
                                  : CbsColors.white,
                              size: 22,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
