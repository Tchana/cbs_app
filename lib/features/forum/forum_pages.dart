import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/features/forum/group_chat_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final SupabaseService apiService = SupabaseService();
  final DataController dataController = Get.find<DataController>();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (dataController.groups.isEmpty) {
      fetchGroups();
    }
  }

  Future<void> fetchGroups() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final groups = await apiService.fetchGroups();
      if (mounted) {
        dataController.setGroups(groups);
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

  Future<void> _showCreateGroupDialog() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final messenger = ScaffoldMessenger.of(context);
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const _CreateRoomPage()),
    );
    if (created == true) {
      if (!mounted) return;
      await fetchGroups();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.groupCreatedSuccess),
          backgroundColor: CbsColors.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.forum,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: fetchGroups,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchGroups,
        child: Column(
          children: [
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CbsColors.errorColor[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: CbsColors.errorColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: CbsColors.errorColor),
                      gapW8,
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: smallStyle18.copyWith(
                            color: CbsColors.errorColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: isLoading && dataController.groups.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : dataController.groups.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.group_outlined,
                                  size: 64,
                                  color: CbsColors.primaryBrown
                                      .withValues(alpha: 0.5),
                                ),
                                gapH16,
                                Text(
                                  l10n.noGroups,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.primaryBrown,
                                  ),
                                ),
                                gapH8,
                                Text(
                                  l10n.createFirst,
                                  style: smallStyle18.copyWith(
                                    color: CbsColors.hintColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Obx(
                          () => ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                            itemCount: dataController.groups.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 10,
                              thickness: 1,
                              color: CbsColors.primaryBrown
                                  .withValues(alpha: 0.10),
                            ),
                            itemBuilder: (context, index) {
                              final group = dataController.groups[index];
                              if (group.is_deleted == true) {
                                return const SizedBox.shrink();
                              }
                              return _GroupCard(group: group);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGroupDialog,
        backgroundColor: CbsColors.primaryBrown,
        icon: const Icon(Icons.add, color: CbsColors.white),
        label: Text(
          l10n.createGroup,
          style: smallStyle18.copyWith(color: CbsColors.white),
        ),
      ),
    );
  }
}

class _GroupCard extends StatefulWidget {
  final GroupData group;

  const _GroupCard({required this.group});

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _CreateRoomPage extends StatefulWidget {
  const _CreateRoomPage();

  @override
  State<_CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<_CreateRoomPage> {
  final SupabaseService _apiService = SupabaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPrivate = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupNameRequired)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await _apiService.createGroup(
        name: name,
        description: description,
        isPrivate: _isPrivate,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? l10n.groupCreateError),
            backgroundColor: CbsColors.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorPrefix}: $e'),
          backgroundColor: CbsColors.errorColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.createGroup,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.groups_rounded,
                      color: CbsColors.primaryBrown),
                  gapW8,
                  Expanded(
                    child: Text(
                      l10n.createFirst,
                      style: smallStyle18.copyWith(
                        fontSize: 13,
                        color: CbsColors.primaryBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapH16,
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.groupName,
                prefixIcon: const Icon(Icons.title_rounded),
                filled: true,
                fillColor: CbsColors.primaryBrown.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.description,
                prefixIcon: const Icon(Icons.description_outlined),
                alignLabelWithHint: true,
                filled: true,
                fillColor: CbsColors.primaryBrown.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              value: _isPrivate,
              onChanged: (v) => setState(() => _isPrivate = v),
              activeThumbColor: CbsColors.primaryBrown,
              title: Text(
                l10n.privateGroup,
                style: smallStyle18.copyWith(fontSize: 14),
              ),
              secondary: const Icon(Icons.lock_outline_rounded,
                  color: CbsColors.primaryBrown),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.20),
                ),
              ),
            ),
            gapH20,
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.add_rounded),
              label: Text(_isSubmitting ? l10n.loading : l10n.create),
              style: FilledButton.styleFrom(
                backgroundColor: CbsColors.primaryBrown,
                foregroundColor: CbsColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCardState extends State<_GroupCard> {
  final SupabaseService _apiService = SupabaseService();
  MessageData? _lastMessage;
  bool _isLoadingLastMessage = false;
  bool _hasVisibleMessages = false;

  @override
  void initState() {
    super.initState();
    _fetchLastMessage();
  }

  Future<void> _fetchLastMessage() async {
    if (widget.group.uuid == null) return;

    setState(() {
      _isLoadingLastMessage = true;
    });

    try {
      final messages = await _apiService.fetchMessages(widget.group.uuid!);
      if (mounted) {
        final visibleMessages = messages
            .where(
              (m) =>
                  m.is_deleted != true &&
                  (m.content ?? '').trim().isNotEmpty,
            )
            .toList();
        visibleMessages.sort((a, b) {
          if (a.timestamp == null || b.timestamp == null) return 0;
          return b.timestamp!.compareTo(a.timestamp!); // newest first
        });
        setState(() {
          _hasVisibleMessages = visibleMessages.isNotEmpty;
          _lastMessage = visibleMessages.isNotEmpty ? visibleMessages.first : null;
          _isLoadingLastMessage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLastMessage = false;
        });
      }
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else if (difference.inDays == 1) {
        return "Hier";
      } else if (difference.inDays < 7) {
        return "Il y a ${difference.inDays}j";
      } else {
        return "${date.day}/${date.month}";
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Material(
      color: CbsColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupChatPage(group: widget.group),
            ),
          );
          if (mounted) {
            await _fetchLastMessage();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.group,
                  color: CbsColors.primaryBrown,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.group.name ?? l10n.unnamedGroup,
                            style: largeStyle32Bold.copyWith(
                              fontSize: 17,
                              color: CbsColors.primaryBrown,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.group.is_private == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  CbsColors.primaryBrown.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 12,
                                  color: CbsColors.primaryBrown,
                                ),
                                gapW4,
                                Text(
                                  l10n.private,
                                  style: smallStyle18.copyWith(
                                    fontSize: 10,
                                    color: CbsColors.primaryBrown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLoadingLastMessage
                          ? l10n.loading
                          : (_hasVisibleMessages
                              ? (_lastMessage?.content ?? l10n.noMessage)
                              : l10n.noMessage),
                      style: smallStyle18.copyWith(
                        fontSize: 13,
                        color: CbsColors.hintColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_lastMessage?.timestamp != null)
                Text(
                  _formatTime(_lastMessage!.timestamp),
                  style: smallStyle18.copyWith(
                    fontSize: 11,
                    color: CbsColors.hintColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
